# AGENTS.md

Guidelines for AI coding agents working in this plugin repository.

## About This Repo

This is an AI coding assistant plugin for Sendify employees. It provides commands, agents, skills, and MCP/LSP configurations for both **Claude Code** and **OpenCode** platforms.

**This repo contains no application code** - only markdown files with YAML frontmatter and JSON configuration files.

## Repository Structure

```
.claude-plugin/           # Claude Code plugin
  agents/                 # Agent definitions (markdown)
  commands/               # Slash commands (markdown)
  skills/                 # Language-specific guidelines (markdown)
  .mcp.json               # MCP server configuration
  .lsp.json               # LSP server configuration
  plugin.json             # Plugin manifest (version here)
  marketplace.json        # Marketplace metadata

.opencode/                # OpenCode plugin (mirrors .claude-plugin/)
  agent/                  # Same as agents/
  command/                # Same as commands/
  skill/                  # Same as skills/
  opencode.json           # Combined MCP/LSP config

Makefile                  # Install/uninstall commands
CLAUDE.md                 # Claude Code guidance
README.md                 # Documentation
```

## File Formats

### Commands (`.claude-plugin/commands/*.md`)

```markdown
---
name: command-name
description: Brief description
allowed-tools: Bash(git diff:*), Read, Grep
argument-hint: "[optional hint]"
---

# Command instructions in markdown
```

### Commands (`.opencode/command/*.md`)

```markdown
---
description: Brief description
permission:
  bash:
    "git diff*": allow
---

# Command instructions in markdown
```

### Agents

```markdown
---
name: agent-name
description: Agent purpose
tools: Read, Grep, Glob
model: inherit
skills: skill-name-1, skill-name-2
---

# Agent instructions
```

### Skills

```markdown
---
name: skill-name
description: Skill description
---

# Skill content (guidelines, rules, examples)
```

## Key Commands

| Command | Description |
|---------|-------------|
| `make install` | Install for both Claude Code and OpenCode |
| `make claude-install` | Install for Claude Code only |
| `make opencode-install` | Install for OpenCode only |
| `make uninstall` | Uninstall from both platforms |

## Working with This Repo

### Adding a New Command

1. Create `.claude-plugin/commands/mycommand.md` with proper frontmatter
2. Create `.opencode/command/mycommand.md` (mirror with OpenCode frontmatter syntax)
3. Add command path to `.claude-plugin/plugin.json` commands array

### Adding a New Agent

1. Create `.claude-plugin/agents/myagent.md`
2. Create `.opencode/agent/myagent.md`
3. Add agent path to `.claude-plugin/plugin.json` agents array

### Adding a New Skill

1. Create `.claude-plugin/skills/myskill/SKILL.md`
2. Create `.opencode/skill/myskill/SKILL.md`

### Modifying MCP/LSP Configuration

- Claude Code: Edit `.claude-plugin/.mcp.json` and `.claude-plugin/.lsp.json`
- OpenCode: Edit `.opencode/opencode.json` (combined config)

## Important Notes

### Dual Platform Support

Files must be mirrored between `.claude-plugin/` and `.opencode/` with appropriate frontmatter syntax differences. Always update both when making changes.

### Versioning

The pre-commit hook automatically bumps the version in `.claude-plugin/plugin.json` when files in `.claude-plugin/` change. Ensure git hooks are configured:

```bash
git config core.hooksPath .githooks
```

### Testing Changes

After making changes, reinstall the plugin to test:

```bash
make install
```

Then use the commands/agents in a Sendify codebase to verify they work correctly.

## MCP Servers Configured

| Server | Type | Purpose |
|--------|------|---------|
| Sendify | Remote | Shipment management, carrier rates, labels, tracking |
| Context7 | Local (npx) | Library documentation lookup |
| Playwright | Local (npx) | Browser automation |
| Figma | Remote | Design system integration |

## LSP Servers Configured

| Server | Languages | Install Command |
|--------|-----------|-----------------|
| gopls | Go | `go install golang.org/x/tools/gopls@latest` |
| typescript-language-server | TS/JS | `npm i -g typescript-language-server typescript` |

## Style Guidelines for Plugin Content

When writing commands, agents, or skills:

- Use clear, imperative instructions
- Include example outputs where helpful
- For commands: define steps explicitly (Step 1, Step 2, etc.)
- For agents: specify exact output format expected
- For skills: provide code examples for each guideline
- Use `!` backtick syntax for inline shell context in commands (e.g., `!git branch --show-current`)

## Git Workflow

- Default review base branch: `develop`
- Pre-commit hook auto-bumps plugin version
- Keep commits focused on single changes
