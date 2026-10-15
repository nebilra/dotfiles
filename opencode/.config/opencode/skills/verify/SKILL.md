---
name: verify
description: Verify code changes before considering a task complete
---

# Verification Workflow

After implementing a non-trivial change:

1. Inspect the changed files.
2. Run the project's formatter if applicable.
3. Run linting.
4. Run type checking.
5. Run the most relevant tests.
6. If the change affects runtime behavior, perform an appropriate
   integration or runtime check.
7. Review the final diff.

Prioritize targeted verification over unnecessarily expensive full
test suites when the project supports it.

Do not claim a task is complete if an important verification step
was skipped.

If a check fails:

1. Determine whether the failure was caused by the change.
2. Fix the underlying issue.
3. Re-run the failed check.
4. Continue until the relevant checks pass or clearly report why
   they cannot be resolved.
