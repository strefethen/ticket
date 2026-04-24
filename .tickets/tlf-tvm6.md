---
id: tlf-tvm6
status: in_progress
deps: []
links: []
created: 2026-04-24T22:18:15Z
type: feature
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
writes:
  - /Users/stevetrefethen/github/ticket-local-fixes/plugins/ticket-status
---
# Extend tk status with --stage flag and declared-but-not-modified check

Feedback from fs agent (2026-04-24) after using tk status during the fs-9tkt commit:

Observation: working tree accumulated 60+ uncommitted files from prior sessions (tickets, docs components, SQLite blob, plans, even sidebarTransform.ts itself). Staging had to be hand-curated file-by-file to avoid pulling in unrelated work. ~10 minutes auditing which untracked/modified files were mine vs. parallel work; two false starts on what sidebar.ts really contained.

Existing tk status <id> already classifies modified files as in-scope vs out-of-scope (writes: ∩ git diff). The gap is the inverse direction (declared but not yet modified) AND the productivity affordance (emit a ready-to-run git add command).

Proposed surface (extends ticket-status plugin, not a new command):

  tk status <id>           — current behavior (in-scope / out-of-scope reporter)
  tk status <id> --stage   — emit `git add <file1> <file2>` for the in-scope subset; warn on declared-but-not-modified (incomplete?); exit non-zero if any out-of-scope OR any declared-not-modified
  tk status <id> --json    — machine-readable shape for hook integration

The 'declared but not modified' check is the genuinely new logic. The --stage flag is the productivity affordance — eliminates the file-by-file curation when working in a multi-agent worktree. Composes with the existing scope-expansion protocol: if --stage shows out-of-scope files, the agent runs the protocol's tk add-note instead of staging.

Implementation: extend ~/github/ticket-local-fixes/plugins/ticket-status. Existing awk parser already extracts writes:; existing classifier already sorts in/out of scope. Add: (a) iterate writes: paths and diff against modified set to find declared-not-modified, (b) on --stage, emit git add command for in-scope-and-modified subset.

