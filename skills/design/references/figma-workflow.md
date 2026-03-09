# Figma Workflow Reference

Guidance for Figma-to-code workflows, design context extraction, and design handoff using MCP tools.

## Table of Contents
1. [Design Context Extraction](#design-context-extraction)
2. [Figma-to-Code Workflow](#figma-to-code-workflow)
3. [Code Connect](#code-connect)
4. [Adapting Design to Code](#adapting-design-to-code)

---

## Design Context Extraction

### Available Figma MCP Tools

Two Figma MCP servers may be available — the URL-based one (requires fileKey + nodeId) and the desktop one (works with current selection). Check which is available:

**URL-based tools** (require fileKey and nodeId from Figma URLs):
- `get_design_context` — Primary tool. Returns reference code, screenshot, and metadata.
- `get_screenshot` — Screenshot of a specific node
- `get_metadata` — XML structure overview (node IDs, names, positions)
- `get_variable_defs` — Design token variables for a node
- `get_code_connect_map` — Maps nodes to codebase components

**Desktop tools** (work with currently selected node in Figma desktop app):
- Same tools but don't require fileKey/nodeId parameters

### Extracting from URLs

When the user provides a Figma URL like:
```
https://figma.com/design/AbCdEf/MyFile?node-id=123-456
```

Extract:
- **fileKey**: `AbCdEf`
- **nodeId**: `123:456` (convert `-` to `:`)

For branch URLs:
```
https://figma.com/design/AbCdEf/branch/GhIjKl/MyFile
```
Use the branchKey (`GhIjKl`) as the fileKey.

### What get_design_context Returns

The primary tool returns:
1. **Reference code**: HTML/CSS representation of the design (adapt, don't copy verbatim)
2. **Screenshot**: Visual reference for the node
3. **Asset download URLs**: Images, icons referenced in the design
4. **Metadata**: Node structure, names, dimensions

---

## Figma-to-Code Workflow

### Step 1: Get the Design Context

```
Call get_design_context with nodeId and fileKey
```

This gives you the reference code and screenshot. The reference code is a starting point — it represents the design's visual structure but needs adaptation for production use.

### Step 2: Analyze the Design

From the returned data, identify:
- **Layout structure**: Flex/grid, spacing, alignment
- **Typography**: Font families, sizes, weights, line heights
- **Colors**: Background, text, border, and accent colors
- **Components**: Repeating patterns that should be componentized
- **Assets**: Images and icons that need downloading
- **States**: Look for variants that indicate hover, active, disabled states
- **Responsive hints**: Fixed vs. fluid widths, breakpoint patterns

### Step 3: Adapt to Production Code

The reference code from Figma is a guide, not final output. Adapt it:

**DO:**
- Map Figma colors to existing design tokens
- Use existing component patterns from the project
- Apply responsive patterns (Figma designs are usually single-breakpoint)
- Add interaction states (hover, focus, active)
- Use semantic HTML elements
- Apply accessibility attributes

**DON'T:**
- Copy pixel values verbatim (use rem/em, token values)
- Use absolute positioning unless truly needed
- Hard-code widths that should be responsive
- Ignore existing project conventions

### Step 4: Download Assets

The response includes download URLs for referenced assets. Download and save them to the project's asset directory.

### Step 5: Implement and Compare

Build the component, then compare visually:
1. Use the Preview MCP to see your implementation
2. Compare side-by-side with the Figma screenshot
3. Iterate until the implementation matches

---

## Code Connect

Code Connect maps Figma components to codebase components, creating a bridge between design and code.

### Checking Existing Mappings

Use `get_code_connect_map` to see if components are already mapped:
```
{
  "1:2": {
    "codeConnectSrc": "src/components/Button.tsx",
    "codeConnectName": "Button"
  }
}
```

If mappings exist, use the referenced components in your implementation rather than rebuilding from scratch.

### Adding New Mappings

Use `add_code_connect_map` to map a Figma component to its code equivalent:
- **nodeId**: The Figma node ID
- **fileKey**: The Figma file key
- **source**: Path to the component in the codebase
- **componentName**: Name of the component in code
- **label**: Framework label (React, Vue, Svelte, etc.)

### Using get_code_connect_suggestions

For complex designs, use `get_code_connect_suggestions` to get AI-suggested mappings, then review and confirm with `send_code_connect_mappings`.

---

## Adapting Design to Code

### Common Figma-to-CSS Translations

| Figma property | CSS equivalent |
|---------------|---------------|
| Auto Layout (horizontal) | `display: flex; flex-direction: row;` |
| Auto Layout (vertical) | `display: flex; flex-direction: column;` |
| Gap | `gap: Xpx;` |
| Padding | `padding: top right bottom left;` |
| Fill (solid) | `background-color: #hex;` |
| Fill (gradient) | `background: linear-gradient(...)` |
| Stroke | `border: Xpx solid #hex;` |
| Corner radius | `border-radius: Xpx;` |
| Drop shadow | `box-shadow: X Y blur spread #hex;` |
| Blend mode | `mix-blend-mode: mode;` |
| Opacity | `opacity: 0.X;` |
| Clip content | `overflow: hidden;` |

### Figma Variables to CSS Tokens

When `get_variable_defs` returns variables:
```json
{
  "icon/default/secondary": "#949494",
  "spacing/md": "16px",
  "radius/lg": "12px"
}
```

Map to your token system:
```css
--color-icon-secondary: #949494;
--spacing-md: 16px;
--radius-lg: 12px;
```

### Handling Design Ambiguity

Figma designs often leave things implied:
- **Hover states**: If not explicitly designed, darken/lighten 10% for hover
- **Mobile layout**: If only desktop is designed, stack columns and increase padding
- **Loading states**: Add skeleton screens matching the layout shape
- **Error states**: Add inline validation styles near form inputs
- **Focus states**: Add visible focus rings matching the brand color
- **Overflow**: Decide truncation strategy (line-clamp, ellipsis, scroll)

Always clarify with the user if the design intent is ambiguous rather than guessing wrong.
