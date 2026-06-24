# Ōkami — Visual Design Polish Spec

**Date:** 2026-06-24
**Scope:** Polish the visual design of the screens that already exist — splash, NeuPlas task manager, task cards, New/Edit task form, and the bottom navigation. Placeholder tabs (Home, Body, Motion) are explicitly out of scope.

## North Star

An **elegant oriental iOS app**: iOS-grade restraint and polish (generous whitespace, hairline dividers, rounded cards, smooth transitions, one tint color used sparingly) married to a **Sumi-e / Japanese ink** soul. Dark base.

---

## Section A — Foundation (color + type)

### Color tokens

The palette rounds around an **ultramarine blue gradient** as the single accent family, over a warm sumi (charcoal) base.

| Token | Hex | Use |
|---|---|---|
| `sumi` (background) | `#16140F` | warm charcoal canvas |
| `surface` (raised) | `#1F1C16` | cards, tiles — barely lifted |
| `hairline` (border) | `#2E2A22` | 1px card/divider borders |
| `ink` (text primary) | `#F2ECE0` | paper-white, warm |
| `inkMuted` (secondary) | `#9A9286` | subtitles, "Today" |
| `inkFaint` (tertiary) | `#6B6459` | meta, hints, inactive icons |

#### Accent — ultramarine gradient

| Token | Hex | Use |
|---|---|---|
| `ultramarineDeep` | `#1E2A7A` | gradient start, pressed states |
| `ultramarine` (core) | `#3A4ED6` | the primary tint |
| `ultramarineBright` | `#5A78FF` | gradient end, highlights, focus |
| `accentGradient` | linear `#1E2A7A → #5A78FF` (top-left → bottom-right) | hero button, splash accent, selected fills |

The accent is used **sparingly** (iOS principle: one tint color). Everything else stays monochrome warm-ink.

> Base note: warm charcoal base + cool ultramarine accent is a deliberate warm/cool contrast. Optional alternative for full blue cohesion: nudge base to a cool "indigo sumi" `#101220`. Kept warm `#16140F` for now.

#### Priority markers

Derived from the gradient (monochrome-blue, elegant):
- **A** = `ultramarineBright`
- **B** = `ultramarine`
- **C** = `inkFaint`

### Typography (`google_fonts` — already a dependency)

Pairing: **Shippori Mincho** (headers/wordmark — refined brush-derived mincho serif, the oriental soul) + **Inter** (body/UI — closest free analog to iOS SF Pro, the iOS cleanliness).

| Style | Font | Size / weight | Use |
|---|---|---|---|
| Wordmark | Shippori Mincho | 32 · w300, tracked | splash "ŌKAMI" |
| Screen title | Shippori Mincho | 28 · w500 | "Task Manager", large nav titles |
| Card title | Inter | 16 · w600 | task title |
| Body | Inter | 14 · w400 · inkMuted | descriptions, "Today" |
| Meta | Inter | 12.5 · w500 · inkFaint | "08:00 · 90m", tabular figures |
| Field label | Inter | 13 · w600 | form labels |

---

## Section B — Components

Centralized so screens inherit them. The currently-empty `lib/widgets/app_widgets.dart` becomes the component home.

1. **InkCard** — replaces stock `Card`. `surface` fill, 16px radius (iOS-round), 1px `hairline` border, **no drop shadow** (flat/elegant), 16px padding.
2. **Task row** — drops the `CircleAvatar` bubble. Left edge: a slim **gradient priority bar** (or seal dot) in the priority color. Title in Inter w600 `ink`; meta line `08:00 · 90m · Neuroplasticity` in `inkFaint`. Trailing iOS chevron.
3. **Action tiles** (Lock in / Organize) — InkCards with a thin-outline icon, label in Inter; pressed state tints with `ultramarineDeep`.
4. **PrioritySelector** — refined iOS-style segmented control; selected segment filled with `accentGradient`, ink text. Replaces stock `SegmentedButton`.
5. **CategorySelector** — pill chips, hairline border when unselected, `ultramarine` fill when selected. Replaces stock `ChoiceChip` look.
6. **RepeatToggle** — iOS-style switch tinted `ultramarine`.
7. **Bottom nav** — restyled `NavigationBar`: transparent over `sumi`, no Material pill tint; active icon `ink` + subtle gradient indicator, inactive `inkFaint`, labels Inter 11.
8. **Brush accent** — a short, tapered **gradient brush stroke** under screen titles, drawn with a `CustomPainter` (no image asset needed). The one "ink calligraphy" flourish.
9. **Form fields + AppBar** — iOS large-title header (big mincho title, back chevron, `ultramarine` "Save" text button); text fields filled `surface`, 12px radius, focus border `ultramarineBright`.
10. **Empty state** — faint `狼` kanji watermark + "No tasks yet" in mincho `inkMuted`.

---

## Section C — Per-screen application + implementation structure

### Per-screen application

1. **Splash** (`splash_screen.dart`) — warm `sumi` canvas; logo, then "ŌKAMI" in Shippori Mincho w300 tracked; a faint `狼` watermark behind and a thin **gradient brush stroke** revealing under the wordmark as the fade plays. Keep the existing fade + 3s timing.
2. **NeuPlas** (`np_screen.dart`) — "Task Manager" in mincho 28 with the gradient brush accent beneath; "Today" in `inkMuted`. The two action tiles become **InkCards**. Task list rebuilt with the new **Task row**. Empty state → `狼` watermark + mincho text.
3. **New / Edit task** (`new_task_screen.dart`, `edit_task_screen.dart`) — iOS large-title AppBar (mincho title, back chevron, `ultramarine` Save). `FieldLabel`s in Inter; text fields restyled (filled `surface`, 12px radius, `ultramarineBright` focus). Refined `PrioritySelector` / `CategorySelector` / `RepeatToggle`. Full-width primary button with `accentGradient` fill + 14px radius.
4. **Bottom nav** (`main_screen.dart`) — apply the restyled `NavigationBar` (mostly inherited from theme; keep the 4 destinations as-is).

### Implementation structure (theme-first)

- **`lib/theme/app_theme.dart`** — define all tokens (`AppColors` + a new `AppGradients`), the `google_fonts` text theme (Shippori Mincho + Inter), and themed defaults: `CardTheme`, `NavigationBarTheme`, `InputDecorationTheme`, `SegmentedButtonTheme`, `ChipTheme`, `FilledButtonTheme`, `AppBarTheme`, `SwitchTheme`.
- **`lib/widgets/app_widgets.dart`** (currently empty) — house `InkCard`, `TaskRow`, `ActionTile`, `BrushStroke` (CustomPainter), `SectionTitle` (mincho + brush), `KanjiWatermark`.
- **`lib/widgets/task_form_widgets.dart`** — restyle the existing `PrioritySelector` / `CategorySelector` / `RepeatToggle` / `FieldLabel` in place.
- **Screens** — refactored to consume tokens + components; no hard-coded colors left behind.
- **`pubspec.yaml`** — already has `google_fonts`; no new deps. (google_fonts fetches at runtime by default; bundling fonts is an optional follow-up.)

### Out of scope (today)

Home, Body, Motion tab content remain placeholders.

### Verification

- `flutter analyze` stays green (No issues found).
- Run on `emulator-5554` to eyeball each screen.
