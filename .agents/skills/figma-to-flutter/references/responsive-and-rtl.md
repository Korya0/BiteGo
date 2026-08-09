# Responsive, Localization, & RTL Reference

Detailed guidelines to ensure screens generated from Figma adapt correctly to different device screens, languages, and right-to-left layout directions.

---

## 1. RTL (Right-to-Left) Support

Always ensure layouts support RTL languages like Arabic. Use directional layout parameters and classes.

### Directional Conversions Checklist

| ❌ Non-Directional (Avoid) | ✅ Directional (Use) |
|---|---|
| `EdgeInsets.only(left: 8)` | `EdgeInsetsDirectional.only(start: 8)` |
| `EdgeInsets.fromLTRB(8, 0, 16, 0)` | `EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0)` |
| `Alignment.centerLeft` | `AlignmentDirectional.centerStart` |
| `Alignment.topRight` | `AlignmentDirectional.topEnd` |
| `Positioned(left: 10)` | `PositionedDirectional(start: 10)` |

### Icons mirroring
For directional icons (e.g., arrow back, chevron right):
Wrap them in `Transform.flip` or use standard icons that auto-mirror if supported by the icon library:
```dart
// Auto-mirroring directional icon
Icon(Icons.adaptive.arrow_forward)
```

---

## 2. Responsive Layouts

Never design layouts hardcoded to specific viewport widths/heights (like `375x812`).

### Responsive Layout Patterns

#### Wrap for Grid-like content
```dart
// BAD — hardcoded width/height grid
Row(
  children: [
    SizedBox(width: 100, child: Card1()),
    SizedBox(width: 100, child: Card2()),
  ],
)

// GOOD — responsive Wrap that shifts based on available space
Wrap(
  spacing: context.spacing.md,
  runSpacing: context.spacing.md,
  children: [
    Card1(),
    Card2(),
  ],
)
```

#### Safe Scrolling Constraints
Ensure vertical layouts can scroll on smaller screens:
```dart
// GOOD — safe scrollable layout
LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: Column(
          children: [
            Header(),
            Expanded(child: MainList()), // Ensure bounded height within list!
            Footer(),
          ],
        ),
      ),
    );
  },
)
```

---

## 3. Localization Setup

No hardcoded copy. Connect every text visual widget to the localization bundle.

### String Extraction Guidelines
1. Identify all text frames in the Figma design.
2. Check if identical keys already exist in translation files (e.g., `l10n/app_en.arb`).
3. If missing, generate camelCase keys describing the role, not the text:
   - ❌ Bad key: `welcomeBackUser` (assumes copy)
   - ✅ Good key: `login_welcome_header` (semantic context)
4. Use standard interpolation for variable text:
   - `{username}` in `.arb` mapping to `context.l10n.login_welcome_header(username)`.
