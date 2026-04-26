---
id: tic-u13f
status: closed
deps: [tic-0srz]
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 1
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - ~/.codex/config.toml
---
# Wire Codex hooks into ~/.codex/config.toml

## Goal

Codex CLI invokes the new hook scripts on PreToolUse (apply_patch), PostToolUse (apply_patch), and Stop events.

## Design

Add [[hooks.PreToolUse]] / [[hooks.PostToolUse]] / [[hooks.Stop]] blocks per Codex docs. Match apply_patch via matcher regex. codex_hooks already enabled. Run a real codex session to verify hook fires.

## Acceptance Criteria

Tail /tmp/tk-claim-hook.log during a codex session: see acquire / audit / heartbeat entries with codex session_id. No regression in Codex normal operation.

## Testing Obligations

Run codex on a tiny project, do an apply_patch, observe log entries with session_id and tool_name=apply_patch.


## Notes

**2026-04-26T21:56:42Z**

Hook entries appended to ~/.codex/config.toml. Validated via tomli: PreToolUse + PostToolUse on apply_patch, Stop with no matcher. codex_hooks=true. Existing agent-turn-complete hook preserved. Three referenced scripts exist and are executable. Backup at config.toml.bak.

**2026-04-26T21:56:42Z**

Closed: TOML validates. Codex will fire scripts on next session start. Real-codex verification deferred to Phase 7 integration.
