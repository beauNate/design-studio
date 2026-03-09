# Contributing to Design Studio

Thanks for your interest in improving the design-studio plugin!

## Getting Started

1. Fork and clone the repo
2. Install locally:
   ```bash
   cp -r design-studio ~/.claude/plugins/design-studio
   ```
3. Test your changes by running `/design`, `/design-review`, `/design-system`, or `/figma` in Claude Code

## Project Structure

```
design-studio/
├── .claude-plugin/plugin.json   # Plugin manifest
├── commands/                    # Slash commands (/design, /figma, etc.)
├── agents/                      # Specialist subagents
├── skills/design/               # Core skill + 9 reference files
├── scripts/                     # Shell utilities
├── hooks/                       # Session hooks
└── evals/                       # Test cases
```

## Guidelines

### Commands
- Always include `allowed-tools` in frontmatter to limit tool access
- Use `${CLAUDE_PLUGIN_ROOT}/skills/design/references/` for reference file paths
- Include MCP fallback guidance for when Preview/Figma MCP tools aren't available

### Agents
- Include 2-3 `<example>` blocks in the description for accurate triggering
- List all needed tools in the `tools` array (don't forget `Write` for agents that save reports)

### Reference Files
- Keep each under 400 lines — break large references into focused sections
- Include a table of contents for files over 200 lines
- Focus on actionable guidance, not theory

### Testing
- Add test cases to `evals/evals.json` for new commands or major changes
- Run the plugin-validator agent before submitting a PR

## Submitting Changes

1. Create a feature branch: `git checkout -b feature/my-improvement`
2. Make your changes
3. Test locally in Claude Code
4. Submit a PR using the PR template
