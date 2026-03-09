#!/bin/bash
# Detect project design context for the design-studio plugin
# Runs at SessionStart to provide the design skill with project awareness

PROJECT_DIR="${PWD}"
CONTEXT=""

# --- CSS Framework ---
if [ -f "$PROJECT_DIR/tailwind.config.js" ] || [ -f "$PROJECT_DIR/tailwind.config.ts" ] || [ -f "$PROJECT_DIR/tailwind.config.mjs" ]; then
  CONTEXT="${CONTEXT}- CSS Framework: Tailwind CSS\n"
elif [ -f "$PROJECT_DIR/postcss.config.js" ]; then
  CONTEXT="${CONTEXT}- CSS Framework: PostCSS (check for plugins)\n"
fi

if grep -q '"bootstrap"' "$PROJECT_DIR/package.json" 2>/dev/null; then
  CONTEXT="${CONTEXT}- CSS Framework: Bootstrap\n"
fi

# --- JS Framework ---
if grep -q '"react"' "$PROJECT_DIR/package.json" 2>/dev/null; then
  CONTEXT="${CONTEXT}- Framework: React\n"
elif grep -q '"vue"' "$PROJECT_DIR/package.json" 2>/dev/null; then
  CONTEXT="${CONTEXT}- Framework: Vue\n"
elif grep -q '"svelte"' "$PROJECT_DIR/package.json" 2>/dev/null; then
  CONTEXT="${CONTEXT}- Framework: Svelte\n"
elif grep -q '"next"' "$PROJECT_DIR/package.json" 2>/dev/null; then
  CONTEXT="${CONTEXT}- Framework: Next.js\n"
fi

# --- Design Tokens ---
if find "$PROJECT_DIR/src" -name "*.tokens.json" -maxdepth 4 2>/dev/null | head -1 | grep -q .; then
  CONTEXT="${CONTEXT}- Design tokens: JSON token files found\n"
fi

if find "$PROJECT_DIR/src" -name "tokens.css" -o -name "variables.css" -o -name "design-tokens.css" -maxdepth 4 2>/dev/null | head -1 | grep -q .; then
  CONTEXT="${CONTEXT}- Design tokens: CSS custom properties file found\n"
fi

# --- Figma Integration ---
if [ -f "$PROJECT_DIR/.figmarc" ] || [ -f "$PROJECT_DIR/figma.config.json" ]; then
  CONTEXT="${CONTEXT}- Figma: Configuration file detected\n"
fi

# --- Firebase ---
if [ -f "$PROJECT_DIR/firebase.json" ]; then
  CONTEXT="${CONTEXT}- Deployment: Firebase project configured\n"
fi

# --- Output ---
if [ -n "$CONTEXT" ]; then
  RESULT=$(printf '{"continue": true, "systemMessage": "Design Studio detected project context:\\n%s\\nAdapt design recommendations to match these project conventions."}' "$CONTEXT")
  echo "$RESULT"
else
  echo '{"continue": true}'
fi
