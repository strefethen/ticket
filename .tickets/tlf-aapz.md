---
id: tlf-aapz
status: in_progress
deps: []
links: []
created: 2026-04-24T22:00:33Z
type: feature
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
writes:
  - /Users/stevetrefethen/github/ticket-local-fixes/plugins/ticket-lint
  - /Users/stevetrefethen/github/ticket-local-fixes/.tickets/tlf-aapz.md
  - /Users/stevetrefethen/github/ticket-local-fixes/.tickets/_sidebar.json
  - /Users/stevetrefethen/github/ticket-local-fixes/.tickets/index.md
  - /Users/stevetrefethen/github/ticket-local-fixes/.tickets/closed-tickets.md
---
# Add machine-readable closure metadata to tk close

Migrated 2026-04-24 from fullstack-starter/fs-3lqj (wrong repo home — this is tk-core work, not fullstack-starter work).

Codex feedback (2026-04-24). tk close -r '<reason>' is free-form; queryability of 'tickets closed in commit X' depends on author discipline. Proposed: first-class closure fields (commit_hash, branch, closed_by, closed_at, optional test_run_summary) persisted either in a ## Closure frontmatter block or at the top of ## Notes under a structured shape. Lighter interim: tk-lint warns if the close reason string doesn't contain a commit-hash-shaped substring. Skill requires hash in reason as of 2026-04-24 but has no enforcement.

## Goal

tk-lint gains a check that warns when a closed ticket's close reason does not reference a commit hash. Makes post-hoc queryability of "which tickets closed in commit X" less dependent on author vigilance without changing tk close's interface, tk's data shape, or existing closure-note format.

## Design

Scope this pass to the lighter-interim path. No new frontmatter fields, no change to tk close's flags, no change to the closure-note format. Pure lint addition.

ticket-lint's awk parser already reads body sections by heading. Extend it to also scan the body for Closed-reason lines emitted by `tk close -r "..."`. The existing closure format writes notes as:

```
## Notes

**<timestamp>**

Closed: <reason text>
```

Extract the LAST occurrence of `^Closed: ` in the body (last-match wins — captures the current closure reason even after a reopen+reclose cycle). Only evaluate the new check for tickets whose frontmatter `status:` is `closed`; open / in_progress / deferred tickets have nothing to check.

For closed tickets, the new `closure` check fires:

- If the reason text contains a commit-hash-shaped substring matching `[a-fA-F0-9]{7,40}` → `closure|pass` with detail citing the matched hash.
- Else if the reason text contains the case-insensitive phrase `no commit` → `closure|pass` with detail `"no commit" alternative`. Matches the skill-permitted alternative for closed-without-code tickets.
- Else → `closure|warn` with detail `reason missing commit-hash reference`. Does NOT fail the ticket overall (warn, not fail).

Regex precision: `[a-fA-F0-9]{7,40}` matches pure hex strings of 7-40 chars. tk ticket ids always contain a hyphen (e.g. `tlf-aapz`), so they never false-positive. The regex is permissive on shape — any 7+ char hex anywhere in the reason passes. That matches real-world references like `agent-skills@bf72bec`, `ticket-local-fixes@06c5409`, `ca716c3`, or `abcd1234ef567890`.

Output field position: insert the new check after `epic` and before `goal` in both pretty and JSON output. `epic` is also a frontmatter-driven check; grouping them reads cleanly.

## Acceptance Criteria

- A closed ticket whose latest `Closed:` reason contains a hash (e.g. `agent-skills@bf72bec`) → lint emits `closure|pass`.
- A closed ticket whose latest `Closed:` reason contains `no commit` (case-insensitive) → lint emits `closure|pass`.
- A closed ticket with a bare reason like `"won't do"` → lint emits `closure|warn` with detail `reason missing commit-hash reference`.
- An open / in_progress / deferred ticket → the new closure check does NOT emit (silent — nothing to check yet).
- The overall `pass`/`fail` outcome is unchanged by the closure check (warn status does not flip the overall verdict).
- No regression on existing checks (writes / plan / epic / goal / design / acceptance / testing).
- Shellcheck clean on the updated `plugins/ticket-lint` script.

## Testing Obligations

- Synthesize a scratch ticket directory with four fixtures: (a) closed + hash-in-reason, (b) closed + "no commit" in reason, (c) closed + bare reason, (d) open with no Notes. Run `tk lint --all` and verify pass / pass / warn / silent-on-closure respectively.
- Run `tk lint --all` against the fullstack-starter corpus where recent closures (this session's migration closures, fs-w8gc, fs-8o91, fs-4jeu) have commit hashes in their reasons. Expect: all closure checks pass; only older / hash-less closures warn.
- Run `tk lint --all` against the ticket-local-fixes corpus where tlf-pixm has a closure reason referencing commit hashes. Expect: tlf-pixm passes closure; open tlf-* tickets are silent on closure.
- Shellcheck clean: `shellcheck ~/github/ticket-local-fixes/plugins/ticket-lint`.
- Run `tk status tlf-aapz` before commit: verify `plugins/ticket-lint` and `.tickets/tlf-aapz.md` are both in-scope; no out-of-scope drift.

