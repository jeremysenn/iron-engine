# Design System — IronEngine

## Product Context
- **What this is:** A deterministic rule engine that encodes the KILO Strength Society coaching methodology. Coaches enter client assessments and the engine generates complete 12-week periodized programs.
- **Who it's for:** KILO-trained strength coaches with 5-20 clients who currently spend 2-4 hours manually cross-referencing PDFs to build programs.
- **Space/industry:** Fitness coaching software (TrueCoach, TrainHeroic, CoachRx). None encode a specific methodology.
- **Project type:** Professional data-heavy web app (Rails 8 full-stack, ERB + Hotwire)

## Aesthetic Direction
- **Direction:** Industrial/Utilitarian
- **Decoration level:** Minimal — typography and data do all the work. The radar chart and timeline ARE the decoration.
- **Mood:** Precision instrument for coaches who think in numbers. Bloomberg Terminal meets a sports science lab. Not flashy, not consumer. Dense but readable. Every pixel earns its place.
- **Reference sites:** CoachRx (closest competitor feel, all-dark), TrainHeroic (athletic, dark), TrueCoach (consumer-friendly, light)
- **Differentiation:** Split-tone (dark sidebar / light content) vs CoachRx (all dark). Monospace for data vs competitors (all sans-serif). Radar chart as visual anchor (no competitor shows strength ratios visually). No cards anywhere (tables and structured hierarchies instead).

## Typography
- **Display/Hero:** Satoshi (geometric sans, confident, modern but not trendy) — loaded from Fontshare
- **Body:** DM Sans (clean, excellent readability, pairs with Satoshi) — loaded from Google Fonts
- **UI/Labels:** DM Sans (same as body, use weight 500 for labels)
- **Data/Tables:** JetBrains Mono (tabular-nums, instantly signals 'this is precise data') — loaded from Google Fonts
- **Code:** JetBrains Mono
- **Loading:** Fontshare CDN for Satoshi, Google Fonts for DM Sans + JetBrains Mono
- **Scale:**
  - `text-xs`: 0.75rem (12px) — captions, labels
  - `text-sm`: 0.875rem (14px) — secondary text, table cells
  - `text-base`: 1rem (16px) — body text
  - `text-lg`: 1.125rem (18px) — emphasized body
  - `text-xl`: 1.25rem (20px) — section headings
  - `text-2xl`: 1.5rem (24px) — page headings
  - `text-3xl`: 1.875rem (30px) — display headings
  - `text-4xl`: 2.25rem (36px) — hero/display

## Color
- **Approach:** Restrained — one accent + neutrals. Color is rare and meaningful. When something is colored, it matters.
- **CSS Custom Properties:**
  ```css
  :root {
    --color-sidebar: #0F172A;       /* slate-900 */
    --color-sidebar-text: #CBD5E1;  /* slate-300 */
    --color-sidebar-active: #0D9488;/* teal-600 */
    --color-bg: #F8FAFC;           /* slate-50 */
    --color-surface: #FFFFFF;       /* white */
    --color-text-primary: #0F172A;  /* slate-900 */
    --color-text-secondary: #64748B;/* slate-500 */
    --color-text-muted: #94A3B8;   /* slate-400 */
    --color-accent: #0D9488;       /* teal-600 */
    --color-accent-hover: #0F766E; /* teal-700 */
    --color-border: #E2E8F0;       /* slate-200 */
    --color-accumulation: #0D9488; /* teal-600, volume phases */
    --color-intensification: #D97706;/* amber-600, intensity phases */
    --color-success: #059669;      /* emerald-600 */
    --color-warning: #D97706;      /* amber-600 */
    --color-error: #DC2626;        /* red-600 */
    --color-info: #2563EB;         /* blue-600 */
    --color-limiting: #DC2626;     /* red-600, limiting lift highlight */
  }
  ```
- **Dark mode strategy:** Swap surface colors. Reduce saturation 10-20% on accents. Sidebar stays dark (already dark). Content area becomes slate-900. Text inverts to slate-100/slate-400.
  ```css
  [data-theme="dark"] {
    --color-bg: #0F172A;
    --color-surface: #1E293B;
    --color-text-primary: #F1F5F9;
    --color-text-secondary: #94A3B8;
    --color-text-muted: #64748B;
    --color-border: #334155;
    --color-sidebar: #020617;
  }
  ```

## Spacing
- **Base unit:** 4px
- **Density:** Comfortable — not cramped, not airy. Professional data density.
- **Scale:** 2xs(2px) xs(4px) sm(8px) md(16px) lg(24px) xl(32px) 2xl(48px) 3xl(64px)
- **Tailwind mapping:** Use default Tailwind spacing (p-1=4px, p-2=8px, p-4=16px, etc.)

## Layout
- **Approach:** Grid-disciplined — strict columns, predictable alignment
- **Framework:** Tailwind CSS (Rails 8 default)
- **Structure:** Collapsible sidebar (240px dark) + main content (light). Sidebar collapses to 64px icons on tablet, hamburger menu on mobile.
- **Grid:** Single column main content for MVP. No multi-column dashboard grids.
- **Max content width:** 1200px
- **Border radius:**
  - `sm`: 4px (inputs, small elements)
  - `md`: 6px (buttons, cards if ever needed)
  - `lg`: 8px (panels, modals)
  - `full`: 9999px (avatars, badges)

## Motion
- **Approach:** Minimal-functional — only transitions that aid comprehension
- **Philosophy:** Speed IS the experience. No scroll animations, no entrance effects, no parallax. Turbo Frame transitions provide the responsiveness.
- **Easing:** enter(ease-out) exit(ease-in) move(ease-in-out)
- **Duration:** micro(50-100ms) for hovers, short(150ms) for Turbo frame swaps

## Component Patterns

### Navigation
- Sidebar: slate-900 bg, text in slate-300, active item has teal-600 text + rgba(teal, 0.15) bg
- Logo: "Iron" in white, "Engine" in teal-600, Satoshi 900 weight
- Mobile: hamburger menu, full-screen overlay

### Data Tables (first-class citizen)
- Striped rows (alternating subtle bg)
- Sticky headers
- JetBrains Mono for all numeric cells
- DM Sans weight-500 for label/name columns
- Limiting lifts: red-600 text + bold
- Optimal values: emerald-600 text
- Superset grouping: colored left border (teal for A-pair, slate for B-pair)

### Forms
- Label: DM Sans 500, 0.8rem, slate-500
- Input: JetBrains Mono for numeric inputs, DM Sans for text inputs
- Focus: 2px teal-600 outline
- Required fields: asterisk in red-600

### Buttons
- Primary: teal-600 bg, white text
- Secondary: transparent bg, slate border, slate text
- Danger: red-600 bg, white text
- Ghost: transparent bg, teal-600 text

### Alerts
- Left border accent (3px)
- Success: emerald bg tint, emerald border
- Warning: amber bg tint, amber border
- Error: red bg tint, red border
- Info: blue bg tint, blue border

### Radar Chart
- SVG generated server-side (Rails helper, no JS library)
- Optimal ratios: dashed teal outline
- Actual ratios: filled teal polygon (20% opacity)
- Limiting lift point: red-600 circle with white stroke
- Labels: JetBrains Mono, 10px

### Macrocycle Timeline
- 12-column HTML table (one per week)
- Accumulation weeks: teal-600 bg
- Intensification weeks: amber-600 bg
- White text, JetBrains Mono, 0.65rem
- Phase labels below in slate-400

### Program Display
- Accordion navigation: weeks collapse/expand
- Session exercise table: compact rows, position column, superset grouping
- "Show reasoning" toggle: ghost button, reveals collapsed annotation panels
- Annotations: slate-100 bg panel, mono font for rule references

### Empty States
- Warm, action-oriented copy (not just "No items found")
- Primary CTA button pointing to next step
- Contextual nudges chaining through the workflow

## Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04-03 | Initial design system created | Created by /design-consultation based on competitive research (TrueCoach, TrainHeroic, CoachRx) and product positioning as precision coaching instrument |
| 2026-04-03 | Industrial/Utilitarian aesthetic | KILO coaches think in numbers. The tool should feel like a precision instrument, not a consumer fitness app |
| 2026-04-03 | JetBrains Mono for all data | Risk: most coaching apps use sans-serif. Monospace signals precision and differentiates from competitors |
| 2026-04-03 | No cards, tables only | Risk: competitors all use cards. Tables are denser, more professional, and what coaches already read (spreadsheets) |
| 2026-04-03 | Split-tone (dark sidebar / light content) | Differentiates from CoachRx (all dark) while being more professional than TrueCoach (all light) |
| 2026-04-03 | Renamed from ShapeTrak to IronEngine | "Iron" grounds it in the weight room, "Engine" signals the precision rule engine underneath |
