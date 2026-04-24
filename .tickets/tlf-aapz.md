---
id: tlf-aapz
status: open
deps: []
links: []
created: 2026-04-24T22:00:33Z
type: feature
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
---
# Add machine-readable closure metadata to tk close

Migrated 2026-04-24 from fullstack-starter/fs-3lqj (wrong repo home — this is tk-core work, not fullstack-starter work).

Codex feedback (2026-04-24). tk close -r '<reason>' is free-form; queryability of 'tickets closed in commit X' depends on author discipline. Proposed: first-class closure fields (commit_hash, branch, closed_by, closed_at, optional test_run_summary) persisted either in a ## Closure frontmatter block or at the top of ## Notes under a structured shape. Lighter interim: tk-lint warns if the close reason string doesn't contain a commit-hash-shaped substring. Skill requires hash in reason as of 2026-04-24 but has no enforcement.

