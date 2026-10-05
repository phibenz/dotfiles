"""Resolve shared local planning storage and exclude it from Git."""

import argparse
import fcntl
import json
from pathlib import Path
import re
import subprocess
import sys


STORE = Path("docs/work")
ARCHIVE = "archive"
FEATURE = re.compile(r"([0-9]{4,})-[a-z0-9]+(?:-[a-z0-9]+)*")


def feature_number(name: str) -> int | None:
    """Read a positive feature number from a padded folder name."""
    match = FEATURE.fullmatch(name)
    if match is None:
        return None
    number = int(match[1])
    if number < 1 or match[1] != f"{number:04d}":
        return None
    return number


def git(checkout: Path, *arguments: str) -> str:
    """Run Git in the given checkout and return its output."""
    result = subprocess.run(
        ["git", "-C", str(checkout), *arguments],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.rstrip("\n")


def resolve_context(checkout: Path, origin: Path | None = None) -> dict[str, str]:
    """Resolve a registered origin checkout that shares the Git repository."""
    checkout = Path(git(checkout, "rev-parse", "--show-toplevel")).resolve()
    common = Path(
        git(checkout, "rev-parse", "--path-format=absolute", "--git-common-dir")
    ).resolve()
    records = git(checkout, "worktree", "list", "--porcelain", "-z").split("\0\0")
    entries = [record.split("\0") for record in records if record]
    registered = {
        Path(entry[0].removeprefix("worktree ")).resolve()
        for entry in entries
        if "bare" not in entry
    }
    if origin is None:
        if not entries or "bare" in entries[0]:
            raise ValueError("Specify an origin checkout for a bare repository.")
        origin = Path(entries[0][0].removeprefix("worktree "))
    origin = origin.resolve()
    if entries and "bare" not in entries[0]:
        primary = Path(entries[0][0].removeprefix("worktree ")).resolve()
        if origin in registered and origin != primary:
            raise ValueError(
                "Use the primary origin checkout, not another PR worktree."
            )
    if origin not in registered:
        raise ValueError(
            "The origin must be a registered checkout of this repository."
        )
    origin_common = Path(
        git(origin, "rev-parse", "--path-format=absolute", "--git-common-dir")
    ).resolve()
    if origin_common != common:
        raise ValueError(
            "The origin and current checkout must share the Git repository."
        )
    store = origin / STORE
    if store.resolve() != store:
        raise ValueError("The planning folder must not redirect through a symlink.")
    return {
        "checkout": str(checkout),
        "origin": str(origin),
        "git_common_dir": str(common),
        "store": str(store),
    }


def initialize_feature(context: dict[str, str], feature: str) -> dict[str, str]:
    """Create an ignored feature folder without reusing reserved IDs."""
    number = feature_number(feature)
    origin = Path(context["origin"])
    store = Path(context["store"])
    folder = store / feature
    archive = store / ARCHIVE
    if number is None:
        raise ValueError("Use a padded feature folder such as 0003-request-client.")
    if folder.resolve() != folder:
        raise ValueError("The feature folder must not redirect through a symlink.")
    if archive.resolve() != archive:
        raise ValueError("The archive folder must not redirect through a symlink.")
    for checkout in {origin, Path(context["checkout"])}:
        if git(checkout, "ls-files", "--cached", "--", STORE.as_posix()):
            raise ValueError(
                "Planning files are already tracked or staged. "
                "Preserve them and resolve this before writing drafts."
            )
    exclude = Path(
        git(origin, "rev-parse", "--path-format=absolute", "--git-path", "info/exclude")
    )
    exclude.parent.mkdir(parents=True, exist_ok=True)
    with exclude.open("a+", encoding="utf-8") as stream:
        fcntl.flock(stream, fcntl.LOCK_EX)
        for location in (store, archive):
            if location.exists():
                for existing in location.iterdir():
                    reserved = feature_number(existing.name)
                    if reserved == number and existing != folder:
                        raise ValueError(
                            "This base number belongs to another feature. "
                            "Choose an unused ID."
                        )
        stream.seek(0)
        content = stream.read()
        if "/docs/work/" not in content.splitlines():
            separator = "\n" if content and not content.endswith("\n") else ""
            stream.write(separator + "/docs/work/\n")
            stream.flush()
        ignored = subprocess.run(
            [
                "git", "-C", str(origin), "check-ignore", "--quiet", "--no-index",
                "--", f"docs/work/{feature}/",
            ],
            check=False,
        )
        if ignored.returncode != 0:
            raise ValueError(
                "Git rules expose the planning folder. "
                "Resolve the ignore conflict before writing drafts."
            )
        folder.mkdir(parents=True, exist_ok=True)
        archive.mkdir(exist_ok=True)
    return {**context, "feature": str(folder)}


def main() -> int:
    """Print storage context or initialize an excluded feature folder."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["inspect", "init"])
    parser.add_argument("--cwd", type=Path, default=Path.cwd())
    parser.add_argument("--origin", type=Path)
    parser.add_argument("--feature")
    arguments = parser.parse_args()
    try:
        context = resolve_context(arguments.cwd, arguments.origin)
        if arguments.mode == "init":
            if arguments.feature is None:
                raise ValueError(
                    "Specify --feature when initializing planning storage."
                )
            context = initialize_feature(context, arguments.feature)
        print(json.dumps(context, indent=2))
        return 0
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        detail = (
            error.stderr.strip()
            if isinstance(error, subprocess.CalledProcessError)
            else str(error)
        )
        print(f"Error: {detail}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
