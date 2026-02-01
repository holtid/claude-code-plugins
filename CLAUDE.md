# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

Personal Claude Code plugin by Holger Tidemand. Provides MCP servers, code review tools, and safety-critical coding guidelines.

## Tech Stack

- **Go** - Backend services
- **TypeScript (React)** - Frontend applications

## Structure

```
.claude-plugin/
  marketplace.json        # Marketplace configuration
plugins/
  holgis/
    plugin.json           # Plugin manifest
    .mcp.json             # MCP server configurations
    .lsp.json             # LSP server configurations
    agents/               # Custom agent definitions
    skills/               # Skill definitions
Makefile                  # Installation commands
```

## Installation

```bash
make install    # Install plugin
make uninstall  # Uninstall plugin
make update     # Update plugin
```

## Skills

- `/holgis:commit` - Create a git commit with proper formatting
- `/holgis:review` - Multi-agent code review for finding bugs and issues
- `/holgis:explore` - Research standard library solutions, best practices, and codebase patterns before planning
- `/holgis:power-of-ten-go` - NASA/JPL Power of Ten rules for safety-critical Go code
- `/holgis:power-of-ten-ts` - NASA/JPL Power of Ten rules for safety-critical TypeScript/React code

## MCP Servers

### Sendify

Internal logistics server at `https://app.sendify.se/mcp`. Authenticate via `/mcp` command.

**Capabilities:** Create/manage shipments, compare rates, print labels, track shipments.

**Admin tools:** `get_search_log`, `get_failed_booking_logs`

### Context7

Library documentation lookup via `@upstash/context7-mcp`.

### Playwright

Browser automation via `@playwright/mcp`.

### Figma

Design system integration via `https://mcp.figma.com/mcp`.

## Versioning

Pre-commit hook auto-bumps `plugin.json` version when plugin files change.
