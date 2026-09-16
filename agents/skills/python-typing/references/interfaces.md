# Interfaces and Data Contracts

## Behavior Without Inheritance

- A protocol defines the operations a consumer needs.
- Implementations satisfy it through compatible members, without inheriting from it.
- Return a protocol when the API intentionally hides implementation details; preserve a concrete type when callers need its additional capabilities.
- `runtime_checkable` checks member presence, not full type signatures; it is not a validation system.

```python
"""Accept compatible byte readers without requiring a shared base class."""

from io import BytesIO
from typing import Protocol


class ByteReader(Protocol):
    """Provide a bounded read operation."""

    def read(self, size: int = -1, /) -> bytes:
        """Read up to size bytes, or all remaining bytes."""
        ...


def read_header(source: ByteReader) -> bytes:
    """Read up to four header bytes from the source."""
    return source.read(4)


header = read_header(BytesIO(b"HEADbody"))
```

## Callback Signatures

- Use `Callable[[...], Result]` for a simple positional signature.
- Use a callable protocol when keyword-only parameters, parameter names, or overloads matter.

```python
"""Specify a callback whose keyword-only argument is part of its contract."""

from typing import Protocol


class ProgressReporter(Protocol):
    """Receive progress counts and an optional message."""

    def __call__(self, completed: int, *, message: str = "") -> None:
        """Report completed work with an optional message."""
        ...


def announce_start(report: ProgressReporter) -> None:
    """Report the initial progress state."""
    report(0, message="Starting")
```

## Preserve Decorated Signatures

- `ParamSpec` preserves positional and keyword parameters; a separate type parameter preserves the return type.
- This Python 3.12+ example declares the parameter specification with `**P`.
- `functools.wraps` preserves runtime metadata; the annotations preserve the static signature.

```python
"""Log calls without weakening a decorated function's type contract."""

from collections.abc import Callable
from functools import wraps
import logging
from typing import assert_type


def logged[**P, R](function: Callable[P, R]) -> Callable[P, R]:
    """Log each invocation and preserve the function's signature."""
    @wraps(function)
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        """Log the callable and forward its arguments."""
        logging.debug("Calling %r", function)
        return function(*args, **kwargs)

    return wrapper


@logged
def format_label(identifier: int, *, prefix: str = "job") -> str:
    """Format an identifier with a label prefix."""
    return f"{prefix}-{identifier}"


assert_type(format_label(7, prefix="build"), str)
```

## Input-Dependent Return Types

- Use unions for alternatives; use overloads to express which input produces which output.
- Prefer a generic when it expresses the same relationship more simply.
- In an ordinary module, provide at least two overload signatures followed by one compatible, annotated implementation.
- Overloads guide static checking; the implementation performs runtime branching.
- This example returns `str` for bytes and `None` only for `None`, without forcing callers to narrow both results.

```python
"""Preserve absence while decoding a byte string."""

from typing import assert_type, overload


@overload
def decode_text(value: bytes) -> str:
    """Decode a byte string as UTF-8."""
    ...


@overload
def decode_text(value: None) -> None:
    """Preserve an absent value."""
    ...


def decode_text(value: bytes | None) -> str | None:
    """Decode present bytes as UTF-8, or return None."""
    return None if value is None else value.decode("utf-8")


assert_type(decode_text(b"ready"), str)
assert_type(decode_text(None), None)
```

## Alias or Distinct Identity

- An alias improves readability but remains equivalent to the original type.
- `NewType` distinguishes otherwise interchangeable domain values for static checking.
- This Python 3.12+ example keeps user and project IDs separate.
- Use a runtime model or parser when values also need validation.

```python
"""Distinguish ID roles while naming a shared container shape."""

from typing import NewType

UserId = NewType("UserId", int)
ProjectId = NewType("ProjectId", int)
type Memberships = dict[ProjectId, set[UserId]]


def add_member(memberships: Memberships, project: ProjectId, user: UserId) -> None:
    """Add a user to the project's membership set."""
    memberships.setdefault(project, set()).add(user)
```

## Dictionary Shapes

- `TypedDict` records field names and types while retaining ordinary dictionaries at runtime.
- A missing key and a key whose value can be `None` are different contracts.
- The Python 3.11+ example permits a missing `display_name`, but not a `None` value.

```python
"""Represent a dictionary with one required field and one optional field."""

from typing import NotRequired, TypedDict


class UserPayload(TypedDict):
    """Describe a validated user payload."""

    identifier: int
    display_name: NotRequired[str]


def label(payload: UserPayload) -> str:
    """Return the display name or the user identifier."""
    return payload.get("display_name", str(payload["identifier"]))
```

## Sources

- [Structural and callback protocols](https://typing.python.org/en/latest/spec/protocol.html).
- [Parameter specifications](https://typing.python.org/en/latest/spec/generics.html#paramspec).
- [Overload contracts](https://typing.python.org/en/latest/spec/overload.html).
- [Aliases and NewType](https://docs.python.org/3/library/typing.html#newtype).
- [Typed dictionaries](https://typing.python.org/en/latest/spec/typeddict.html).
