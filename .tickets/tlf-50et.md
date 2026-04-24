---
id: tlf-50et
status: open
deps: []
links: []
created: 2026-04-24T22:00:33Z
type: feature
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
---
# Warn when writes: path has paired test file not in Testing Obligations

Migrated 2026-04-24 from fullstack-starter/fs-g7th (wrong repo home — this is ticket-lint plugin work, not fullstack-starter work).

Codex feedback (2026-04-24, after implementing first ticket). Proposed ticket-lint enhancement: for each path in writes:, derive likely test-file candidates using language conventions (Swift: XTests.swift; TS: X.test.ts / X.spec.ts / __tests__/X.ts; Go: X_test.go; Python: test_X.py; Rust: inline or tests/*.rs). If no candidate appears in the ## Testing Obligations section or in writes: itself, emit a WARN (not FAIL). Moderate complexity — encode one language at a time. Value: catches the concrete class of miss Codex hit: source in writes: without paired test cited in Testing Obligations.

