---
id: tic-0srz
status: closed
deps: [tic-wj6s]
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 1
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - ~/.codex/hooks/codex-claim-acquire.sh
  - ~/.codex/hooks/codex-claim-audit.sh
  - ~/.codex/hooks/codex-claim-heartbeat.sh
---
# Codex hook scripts — apply_patch acquire, audit, heartbeat

## Goal

Codex agents get the same file-claim protection as Claude. Three scripts mirror Claude's hook chain but for Codex's apply_patch tool and JSON output shape.

## Design

codex-claim-acquire.sh: PreToolUse, parses tool_input.input (Codex apply_patch payload) to extract target file path; calls tk claim; returns Codex JSON {hookSpecificOutput.permissionDecision: deny} on block, or exit 2+stderr. codex-claim-audit.sh: PostToolUse XADD. codex-claim-heartbeat.sh: Stop, refreshes TTLs (mirror of Claude heartbeat).

## Acceptance Criteria

All three scripts executable, shellcheck clean, follow Codex's JSON-on-stdin / exit-2-blocks contract. Hand-test with synthetic stdin payloads matching Codex's documented format.

## Testing Obligations

Pipe sample Codex hook payload JSON to each script; verify expected exit codes and stderr/stdout. shellcheck -S error on all three.


## Notes

**2026-04-26T21:55:12Z**

All 3 Codex hook scripts written, executable, shellcheck clean. 6/6 synthetic-payload tests pass: Bash tool permitted, fail-open on no ticket, claim 2 paths from apply_patch, conflict block + rollback, audit XADD with agent=codex + 2 write-succeeded entries, heartbeat refreshes TTL via session→ticket map.

**2026-04-26T21:55:12Z**

Closed: All scripts at ~/.codex/hooks/codex-claim-{acquire,audit,heartbeat}.sh. Tested with file-based JSON fixtures (avoiding bash echo \n quirk). Ready for config.toml wiring in Phase 6.
