## What does this PR do?

<!-- Brief description of the change -->

## Type of change

- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New command or agent
- [ ] Skill improvement
- [ ] Documentation update
- [ ] Other (describe below)

## Components affected

- [ ] `commands/` — slash commands
- [ ] `agents/` — subagents
- [ ] `skills/design/` — core skill or references
- [ ] `scripts/` — shell scripts
- [ ] `hooks/` — session hooks
- [ ] `evals/` — test cases

## Checklist

- [ ] Tested with `claude plugin validate` or plugin-validator agent
- [ ] Reference paths use `${CLAUDE_PLUGIN_ROOT}/skills/design/references/`
- [ ] Commands include `allowed-tools` in frontmatter
- [ ] No hardcoded file paths (portable across installs)
