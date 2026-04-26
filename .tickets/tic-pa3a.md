---
id: tic-pa3a
status: closed
deps: [tic-mguk]
links: []
created: 2026-04-26T21:24:21Z
type: task
priority: 2
assignee: Steve Trefethen
parent: tic-0q87
tags: [epic:backend-opacity]
writes:
  - plugins/ticket-edit
  - README.md
  - CHANGELOG.md
  - features
---
# Remove ticket-edit plugin

## Goal

Delete the ticket-edit plugin entirely. No fallback, no deprecation per Steve's directive.

## Design

git rm plugins/ticket-edit. Remove all references from README (Plugins section), CHANGELOG (Plugins notes), plugin docs. Update or delete Behave scenarios that exercise ticket-edit. Verify tk edit returns the standard unknown-command error path.

## Acceptance Criteria

plugins/ticket-edit no longer exists. tk edit returns standard unknown-command error. grep -rE 'ticket-edit|tk edit' . matches only CHANGELOG history entries (intentional historical record).

## Testing Obligations

make test passes after Behave scenarios updated. Manual: tk edit <any-id> shows clean error. shellcheck still clean. All sections still mutable via Phase 3 commands.


## Notes

**2026-04-26T23:23:31Z**

ticket-edit plugin (250 lines) and its feature file (81 lines) deleted. Local ~/.local/bin/ticket-edit symlink removed. README ticket-edit description block deleted; CHANGELOG has Removed entry. tk edit now returns 'Unknown command: edit' (standard error path). 149 Behave scenarios pass; shellcheck clean. Net diff -331 lines.

**2026-04-26T23:23:31Z**

Closed: Plugin gone, coverage migrated to set-* tests, docs scrubbed. Source tree references to ticket-edit confined to CHANGELOG history (intentional).
