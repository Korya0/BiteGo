---
name: figma-to-flutter
description: "Use when converting a Figma design (screenshot, Dev Mode code, or MCP data) into Flutter UI code, implementing a screen/component from a visual design, mapping Figma tokens to an existing Design System, or building presentation-layer widgets from a design reference; not state management, API calls, or architecture (see flutter-app-architecture, bloc)."
---
# Figma to Flutter

Convert a Figma design into production-ready Flutter UI code that belongs in the target project — same tokens, same shared widgets, same conventions — not a generic screen that happens to look similar.

## When to Use

Use this skill when:

* Building a screen or component from a Figma design, screenshot, or Dev Mode export.
* Mapping Figma spacing, colors, typography, or radius to an existing Design System.
* Converting Figma Auto Layout into Flutter `Column`/`Row`/`Expanded` composition.
* Deciding how to export icons vs. SVG assets from a Figma frame.
* Flagging missing states (disabled, error, empty, loading) that a static Figma frame doesn't show.
* Localizing and making a Figma-derived screen RTL-ready.

---

## 1. Scope Boundary

This skill is **presentation-layer only**. Know what's in and what's out:

| ✅ In scope | ❌ Out of scope |
|---|---|
| Layout, spacing, padding | State management (Cubit/Bloc/Riverpod) |
| Design System tokens | API/networking calls |
| Shared widgets, reusable components | Dependency injection |
| Assets (images/icons/SVG/fonts) | Architecture layers, business logic |
| Localization strings, RTL support | Repository/service wiring |
| Responsiveness, text scaling | Navigation logic beyond visual shell |

---

## 2. Input Sources & Priority

The design can arrive in any combination. Use whichever is available — never block on missing formats:

- **Figma MCP** (Priority 1): Structure, tokens, exact values.
- **Figma Dev Mode code** (Priority 2): CSS/numeric values for spacing, colors, radius, fonts.
- **Screenshot(s)** (Priority 3): Visual layout/appearance confirmation.

For details on matching tokens to Design System resources, see **[references/design-system-tokens.md](references/design-system-tokens.md)**.

---

## 3. Read Before You Build

**Never write a single widget before understanding the project's existing systems.** Discover and document these before starting:
- **Token system** (colors, spacing, radius, typography).
- **Shared widgets** (existing reusable components).
- **Asset pattern** (folder structure, access method).
- **Icon library** (which icon package is used).
- **Localization** (string files, access pattern).
- **Spacing widget** (reusable gap/spacer widget).

---

## 4. Spacing — The Gap Widget

Never scatter raw `SizedBox` calls for inter-element spacing.
- Use (or create if missing) one reusable **`Gap` widget** in `core/common/` (or equivalent).
- Map Figma Auto Layout "gap" property directly to this `Gap` widget with the token-matched value.
- If an equivalent widget already exists under a different name, **reuse it** — don't create a duplicate.
- `Padding` is for container insets; `Gap` is for inter-element spacing. Don't confuse them.

---

## 5. Layout & Widgets

Build layouts with the constraint system, not with rigid coordinates. Follow the `flutter-use-column-row-first` principle:

- **Reuse before creating.** Check `core/widgets/` for existing components.
- **Avoid `Stack`/`Positioned` as default.** Use only for genuine visual overlap (badges, floating buttons).
- **Avoid `Container`.** Use `Padding`, `DecoratedBox`, `ColoredBox`, `SizedBox`, `Center`.
- **Extract widgets.** If a subtree is reused or exceeds ~40 lines, extract it into a named widget.

For detailed guidelines on screen responsiveness, localizations, and RTL mirror support, see **[references/responsive-and-rtl.md](references/responsive-and-rtl.md)**.

---

## 6. Icons vs. Images (SVG)

Not every visual element from Figma should be exported the same way:
- **Simple/common icons** (arrows, chevrons, close, check) → use the project's existing icon package. Do NOT export as a separate asset.
- **Illustrative or brand-specific graphics** → export as SVG into the project's assets structure.
- **Always check** for an existing equivalent in the project's icon/asset set before exporting.

---

## 7. Flagging Design Gaps

Static Figma frames usually show only the happy path. **Flag — never silently invent** — any of these:
- **Disabled state**: Button/input when not interactive.
- **Pressed/focus state**: Tap feedback, keyboard focus ring.
- **Loading state**: Spinner/skeleton/shimmer (visual shell only).
- **Empty/Error state**: Layout and placeholders.
- **Long text overflow**: Wrap? Ellipsis? Scroll?
- **Dummy content**: Build widget to accept dynamic content via parameters.

Propose a sensible default AND state plainly that it's an assumption, so the user can correct it.

---

## 8. Common Pitfalls

| Pitfall | Fix |
|---|---|
| Hardcoded colors/spacing/radius | Map every value to an existing Design System token |
| Scattered `SizedBox` for spacing | Use the project's Gap widget with spacing tokens |
| Fixed screen dimensions | Use flex layout, `Expanded`, `Flexible`, responsive tokens |
| `EdgeInsets.only(left/right)` | Use `EdgeInsetsDirectional.only(start/end)` for RTL |
| Hardcoded strings | Route through localization system (`context.l10n`) |
| Exporting common icons as SVG | Use the project's existing icon package instead |
| Inventing visual states silently | Flag gaps from §7, propose defaults as explicit assumptions |

---

## 9. Final Quality Check

1. **`flutter analyze`** — zero errors, zero warnings, zero info.
2. **Overflow check** — verify no overflow across at least two different screen widths.
3. **RTL check** — visually confirm layout mirrors correctly with `Directionality.rtl`.
4. **Token audit** — confirm no hardcoded color, spacing, radius, or typography values remain.

---

## 10. Reporting

When you finish, report:
1. **Files created / modified** — list each file and what it contains.
2. **Tokens used vs. values with no existing match** — what needs Design System approval.
3. **Design gaps flagged** (from §7) — the assumption made for each, awaiting confirmation.
4. **Missing systems found** (from §3) — tokens, asset pattern, localization, or icons that need project-level decisions.

---

## References

- See `flutter-use-column-row-first` skill for detailed layout composition rules.
- See `flutter-best-practices` skill for architecture/coding standards that apply after the UI shell is built.
- See `inclusive-design` skill for localization, RTL, and global-audience considerations.
- See [references/design-system-tokens.md](references/design-system-tokens.md) for matching typography, colors, spacing, and radius specs.
- See [references/responsive-and-rtl.md](references/responsive-and-rtl.md) for responsive constraint systems, localization keys, and RTL support.
