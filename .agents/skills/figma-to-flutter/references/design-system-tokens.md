# Design System & Token Mapping Reference

Detailed instructions for mapping design values from Figma to the project's Design System.

---

## 1. Color Mapping

Never use hardcoded hex colors in Flutter code. Map them directly to the existing Color Scheme tokens.

| Figma Hex | Token Family | Example Usage |
|---|---|---|
| Dark neutral (e.g., `#1E293B`, `#0F172A`) | Primary/Secondary Text | `context.colors.textPrimary` |
| Light neutral (e.g., `#F8FAFC`, `#F1F5F9`) | Background/Surface | `context.colors.background` |
| Brand color (e.g., `#3B82F6`) | Primary brand action | `context.colors.primary` |
| Green tones (e.g., `#10B981`) | Success states | `context.colors.success` |
| Red tones (e.g., `#EF4444`) | Error states | `context.colors.error` |

### Color Verification Steps
1. Copy the Hex value from Figma Dev Mode/MCP.
2. Search the project's theme or color token file (e.g., `core/theme/colors.dart`) for the closest match.
3. If no matching token exists, propose the nearest semantic fallback and request approval.

---

## 2. Spacing & Padding Mapping

Map the exact pixel values from Figma Auto Layout/Spacing to the nearest step in the project's spacing scale.

```
Figma Px Value  ──>  Semantic Spacing Step  ──>  Flutter Code
    4px         ──>        xs               ──>  context.spacing.xs
    8px         ──>        sm               ──>  context.spacing.sm
   16px         ──>        md               ──>  context.spacing.md
   24px         ──>        lg               ──>  context.spacing.lg
   32px         ──>        xl               ──>  context.spacing.xl
```

### Spacing Guidelines
* **Container Padding**: Use `EdgeInsetsDirectional` mapped to spacing tokens.
* **Inter-element spacing**: Use the shared `Gap` widget with spacing tokens.
* **Avoid Magic Numbers**: Never use raw numbers like `13`, `17`, or `29`. Always round to the nearest token step.

---

## 3. Typography & Text Styles

Never write inline font sizes, font weights, or custom font families. Map to the project's Text Theme tokens.

| Design Role | Typical Specs (Figma) | Flutter Text Style Token |
|---|---|---|
| Main Screen Header | 24px - 32px, Bold | `context.typography.titleLarge` |
| Section Header | 18px - 20px, Semi-Bold | `context.typography.titleMedium` |
| Body Text / Copy | 14px - 16px, Regular | `context.typography.bodyMedium` |
| Captions / Small labels | 11px - 12px, Regular | `context.typography.bodySmall` |
| Button Label | 14px - 16px, Medium/Bold | `context.typography.labelLarge` |

### Text Style Rules
- Use `copyWith` **only** to modify properties that aren't part of the core text style (e.g., overriding color: `context.typography.bodyMedium.copyWith(color: context.colors.primary)`).
- Never override `fontSize` or `fontFamily` using `copyWith`. If a style doesn't fit, flag it.

---

## 4. Border Radius & Shadows

| Design Value (Figma) | Radius Token | Shadow Token |
|---|---|---|
| 4px - 6px corner | `context.radius.sm` | — |
| 8px - 12px corner | `context.radius.md` | `context.shadows.light` |
| 16px - 24px corner | `context.radius.lg` | `context.shadows.medium` |
| Fully Rounded / Pill | `BoxShape.circle` or `context.radius.max` | — |
