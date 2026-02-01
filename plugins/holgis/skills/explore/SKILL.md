---
name: sendify:explore
description: Research stdlib solutions, best practices, and codebase patterns
argument-hint: "[feature description]"
disable-model-invocation: true
---

# Exploration Research

Research a feature area by launching 3 parallel exploration agents.

## Process

Launch 3 parallel agents to research different aspects:

### 1. Standard Library Agent (Explore, opus)

- Find standard library solutions for the feature
- Identify when stdlib is sufficient vs when external packages are needed
- Provide code examples using stdlib
- Highlight Go stdlib for backend, TypeScript/Node stdlib for frontend

### 2. Best Practices Agent (Explore, opus)

- Search the web for best practices and authoritative resources:
  - For Go: Effective Go (https://go.dev/doc/effective_go), Go blog, Go wiki
  - For React: Kent C Dodds blog (https://kentcdodds.com/blog), React docs, React patterns
  - Industry standards and conventions from trusted sources
- Research architectural patterns for this type of feature
- Identify common pitfalls and how to avoid them
- Focus on Go patterns for backend, React patterns for frontend

### 3. Codebase Patterns Agent (Explore, opus)

- Find similar implementations in the codebase
- Extract patterns: naming conventions, file organization, test structure
- Provide file:line references to examples
- Look at both Go services and TypeScript/React components

## Output

After agents complete, synthesize findings into a summary covering:

- **Standard Library Solutions**: What stdlib offers, with code examples
- **Best Practices**: Key patterns to follow, pitfalls to avoid
- **Codebase References**: Similar implementations with file:line references
- **Recommendations**: Suggested implementation approach based on findings

## Clarification

If any aspect of the research is unclear or requires more context from the user, use AskUserQuestion to get clarification before finalizing the findings.

This research provides context for planning and implementing features using Claude's native plan mode.