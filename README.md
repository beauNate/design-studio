# Design Studio

A Claude Code plugin that operates as a **virtual design team**. Instead of generic AI design help, it assembles the right specialists for each task — just like a real design studio would staff a project.

## The Team

| Role | What They Do |
|------|-------------|
| **Design Manager** | Analyzes your task, picks the right specialists, orchestrates the workflow |
| **Creative Director** | Sets the visual vision — mood, tone, style direction |
| **Product Designer** | End-to-end UX, feature scoping, business alignment |
| **UX Designer** | User flows, wireframes, information architecture |
| **UI Designer** | Visual polish — typography, color, layout, components |
| **UX Researcher** | Usability heuristics, accessibility audits, edge cases |
| **Content Designer** | Microcopy, error messages, button labels, tone of voice |
| **Design System Lead** | Design tokens, theming, dark mode, consistency |
| **Motion Designer** | Animations, transitions, micro-interactions |

## Commands

| Command | What It Does |
|---------|-------------|
| `/design <task>` | Full design workflow — assembles the right team for your task |
| `/design-review <file>` | Audit an existing design for accessibility, usability, consistency |
| `/design-system` | Generate or extract design tokens and theme configuration |
| `/figma <URL>` | Convert a Figma design to production code |

## Agents

| Agent | Purpose |
|-------|---------|
| **accessibility-auditor** | Comprehensive WCAG AA audit — runs in parallel with your work |
| **design-qa** | Visual QA across breakpoints, token compliance, interaction states |

## How It Works

When you ask for a design task, the Design Manager:

1. **Analyzes** what you need (page, component, system, presentation)
2. **Sets creative direction** (mood, tone, visual language)
3. **Assembles** only the specialists needed (2-7 roles depending on complexity)
4. **Executes** through Research → Strategy → Creative → Polish → Delivery
5. **Reviews** against a quality checklist before delivering

The plugin includes 2,300+ lines of specialized design knowledge across 9 reference files — covering everything from color theory and typography scales to animation timing and WCAG accessibility standards.

## Auto-Detection

A SessionStart hook automatically detects your project's:
- CSS framework (Tailwind, Bootstrap)
- JS framework (React, Vue, Svelte, Next.js)
- Existing design tokens
- Figma and Firebase configuration

This lets the skill adapt its recommendations to your stack.

## Installation

### From GitHub

```bash
claude plugin add https://github.com/Adityaraj0421/design-studio.git
```

### Manual

Clone this repo into your Claude plugins directory:

```bash
git clone https://github.com/Adityaraj0421/design-studio.git ~/.claude/plugins/design-studio
```

Restart Claude Code to load the plugin.

## Plugin Structure

```
design-studio/
├── .claude-plugin/plugin.json      # Plugin manifest
├── skills/design/
│   ├── SKILL.md                    # Design Manager + Creative Director
│   └── references/                 # 9 specialist knowledge bases
├── commands/                       # 4 slash commands
├── agents/                         # 2 specialist agents
├── hooks/hooks.json                # SessionStart auto-detection
├── scripts/                        # Context detection + token generator
└── evals/evals.json                # Test cases with assertions
```

## Tech Stack Defaults

Unless your project specifies otherwise, the plugin defaults to:

- **Styling**: Tailwind CSS
- **Icons**: Lucide (CDN or inline SVG)
- **Fonts**: Inter + system font fallback
- **Charts**: Chart.js or inline SVG
- **Animations**: CSS transitions (no heavy libraries)
- **Preview**: Claude Code Preview MCP
- **Deployment**: Firebase Hosting

## License

MIT
