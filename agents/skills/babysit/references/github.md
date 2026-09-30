# Collect PR Evidence

Use the installed `gh` CLI with an explicit repository and PR number.
These reads do not authorize remote mutations.
For another GitHub host, use that host in every `--repo` value and pass `--hostname` to each API read.

## Read a complete snapshot

- Record the repository, PR URL, head repository, head branch, head commit, base, state, and collection time.
- Use `gh pr view <number> --repo <owner>/<repo> --json number,url,title,body,state,isDraft,headRefName,headRefOid,headRepository,headRepositoryOwner,baseRefName,baseRefOid,mergeable,mergeStateStatus,reviewDecision,reviewRequests` for identity and state.
- Collect all pages of each REST collection. `--slurp` returns an outer array of pages; retain or flatten all pages.

```text
gh api --method GET --paginate --slurp "repos/<owner>/<repo>/pulls/<number>/reviews?per_page=100"
gh api --method GET --paginate --slurp "repos/<owner>/<repo>/pulls/<number>/comments?per_page=100"
gh api --method GET --paginate --slurp "repos/<owner>/<repo>/issues/<number>/comments?per_page=100"
```

- Review bodies, inline comments, and general discussion contain different evidence. `gh pr view --comments` alone is insufficient.
- Retain comment IDs, URLs, authors, bodies, timestamps, reply relations, paths, line references, and reviewed commit IDs.
- Collect thread resolution and outdated status with the GraphQL query below. Save the query in a local or temporary file.
- Invoke it with `gh api graphql --paginate --slurp -F query=@<query-file> -f owner=<owner> -f name=<repo> -F number=<number>`.

```graphql
query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      headRefOid
      reviewThreads(first: 100, after: $endCursor) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          comments(first: 1) {
            nodes { databaseId url }
          }
        }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}
```

- The query collects thread metadata and its first comment ID. Read full replies from the paginated REST review comments, not that one-comment sample.
- Associate each thread's first comment with its REST comment ID. Follow `in_reply_to_id` to retain its complete conversation.
- Keep root comments and replies together. Do not discard resolved or outdated threads before checking whether their claims still apply.
- Read checks with `gh pr checks <number> --repo <owner>/<repo> --json name,state,bucket,link,workflow`.
- Read required checks separately with `--required`. Distinguish no configured required checks from failed, pending, or unavailable checks.
- Exit code `8` from `gh pr checks` means pending checks. Other nonzero results require inspection; do not infer authentication failure or code failure from exit status alone.
- Obtain failed check logs through their verified run or job links. Evidence from another head commit does not verify the current PR.
- Re-read PR identity after collection. If the head changed, refresh affected evidence before triage or readiness reporting.
- Recheck current head, reviews, thread state, and checks immediately before a readiness verdict or authorized remote action.
- Report API errors, GraphQL errors, missing pages, unmatched thread IDs, and unavailable logs as evidence gaps. Do not treat partial results as an empty review.
- Store snapshots with local evidence through the canonical origin paths when a feature exists. Exclude them from commits.

## References

- [GitHub CLI API pagination](https://cli.github.com/manual/gh_api)
- [GitHub CLI PR checks](https://cli.github.com/manual/gh_pr_checks)
