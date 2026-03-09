---
description: "Convert a Figma design to production code. Provide a Figma URL or select a node in Figma desktop."
argument-hint: "[Figma URL]"
---

# /figma

You are running the Figma-to-code workflow. Read `references/figma-workflow.md` for the complete guide.

Input: **$ARGUMENTS**

## Process

### 1. Get the Design
- If a Figma URL is provided, extract the fileKey and nodeId from it:
  - URL format: `https://figma.com/design/:fileKey/:fileName?node-id=:nodeId`
  - Call `get_design_context` with the extracted fileKey and nodeId
- If no URL is provided, use the Figma desktop app tools (get_design_context without parameters)
- Also call `get_screenshot` to get a visual reference of the target design

### 2. Check Code Connect
- Call `get_code_connect_map` to see if any components are already mapped to code
- If mappings exist, use the mapped component names and sources in your implementation

### 3. Analyze the Design
From the design context, identify:
- Layout structure (grid, flex, positioning)
- Typography (fonts, sizes, weights, line heights)
- Colors (map to tokens or extract exact values)
- Spacing (padding, margins, gaps)
- Components (buttons, cards, inputs — any reusable pieces)
- Assets (images, icons that need to be downloaded)
- States (hover, active, disabled — if visible in variants)
- Responsive hints (auto-layout direction, constraints)

### 4. Build the Implementation
Follow the Figma-to-CSS translation rules from the reference. Key principles:
- Use semantic HTML, not nested divs
- Apply Tailwind utilities where they match; use custom CSS for complex values
- Download any image/icon assets referenced in the design
- Implement hover states and transitions even if not explicitly shown in Figma
- Use CSS Grid or Flexbox matching the Figma auto-layout direction

### 5. Preview and Compare
- Start the preview server with the built HTML
- Take a screenshot of the implementation
- Compare visually with the Figma screenshot
- Note any discrepancies in spacing, color, typography, or layout

### 6. Refine
- Fix any visual differences found in the comparison
- Add responsive behavior (the Figma design is typically one breakpoint)
- Add interaction states if not already implemented
- Run a quick accessibility check (contrast, semantic HTML, keyboard nav)

## Tech Stack
Default: Tailwind CSS + semantic HTML + Inter font. Adapt if the project uses a different stack (check for existing tailwind.config, package.json, etc.).
