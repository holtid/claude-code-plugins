---
name: review
description: Multi-agent code review for finding bugs and issues
disable-model-invocation: true
---

Thorough code review using specialized agents for bug detection, security, and standards compliance.

## Context

- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Git status: !`git status --short`

## Process

### Step 1: Determine Scope & Get Diff

Review all new commits on current branch compared to develop. If no arguments provided, use `git diff develop...HEAD` to get all changed files.

If arguments provided, review those instead (staged changes, specific files, commit ranges, or single commits).

If no changes found, ask user what to review.

### Step 2: Gather Context & Summarize (Parallel)

**Context Agent (Haiku)**: Find CLAUDE.md/AGENTS.md files in root and reviewed directories.

**Summary Agent (Sonnet)**: Provide 2-3 sentence summary of changes, noting file types and scope (feature/bug/refactor).

### Step 3: Parallel Review (5 Agents)

Launch all 5 agents simultaneously, reviewing only code introduced in this change.

**Agent 1: CLAUDE.md Compliance (Sonnet)** - Quote exact rules violated.

**Agent 2: Bug Scan (Opus)** - Runtime crashes, nil panics, unchecked errors, logic errors only.

**Agent 3: Logic/Security (Opus)** - Security issues, incorrect logic, edge cases.

**Agent 4: Simplicity (Sonnet)** - Use `code-simplicity-reviewer` agent for YAGNI violations and over-engineering.

**Agent 5: Power of Ten (Sonnet)** - Use `power-of-ten-reviewer` agent for safety-critical rule violations.

**HIGH SIGNAL ONLY**: Flag only objective bugs, clear rule violations with quoted rules, and security vulnerabilities. Skip subjective concerns, "might be" issues, pre-existing problems, and anything requiring interpretation.

### Step 4: Batch Validation (4 Agents in Parallel)

Launch 4 Sonnet validators in parallel (one per Agent 2-5). Each validates all issues in their category, confirming high confidence.

**Skip Agent 1**: CLAUDE.md issues are objective if rule is quoted. No validation needed.

### Step 5: Filter & Aggregate

- Keep all CLAUDE.md/AGENTS.md issues from Agent 1 (no validation needed)
- Keep only validated issues from Agents 2-5
- Remove any issues rejected by validators
- Group by file
- Sort by severity (Critical > High > Medium > Low)

### Step 6: Output Report

```
## Code Review

**Summary:** [2-3 sentence summary from Step 2]

**Issues found:** [N]

[If issues exist:
### [Category] Issue Title
**File:** `path/file:line`
**Severity:** Critical/High/Medium/Low
[Description, including quoted rules for CLAUDE.md violations]
**Suggested fix:** [code or description]
]

[If no issues: "No issues found. Checked for bugs, security, CLAUDE.md compliance, and Power of Ten violations."]
```

## Notes

- Create todo list with 6 workflow steps before starting
- Agent 4 uses `code-simplicity-reviewer` (Sonnet), Agent 5 uses `power-of-ten-reviewer` (Haiku with language skills)
- Agents 2-5 batch-validated by category (1 validator per agent type)
- Cite exact CLAUDE.md/AGENTS.md rules when flagging violations
