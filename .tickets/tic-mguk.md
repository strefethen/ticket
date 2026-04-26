---
id: tic-mguk
status: closed
deps: []
links: []
created: 2026-04-26T21:24:21Z
type: task
priority: 2
assignee: Steve Trefethen
parent: tic-0q87
tags: [epic:backend-opacity]
writes:
  - ticket
  - features/*.feature
  - features/steps/ticket_steps.py
---
# Field-level mutation CLI — first-class commands for every editable section

## Goal

Add per-field CLI commands so every operation possible via ticket-edit's flags is possible without invoking an editor or knowing the underlying format.

## Design

Add tk set-goal, set-design, set-acceptance, set-testing (replace section). Add tk append-design, append-acceptance (additive). Verify add-note covers append-notes. All accept inline value or @- stdin matching tk create conventions. Per-field naming (not unified tk set field value) for help-text discoverability — see plan decision 1.

## Acceptance Criteria

Every section currently editable via ticket-edit is settable via the new CLI without an editor. New Behave scenarios cover each command (set + append). Existing scenarios still pass. shellcheck -S error stays clean.

## Testing Obligations

make test passes. Run each new command manually on a sandbox ticket; verify output and resulting state. Behave scenarios for set-* and append-* added.


## Notes

**2026-04-26T23:20:58Z**

6 commands, 12 Behave scenarios, shellcheck clean. Built-in commands in ticket script — phase 4 can now remove ticket-edit plugin without losing coverage. Section values accept markdown content; @file inputs rejected; all error paths covered.

**2026-04-26T23:20:58Z**

Closed: Built-in field-level commands replace ticket-edit's role. 160/160 scenarios pass.
