# Framework Specialist

Translates design studio HTML/CSS output into idiomatic, production-ready component code for specific frontend frameworks. Knows each framework's conventions deeply — not just syntax, but idiomatic patterns, file structure, and tooling defaults.

---

## When to Activate

Activate when the user specifies `--framework` flag or mentions a framework explicitly:
- "build this in React with Tailwind"
- "convert to Vue components"
- "I'm using Next.js App Router"
- "output as Svelte components"
- "we use Astro"

---

## Supported Frameworks

### React + Tailwind CSS

**File structure:**
```
src/
  components/
    Button.tsx        # atomic component
    Card.tsx
  pages/ or app/      # Next.js or CRA
  lib/
    utils.ts          # cn() utility
  styles/
    globals.css       # Tailwind directives
```

**Component pattern:**
```tsx
import { cn } from '@/lib/utils'

interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  children: React.ReactNode
  className?: string
  onClick?: () => void
  disabled?: boolean
}

export function Button({
  variant = 'primary',
  size = 'md',
  children,
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        // base styles
        'inline-flex items-center justify-center rounded-md font-medium transition-colors',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
        'disabled:pointer-events-none disabled:opacity-50',
        // variants
        {
          'bg-primary text-primary-foreground hover:bg-primary/90': variant === 'primary',
          'border border-input bg-background hover:bg-accent': variant === 'secondary',
          'hover:bg-accent hover:text-accent-foreground': variant === 'ghost',
        },
        // sizes
        {
          'h-8 px-3 text-sm': size === 'sm',
          'h-10 px-4 text-sm': size === 'md',
          'h-11 px-8 text-base': size === 'lg',
        },
        className
      )}
      {...props}
    >
      {children}
    </button>
  )
}
```

**cn() utility (required):**
```ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

**Tailwind config for design tokens:**
```js
// tailwind.config.ts
export default {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: 'hsl(var(--primary))',
        'primary-foreground': 'hsl(var(--primary-foreground))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        muted: 'hsl(var(--muted))',
        'muted-foreground': 'hsl(var(--muted-foreground))',
        border: 'hsl(var(--border))',
      },
    },
  },
}
```

**CSS variables (globals.css):**
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --primary: 222 47% 11%;
    --primary-foreground: 210 40% 98%;
    --background: 0 0% 100%;
    --foreground: 222 47% 11%;
    --muted: 210 40% 96%;
    --muted-foreground: 215 16% 47%;
    --border: 214 32% 91%;
    --radius: 0.5rem;
  }
  .dark {
    --primary: 210 40% 98%;
    --primary-foreground: 222 47% 11%;
    --background: 222 47% 11%;
    --foreground: 210 40% 98%;
    --muted: 217 33% 17%;
    --muted-foreground: 215 20% 65%;
    --border: 217 33% 17%;
  }
}
```

**Key patterns:**
- Use `cn()` for conditional classes — never template literals
- Keep components in `src/components/`, pages in `src/app/` (Next.js) or `src/pages/`
- TypeScript interfaces for all props, no `any`
- Compound components with `export const X = { Root, Header, Body }` for complex UI
- `forwardRef` for form inputs and interactive elements
- `'use client'` directive only when needed (Next.js App Router)

---

### Vue 3 + UnoCSS

**File structure:**
```
src/
  components/
    UiButton.vue      # prefix components with "Ui" for base components
    UiCard.vue
  composables/
    useTheme.ts
  pages/
    index.vue         # Nuxt or Vue Router
```

**Component pattern (Composition API + `<script setup>`):**
```vue
<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  disabled: false,
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()
</script>

<template>
  <button
    :class="[
      'inline-flex items-center justify-center rounded-md font-medium transition-colors',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
      'disabled:pointer-events-none disabled:opacity-50',
      {
        'bg-primary text-white hover:bg-primary-700': variant === 'primary',
        'border border-gray-300 hover:bg-gray-50': variant === 'secondary',
        'hover:bg-gray-100': variant === 'ghost',
      },
      {
        'h-8 px-3 text-sm': size === 'sm',
        'h-10 px-4 text-sm': size === 'md',
        'h-11 px-8 text-base': size === 'lg',
      },
    ]"
    :disabled="disabled"
    @click="emit('click', $event)"
  >
    <slot />
  </button>
</template>
```

**UnoCSS config:**
```ts
// uno.config.ts
import { defineConfig, presetUno, presetWebFonts } from 'unocss'

export default defineConfig({
  presets: [
    presetUno(),
    presetWebFonts({ fonts: { sans: 'Inter' } }),
  ],
  theme: {
    colors: {
      primary: {
        DEFAULT: '#2563eb',
        700: '#1d4ed8',
      },
    },
  },
})
```

**Key patterns:**
- `<script setup>` is the modern default — avoid Options API
- `defineProps<T>()` + `withDefaults` for typed props
- Composables for shared logic (prefix with `use`)
- Auto-import components via unplugin-vue-components
- `v-bind` class objects for conditional classes

---

### Svelte 5

**File structure:**
```
src/
  lib/
    components/
      Button.svelte
      Card.svelte
    utils.ts
  routes/
    +page.svelte      # SvelteKit
```

**Component pattern (Svelte 5 runes):**
```svelte
<script lang="ts">
  interface Props {
    variant?: 'primary' | 'secondary' | 'ghost'
    size?: 'sm' | 'md' | 'lg'
    disabled?: boolean
    onclick?: (e: MouseEvent) => void
    children?: import('svelte').Snippet
  }

  let {
    variant = 'primary',
    size = 'md',
    disabled = false,
    onclick,
    children,
  }: Props = $props()

  const baseClasses = 'inline-flex items-center justify-center rounded-md font-medium transition-colors'

  const variantClasses = {
    primary: 'bg-primary text-white hover:bg-primary-dark',
    secondary: 'border border-gray-300 bg-white hover:bg-gray-50',
    ghost: 'hover:bg-gray-100',
  }

  const sizeClasses = {
    sm: 'h-8 px-3 text-sm',
    md: 'h-10 px-4 text-sm',
    lg: 'h-11 px-8 text-base',
  }
</script>

<button
  class="{baseClasses} {variantClasses[variant]} {sizeClasses[size]}"
  {disabled}
  {onclick}
>
  {@render children?.()}
</button>

<style>
  :global(:root) {
    --color-primary: #2563eb;
    --color-primary-dark: #1d4ed8;
  }
</style>
```

**Key patterns:**
- Use `$props()` rune (Svelte 5) — not `export let` (deprecated)
- `$state()` for reactive local state
- `$derived()` for computed values
- `{@render children?.()}` for snippets (replaces `<slot>`)
- CSS modules or `<style>` blocks for component-scoped styles
- SvelteKit: `+page.svelte`, `+layout.svelte`, `+page.ts` for data loading

---

### Next.js App Router

**File structure:**
```
app/
  layout.tsx          # root layout with providers
  page.tsx            # home route
  (routes)/
    dashboard/
      page.tsx
      layout.tsx
components/
  ui/                 # shadcn/ui or custom atomic components
  features/           # feature-specific composed components
lib/
  utils.ts
  actions.ts          # Server Actions
public/
```

**Server vs Client components:**
```tsx
// app/page.tsx — Server Component (default, no 'use client')
import { HeroSection } from '@/components/features/HeroSection'
import { fetchHomeData } from '@/lib/data'

export default async function HomePage() {
  const data = await fetchHomeData()  // direct async/await, no useEffect
  return <HeroSection data={data} />
}

// components/features/InteractiveWidget.tsx — Client Component
'use client'
import { useState } from 'react'

export function InteractiveWidget() {
  const [open, setOpen] = useState(false)
  return <button onClick={() => setOpen(!open)}>Toggle</button>
}
```

**Key patterns:**
- Default to Server Components — only add `'use client'` for interactivity
- Data fetching in Server Components with direct `await fetch()` or ORM calls
- Server Actions for mutations: `export async function submitForm(formData: FormData) {}`
- `loading.tsx` for Suspense boundaries, `error.tsx` for error boundaries
- `metadata` export for SEO in each `page.tsx`
- Collocate components with routes they're exclusively used in

---

### Astro

**File structure:**
```
src/
  layouts/
    BaseLayout.astro
  components/
    Button.astro        # static component
    Counter.tsx         # interactive island (React/Svelte/Vue)
  pages/
    index.astro
    blog/
      [slug].astro      # dynamic routes
  content/
    blog/               # content collections
public/
```

**Astro component pattern:**
```astro
---
// Button.astro — runs at build time
interface Props {
  variant?: 'primary' | 'secondary'
  href?: string
}

const { variant = 'primary', href } = Astro.props
const Tag = href ? 'a' : 'button'
---

<Tag
  href={href}
  class:list={[
    'btn',
    { 'btn-primary': variant === 'primary' },
    { 'btn-secondary': variant === 'secondary' },
  ]}
>
  <slot />
</Tag>

<style>
  .btn {
    display: inline-flex;
    align-items: center;
    padding: 0.5rem 1rem;
    border-radius: 0.375rem;
    font-weight: 500;
    transition: background-color 150ms;
  }
  .btn-primary {
    background: var(--color-primary);
    color: white;
  }
</style>
```

**Interactive islands:**
```astro
---
// Only load JS for interactive parts — "island architecture"
import Counter from '../components/Counter.tsx'
---

<Counter client:load />         <!-- loads immediately -->
<Counter client:idle />         <!-- loads when browser is idle -->
<Counter client:visible />      <!-- loads when scrolled into view -->
```

**Key patterns:**
- `.astro` files for static/SSG content, UI framework files (`.tsx`) for islands
- `client:*` directives control when island JS loads — default to `client:visible`
- Content Collections for type-safe markdown: `getCollection('blog')`
- Zero JS by default — only islands ship JavaScript

---

## Framework Detection

Detect the target framework from:
1. `--framework` flag in command: `react-tailwind`, `vue`, `svelte`, `nextjs`, `astro`
2. `settings.local.md` `js_framework` and `css_framework` fields
3. Auto-detection context: look for `package.json` keywords (`next`, `nuxt`, `svelte`, `astro`)

Framework aliases to recognize:
- `react`, `react-tailwind`, `react-tw` → React + Tailwind
- `vue`, `vue3`, `nuxt` → Vue 3 + UnoCSS
- `svelte`, `sveltekit` → Svelte 5 + SvelteKit
- `next`, `nextjs`, `next-app` → Next.js App Router + Tailwind
- `astro` → Astro + Tailwind

---

## Output Format by Framework

| Framework | Output | File Extension | Notes |
|-----------|--------|---------------|-------|
| React + Tailwind | TSX component + globals.css + tailwind.config.ts | `.tsx` | Include cn() utility |
| Vue 3 + UnoCSS | SFC + uno.config.ts | `.vue` | Composition API + `<script setup>` |
| Svelte 5 | Svelte component | `.svelte` | Use runes ($props, $state) |
| Next.js App Router | Server Component + Client Component split | `.tsx` | Annotate which is server/client |
| Astro | Astro component + optional island | `.astro` + `.tsx` | Minimal JS by default |

---

## QA Checklist

Before delivering framework output:
- [ ] Props are typed (TypeScript) — no `any`
- [ ] Component is self-contained (no external imports that don't exist)
- [ ] Dark mode support included (CSS vars or Tailwind dark: prefix)
- [ ] Responsive at all breakpoints
- [ ] Interactive states (hover, focus, disabled) implemented
- [ ] Accessibility: ARIA attributes, keyboard nav, semantic HTML preserved
- [ ] Framework-idiomatic patterns used (not just HTML copied into JSX)
- [ ] Named exports for tree-shaking (no default exports on utilities)
