---
id: tic-i3zk
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
  - README.md
  - CLAUDE.md
  - AGENTS.md
---
# Documentation reframe — README, CLAUDE.md, AGENTS.md stop celebrating markdown-on-disk

## Goal

Rewrite README/CLAUDE.md/AGENTS.md so a fresh agent cannot infer the storage is markdown or where it lives. Word 'markdown' kept only as content-format reference, never as storage description.

## Design

Specific lines to rewrite: README's 'Internally, tickets are markdown files with YAML frontmatter in .tickets/' paragraph; remove the VS Code Cmd+Click hint; CLAUDE.md and AGENTS.md architecture sections describing markdown-files-on-disk. Migrate-beads section left alone (legitimate git ops, see plan decision 4).

## Acceptance Criteria

Fresh-agent read of README + CLAUDE.md + AGENTS.md gives no signal that storage is markdown or where it lives. .tickets/ appears only in migrate-beads git-operation context. 'markdown' appears only as content-format reference (e.g., 'ticket bodies use markdown formatting').

## Testing Obligations

Search: rg -i 'markdown|\.tickets' README.md CLAUDE.md AGENTS.md and verify each remaining occurrence is content-format or git-operation context. Re-read all three docs as if first-time and confirm no storage inference possible.


## Notes

**2026-04-26T23:07:36Z**

All 6 scrubs landed in commit a350054: line 23 paragraph removed, VS Code Cmd+Click hint removed, help dump regenerated (64 lines, current plugin list, no .tickets footer), tk-edit description reframed (markdown for formatting explicit), TICKETS_DIR description reframed as 'ticket store', CLAUDE.md+AGENTS.md ticket_path/yaml_field descriptions opacity-friendly. 148 Behave scenarios pass; shellcheck clean. The migrate-beads .tickets reference preserved per plan decision 4.

**2026-04-26T23:07:36Z**

Closed: All target docs (README, CLAUDE.md, AGENTS.md) clean of storage-leak language. Markdown-as-content-format clarification preserved throughout.
