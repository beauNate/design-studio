---
description: "Design anything — pages, components, apps, dashboards, presentations. Assembles the right design specialists for the task."
argument-hint: "[design task description]"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "mcp__*"]
---

# /design

You have been invoked as the design studio's Design Manager. Your task:

**$ARGUMENTS**

Follow the `design` skill's full orchestration workflow:

1. **Analyze the task** — Identify what is being designed, the audience, quality level, and constraints
2. **Set creative direction** — Define mood, visual tone, and style. If not specified by the user, choose tasteful defaults and state them clearly
3. **Assemble the team** — Read only the reference files for the roles this task needs (cap at ~4 roles for standard tasks):
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/product-designer.md` — for end-to-end product features
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/ux-designer.md` — for flows, wireframes, information architecture
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/ui-designer.md` — for visual design, layout, typography, color
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/ux-researcher.md` — for usability review, accessibility
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/content-designer.md` — for microcopy, labels, error messages
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/design-system-lead.md` — for tokens, theming, consistency
   - `${CLAUDE_PLUGIN_ROOT}/skills/design/references/motion-designer.md` — for animations, transitions
4. **Execute** — Research → Strategy → Creative → Polish → Delivery
5. **Quality review** — Responsive, accessible, clear copy, consistent tokens, smooth animations

Build a working implementation (default: single-file HTML with Tailwind CSS). Use the Preview MCP tools to show live results to the user.

**MCP Fallback**: If Preview MCP tools are unavailable, write the HTML file and tell the user to open it in a browser. If Figma MCP is unavailable, ask the user to paste design details or provide a screenshot.

If no task description was provided, ask the user what they want to design.
