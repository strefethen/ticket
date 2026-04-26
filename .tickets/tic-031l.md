---
id: tic-031l
status: closed
deps: []
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 1
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - plugins/ticket-complete
---
# tk complete plugin — explicit release of all claims for a ticket

## Goal

Add tk complete <id> as the canonical 'I'm done editing files for this ticket' command. Releases all claims atomically; ticket status unchanged.

## Design

New plugins/ticket-complete script. SMEMBERS tk:repo:ticket-claims:TICKET. For each path: tk release TICKET path (existing plugin, idempotent). DEL the index key. Print summary 'released N files for <ticket>'. Idempotent on empty index.

## Acceptance Criteria

tk complete <id> emits a count and exits 0. Running it twice in a row: second run says 'released 0 files'. Audit stream shows release events for each path.

## Testing Obligations

Behave scenario: claim 2 files, run tk complete, verify both claims gone and audit stream has 2 release events with the expected ticket. Re-run, confirm idempotent.


## Notes

**2026-04-26T21:44:11Z**

Plugin written, executable, shellcheck clean. Symlink installed. tk help discovers with description. End-to-end: seeded 2 claims + index, tk complete released both (count: 2), keys gone, index DEL'd. Idempotent verified: second call returns 'released 0 files'.

**2026-04-26T21:44:11Z**

Closed: End-to-end test passed. Plugin discoverable, count accurate, idempotent.
