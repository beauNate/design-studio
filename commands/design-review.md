---
description: "Review an existing design for quality — accessibility, usability, visual consistency, content, and motion."
argument-hint: "[file path, URL, or 'current preview']"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "mcp__*"]
---

# /design-review

You are conducting a structured design quality audit. This is a review, not a redesign.

## Target

The user will provide one of:
- A file path to an HTML file — read it and start a preview server
- A running preview server — use the existing preview
- A Figma URL — use get_design_context to extract the design
- "current preview" — inspect whatever is currently being previewed

**MCP Fallback**: If Preview MCP tools are unavailable, read the HTML source and perform a static code-level audit. If Figma MCP is unavailable, ask the user for a screenshot or file export.

Target: **$ARGUMENTS**

## Audit Process

Run these 5 audits in sequence:

### 1. Accessibility Audit
Read `${CLAUDE_PLUGIN_ROOT}/skills/design/references/ux-researcher.md` — focus on the WCAG AA Checklist section.
- Check color contrast ratios using preview_inspect on text elements
- Test keyboard navigation with preview_eval (Tab key order)
- Verify semantic HTML (headings, landmarks, buttons vs divs)
- Check ARIA labels on interactive elements
- Verify touch targets are at least 44x44px

### 2. Usability Heuristic Review
Read `${CLAUDE_PLUGIN_ROOT}/skills/design/references/ux-researcher.md` — apply Nielsen's 10 heuristics.
- System status visibility (loading states, feedback)
- User control and freedom (back, undo, cancel)
- Error prevention (validation, confirmation on destructive actions)
- Consistency (same action = same visual treatment)
- Recognition over recall (visible options, labeled icons)

### 3. Visual Consistency
Read `${CLAUDE_PLUGIN_ROOT}/skills/design/references/design-system-lead.md` — use the Consistency Review Checklist.
- Sample colors, spacing, font sizes with preview_inspect
- Flag hardcoded values that should be tokens
- Check spacing consistency (no arbitrary values like 7px, 13px)
- Verify border-radius, shadow, and elevation consistency

### 4. Content Review
Read `${CLAUDE_PLUGIN_ROOT}/skills/design/references/content-designer.md` — use the Content QA Checklist.
- Button labels describe their action (not "Submit" or "Click here")
- Error messages include what happened + how to fix it
- No placeholder text remaining
- Consistent tone and terminology

### 5. Motion Review
Read `${CLAUDE_PLUGIN_ROOT}/skills/design/references/motion-designer.md` — use the Motion QA Checklist.
- Animations have clear purpose (not decorative)
- Timing follows guidelines (100-150ms micro, 200-300ms standard, 300-500ms page)
- Easing functions are appropriate (ease-out for entrances, ease-in for exits)
- Check prefers-reduced-motion support

## Report Format

Present findings as:

**Overall Score**: X/100 (grade letter)

**Critical Issues** (must fix before shipping)
- Issue, why it matters, code fix

**Improvements** (should fix)
- Issue, why it matters, code fix

**Minor** (nice to have)
- Issue, suggestion

**Working Well** (always include positives)
- What the design does right

For each issue, provide the specific code change needed to fix it.

## What's Next

After a design review, suggest follow-up actions based on findings:
- `/design` — redesign specific areas that scored poorly
- `/design-system` — create tokens if the review found hardcoded values
- `/figma-sync` — check if Figma designs match the reviewed code
