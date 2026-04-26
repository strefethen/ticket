# ticket

> **Status:** Opinionated personal fork of [`wedow/ticket`](https://github.com/wedow/ticket).
> Upstream appears unmaintained as of April 2026; this fork is maintained as a working tool
> and is **not accepting external contributions**. The upstream relationship is preserved so
> cherry-picks can flow downstream if maintenance resumes — but no work from this fork is
> sent back upstream.

The git-backed issue tracker for AI agents. Rooted in the Unix Philosophy, `tk` is inspired by Joe Armstrong's [Minimal Viable Program](https://joearms.github.io/published/2014-06-25-minimal-viable-program.html) with additional quality of life features for managing and querying against complex issue dependency graphs.

`tk` was written as a full replacement for [beads](https://github.com/steveyegge/beads). It shares many similar commands but without the need for keeping a SQLite file in sync or a rogue background daemon mangling your changes. It ships with a `migrate-beads` command to make this a smooth transition.

## Why this fork

A few opinions that shape this fork beyond what upstream provides:

- **Agent-first.** Designed primarily for AI agents (Claude Code, Codex), not interactive humans. `CLAUDE.md` and `AGENTS.md` are first-class artifacts.
- **Backend opacity.** Storage is an implementation detail. The direction of travel is for agents to interact only through the `tk` CLI — no `$EDITOR`, no file paths, no awareness of the underlying format. This frees the project to evolve the backend without breaking agent workflows.
- **Redis-coordinated file claims.** Plugins (`tk claim`, `tk release`, `tk check`, `tk audit`) provide cross-agent file reservation so multiple agents working concurrently don't overwrite each other's edits. Lua-atomic acquire/release with a per-ticket index for enumeration.
- **Consolidated plugin suite.** Plugins that previously lived across multiple repos (`ticket-claim`, `ticket-release`, `ticket-audit`, `ticket-check`, `ticket-epics`, `ticket-lint`, `ticket-scope`, `ticket-work-on`/`work-off`, `ticket-query-docs`, `ticket-sidebar`) all ship from `plugins/` in this tree.
- **CI for verification, not distribution.** GitHub Actions run Behave tests and `shellcheck` on every push and pull request. No Homebrew tap, no AUR — install from source.

Internally, tickets are markdown files with YAML frontmatter in `.tickets/`. The CLI treats that storage as an implementation detail for agents while preserving plain-text searchability.

Using ticket IDs as file names also allows IDEs to quickly navigate to the ticket for you. For example, you might run `git log` in your terminal and see something like:

```
nw-5c46: add SSE connection management 
```

VS Code allows you to Ctrl+Click or Cmd+Click the ID and jump directly to the file to read the details.

## Install

**From source (auto-updates on git pull):**
```bash
git clone https://github.com/strefethen/ticket.git
cd ticket && ln -s "$PWD/ticket" ~/.local/bin/tk
```

**Or** just copy `ticket` to somewhere in your PATH.

## Requirements

`tk` is a portable bash script requiring only coreutils, so it works out of the box on any POSIX system with bash 3.2+ installed. Bundled plugins target the macOS system Bash as well; plugin JSON modes and the `query` command require `jq`. Uses `rg` (ripgrep) if available, falls back to `grep`.

## Agent Setup

Add this line to your `CLAUDE.md` or `AGENTS.md`:

```
This project uses a CLI ticket system for task management. Run `tk help` when you need to use it.
```

Claude Opus picks it up naturally from there. Other models may need additional guidance.

## Usage

```bash
tk - minimal ticket system with dependency tracking

Usage: tk <command> [args]

Commands:
  create [title] [options] Create ticket, prints ID
    -d, --description      Goal text (emits ## Goal)
    --goal                 Goal text (alias for --description)
    --design               Design notes
    --acceptance           Acceptance criteria
    --testing              Testing obligations
    --testing-obligations  Testing obligations (alias for --testing)
    -t, --type             Type (bug|feature|task|epic|chore) [default: task]
    -p, --priority         Priority 0-4, 0=highest [default: 2]
    -a, --assignee         Assignee [default: git user.name]
    --external-ref         External reference (e.g., gh-123, JIRA-456)
    --parent               Parent ticket ID
    --tags                 Comma-separated tags (e.g., --tags ui,backend,urgent)
    --plan                 Relative path to a planning .md file (traceability)
    --writes               Comma-separated paths the agent will edit (block sequence)
    --reads                Comma-separated paths the agent will read for context
    --supersedes           Comma-separated ticket ids this ticket replaces
  start <id> [-r reason]   Set status to in_progress (optional reason note)
  close <id> [-r reason]   Set status to closed (optional reason note)
  defer <id> [-r reason]   Set status to deferred (optional reason note)
  reopen <id> [-r reason]  Set status to open (optional reason note)
  status <id> <status> [-r reason]  Update status (open|in_progress|closed|deferred)
  dep <id> <dep-id>        Add dependency (id depends on dep-id)
  dep tree [--full] <id>   Show dependency tree (--full disables dedup)
  dep cycle                Find dependency cycles in open tickets
  undep <id> <dep-id>      Remove dependency
  link <id> <id> [id...]   Link tickets together (symmetric)
  unlink <id> <target-id>  Remove link between tickets
  ls|list [--status=X] [-a X] [-T X]   List tickets
  ready [-a X] [-T X]      List open/in-progress tickets with deps resolved
  blocked [-a X] [-T X]    List open/in-progress tickets with unresolved deps
  closed [--limit=N] [-a X] [-T X] List recently closed tickets (default 20, by mtime)
  show <id>                Display ticket
  add-note <id> [text]     Append timestamped note (or pipe via stdin)
  super <cmd> [args]       Bypass plugins, run built-in command directly

Official plugins in this repo:
  edit <id> [--goal TEXT] [--design TEXT] [--acceptance TEXT] [--testing TEXT]
                           Open ticket interactively or update body sections
  lint <id>                Validate a ticket against the handoff schema
  ls|list [--status=X] [-a X] [-T X]   List tickets
  query [jq-filter]        Output tickets as JSON, optionally filtered (requires jq)
  migrate-beads            Import tickets from .beads/issues.jsonl (requires jq)
  scope <id> [--stage|--json]  Show git-modified files classified by writes: scope

Searches parent directories for .tickets/ (override with TICKETS_DIR env var)
Supports partial ID matching (e.g., 'tk show 5c4' matches 'nw-5c46')
```

`tk edit` body-section flags mirror `tk create`: `-d`/`--description`/`--goal`
updates `## Goal`, `--design` updates `## Design`, `--acceptance` updates
`## Acceptance Criteria`, and `--testing`/`--testing-obligations` updates
`## Testing Obligations`. Section values may be inline text or `@-` for stdin.
Only one body section flag may read from stdin in a single command.
Automation should prefer `@-` for generated content and should not assemble or
replace complete ticket markdown files.
In non-TTY contexts, `tk edit <id>` requires section flags; it does not reveal
the underlying ticket file path or run an editor script as an automation API.

## Plugins

Executables named `tk-<cmd>` or `ticket-<cmd>` in your PATH are invoked automatically. This allows you to add custom commands or override built-in ones.

```bash
# Create a simple plugin
cat > ~/.local/bin/tk-hello <<'EOF'
#!/bin/bash
# tk-plugin: Say hello
echo "Hello from plugin!"
EOF
chmod +x ~/.local/bin/tk-hello

# Now it's available
tk hello        # runs tk-hello
tk help         # lists it under "Plugins"
```

**Plugin descriptions** (shown in `tk help`):
- Scripts: comment `# tk-plugin: description` in first 10 lines
- Binaries: `--tk-describe` flag outputs `tk-plugin: description`

**Plugin environment variables:**
- `TICKETS_DIR` - path to the .tickets directory (may be empty)
- `TK_SCRIPT` - absolute path to the tk script

**Calling built-ins from plugins:**
```bash
#!/bin/bash
# tk-plugin: Custom create with extras
id=$("$TK_SCRIPT" super create "$@")
echo "Created $id, doing extra stuff..."
```

Use `tk super <cmd>` to bypass plugins and run the built-in directly.

## Testing

The tests are written in the Behavior-Driven Development library [behave](https://behave.readthedocs.io/en/latest/) and require Python.

If you have `uv` [installed](https://docs.astral.sh/uv/getting-started/installation/) simply:

```sh
make test
```

## Migrating from Beads

```bash
tk migrate-beads

# review new files if you like
git status

# check state matches expectations
tk ready
tk blocked

# compare against
bd ready
bd blocked

# all good, let's go
git rm -rf .beads
git add .tickets
git commit -am "ditch beads"
```

For a thorough system-wide Beads cleanup, see [banteg's uninstall script](https://gist.github.com/banteg/1a539b88b3c8945cd71e4b958f319d8d).

## License

MIT
