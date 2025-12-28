---
description: Multi-agent code review for staged or specified files
---

Provide a thorough code review using multiple specialized agents.

## Usage

Review staged changes:
```
/code-review
```

Review specific files:
```
/code-review src/api/handler.go src/api/handler_test.go
```

## Process

Follow these steps precisely:

1. **Determine scope**: If `$ARGUMENTS` contains file paths, review those files. Otherwise, get staged changes with `git diff --cached --name-only`. If no staged changes, ask the user what to review.

2. **Gather context**: Launch a haiku agent to find relevant CLAUDE.md files:
   - The root CLAUDE.md file, if it exists
   - Any CLAUDE.md files in directories containing files being reviewed

3. **Summarize changes**: Launch a sonnet agent to read the files/diff and return a summary of the changes.

4. **Parallel review**: Launch 5 agents in parallel to independently review. Each agent returns a list of issues with description and category (e.g., "CLAUDE.md violation", "bug", "logic error", "simplicity", "power-of-ten").

   **Agent 1**: CLAUDE.md compliance (sonnet)
   Audit changes for CLAUDE.md compliance. Only consider CLAUDE.md files that share a path with the file or its parents.

   **Agent 2**: Bug scan (opus)
   Scan for obvious bugs in the diff. Flag only significant bugs; ignore nitpicks and likely false positives.

   **Agent 3**: Logic/Security review (opus)
   Look for security issues, incorrect logic, edge cases. Only flag issues in the changed code.

   **Agent 4**: Simplicity scan (haiku)
   Ensure code changes are as simple and minimal as possible. Only flag issues in the changed code.

   **Agent 5**: Power of Ten review (haiku)
   Review code against NASA/JPL's "Power of Ten" safety-critical coding rules. Only flag issues in the changed code.

   **CRITICAL: HIGH SIGNAL issues only:**
   - Objective bugs that will cause incorrect behavior at runtime
   - Clear CLAUDE.md violations where you can quote the exact rule broken
   - Security vulnerabilities

   **Do NOT flag:**
   - Subjective concerns or suggestions
   - Style preferences not in CLAUDE.md
   - Potential issues that "might" be problems
   - Anything requiring interpretation

   If uncertain, do not flag it.

5. **Validate issues**: For each issue from agents 2, 3, 4 and 5, launch a parallel validation agent. The validator confirms the issue is real with high confidence by checking the actual code. Use opus for bugs, logic/security, simplicity, and power-of-ten issues; sonnet for CLAUDE.md violations.

6. **Filter**: Remove any issues not validated in step 5.

7. **Report**: Output the final review:

---

## Code Review

**Files reviewed:**
- list of files

**Summary:**
Brief summary of what changed

**Issues found:**

### [Category] Issue title
**File:** `path/to/file.go:42`
**Severity:** High/Medium/Low

Description of the issue.

**Suggested fix:**
```go
// corrected code or description
```

---

If no issues found:

---

## Code Review

**Files reviewed:**
- list of files

**Summary:**
Brief summary of what changed

No issues found. Checked for bugs and CLAUDE.md compliance.

---

## False Positives (do NOT flag)

- Pre-existing issues not introduced in this change
- Pedantic nitpicks a senior engineer would ignore
- Issues a linter will catch (do not run the linter)
- General code quality concerns unless required by CLAUDE.md
- Issues explicitly silenced in code (lint ignore comments)

## Notes

- Create a todo list before starting
- For Go files, the go-review agent should be used
- For TypeScript files, the ts-review agent should be used
- For simplicity the code-simplicity-reviewer agent should be used
- For Power of Ten review the power-of-ten-reviewer agent should be used
- Cite CLAUDE.md rules when flagging violations
