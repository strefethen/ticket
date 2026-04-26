---
id: tic-xvj1
status: closed
deps: []
links: []
created: 2026-04-26T21:24:21Z
type: task
priority: 1
assignee: Steve Trefethen
parent: tic-0q87
tags: [epic:backend-opacity]
writes:
  - ticket
  - plugins/ticket-*
---
# Output sanitization — scrub paths and markdown refs from tk output

## Goal

Audit ticket script and every plugin for output strings revealing .tickets/ paths or .md filenames. Replace user-facing leaks with opaque language. Internal code references (file syscalls) stay.

## Design

grep -nE '\.tickets|\.md' ticket plugins/ticket-* and classify each hit. Anything inside a printf/echo/error message gets rewritten to use ticket IDs or abstract phrases ('ticket', 'storage'). Anything inside file ops stays.

## Acceptance Criteria

After this ticket: grep -rE '\.tickets|\.md' ticket plugins/ shows only legitimate internal refs. tk help footer no longer says 'Searches parent directories for .tickets/'. Common commands (show, ls, ready, blocked, query) emit no path-revealing text in success or error paths.

## Testing Obligations

grep verification command above must pass. Manual smoke: run tk show, tk ls, tk ready, tk blocked, tk show <bad-id> — capture output, confirm no path leaks. Behave scenarios still pass.


## Notes

**2026-04-26T21:28:07Z**

First scrub batch landed: tk help footer, init_tickets_dir errors, 3 plugin descriptions. Plugin-level audit continues.

**2026-04-26T21:38:13Z**

Audit complete: only remaining hit is ticket-sidebar:542 (docs-engine markdown link output, downstream consumer — not agent-facing CLI output, out of scope per plan). Acceptance criteria met: tk help footer clean, find_tickets_dir errors opaque, plugin descriptions scrubbed, all 148 Behave scenarios pass. Ready for closure review.

**2026-04-26T21:57:58Z**

Re-verified after agent-coordination epic merged: only remaining user-facing-string-style hit is plugins/ticket-sidebar:542 which generates [id](./id.md) docs-engine output (downstream consumer paths, not tk CLI output). Out of scope per plan.

**2026-04-26T21:57:58Z**

Closed: Acceptance met: tk help footer clean, error messages opaque, plugin descriptions scrubbed. Sidebar docs-output is downstream consumer format, intentionally retained.
