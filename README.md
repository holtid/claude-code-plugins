# Holgis AI Plugin

Personal Claude Code plugin by Holger Tidemand.

## Quick Start

```bash
git clone https://github.com/holtid/ai-plugins.git
cd ai-plugins
git config core.hooksPath .githooks
make install
```

## Installation

```bash
make install
```

Or manually:
```bash
claude plugin marketplace add holtid/ai-plugins
claude plugin install holgis@ai-plugins
```

Enable auto-updates via `/plugin` > Marketplaces > ai-plugins > Enable auto-update.

### Uninstall

```bash
make uninstall
```

## Setup

After installation, authenticate with Sendify MCP:

1. Run `/mcp` in Claude Code
2. Click "Authenticate" next to Sendify
3. Log in with your Sendify credentials

## Commands

| Command | Description |
|---------|-------------|
| `/holgis:review` | Multi-agent code review (bugs, security, simplicity, Power of Ten) |
| `/holgis:explore` | Research solutions and patterns before planning |
| `/holgis:commit` | Create git commits |

### Review Examples

```
/holgis:review                     # Review changes vs develop branch
/holgis:review src/api/handler.go  # Review specific files
/holgis:review HEAD~3              # Review last 3 commits
```

## MCP Servers

| Server | Description |
|--------|-------------|
| **Sendify** | Shipment management, carrier rates, labels, tracking |
| **Context7** | Library documentation lookup |
| **Playwright** | Browser automation |
| **Figma** | Design system integration |

## Skills

Safety-critical coding guidelines adapted from NASA/JPL's "Power of Ten":

- `/holgis:power-of-ten-go` - Go-specific rules
- `/holgis:power-of-ten-ts` - TypeScript/React rules

## LSP Servers

| Server | Languages | Install |
|--------|-----------|---------|
| gopls | Go | `go install golang.org/x/tools/gopls@latest` |
| typescript-language-server | TS/JS | `npm i -g typescript-language-server typescript` |

## Development

For contributors working on the plugin itself:

```bash
git clone https://github.com/holtid/ai-plugins.git
cd ai-plugins
git config core.hooksPath .githooks
```

The pre-commit hook auto-bumps the plugin version when plugin files change.

## Optional: GitLab CLI

The `/build` command can create GitLab MRs automatically:

```bash
brew install glab
glab auth login
```
