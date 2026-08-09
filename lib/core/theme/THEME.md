# Theme System

`core/theme` is the single source of truth for the application's visual design system.

## Purpose

Centralize all design tokens so the entire application remains visually consistent and global design changes can be made from one place.

## Available APIs

Access theme tokens from any widget using `BuildContext` extensions.

### Colors

```dart
context.color.primary
context.color.backgroundPrimary
context.color.backgroundSecondary
context.color.textPrimary
context.color.textSecondary
context.color.textOnPrimary
context.color.textOnPrimaryAlt
context.color.iconPrimary
context.color.iconText
context.color.iconSuccess
context.color.iconError
context.color.iconBlack
context.color.iconSecondary
```

### Text Styles

Located in `core/theme/fonts/app_text_styles.dart`.

```dart
context.textStyle.title
context.textStyle.subtitle
context.textStyle.body
context.textStyle.caption
```

Use `copyWith` for screen-specific adjustments:

```dart
Text(
  'Hello',
  style: context.textStyle.title.copyWith(
    fontSize: context.space.fontSizeXl,
    color: context.color.textPrimary,
  ),
)
```

### Spacing

```dart
context.space.xs // 4.0
context.space.sm // 8.0
context.space.md // 16.0
context.space.lg // 24.0
context.space.xl // 32.0
context.space.xxl // 48.0

context.space.fontSizeXs // 12.0
context.space.fontSizeSm // 14.0
context.space.fontSizeMd // 16.0
context.space.fontSizeLg // 18.0
context.space.fontSizeXl // 20.0
context.space.fontSizeXxl // 24.0
```

```dart
SizedBox(height: context.space.md)
EdgeInsets.all(context.space.md)
context.space.symmetric(horizontal: context.space.md)
context.space.only(left: context.space.sm, top: context.space.md)
```

### Border Radius

```dart
context.radius.sm // 8.0
context.radius.md // 12.0
context.radius.lg // 16.0
context.radius.xl // 24.0
```

```dart
BorderRadius.circular(context.radius.md)
```

### Shadows

```dart
context.shadow.sm
context.shadow.md
context.shadow.lg
```

```dart
boxShadow: context.shadow.sm
```

### Opacity

```dart
context.opacity.disabled // 0.5
context.opacity.medium // 0.7
context.opacity.high // 0.9
```

```dart
color: context.color.textPrimary.withOpacity(context.opacity.medium)
```

## Rules

1. Do not hardcode design-system colors in feature UI code.
2. Do not create duplicate colors.
3. Do not hardcode reusable spacing values.
4. Do not hardcode reusable border-radius values.
5. Do not create arbitrary text styles inside features.
6. Use `copyWith` when a local visual adjustment is genuinely required.
7. Do not bypass the Theme System without a valid reason.
8. New reusable design tokens must be added to `core/theme`.
9. Features should consume the Theme System, not redefine it.
10. Avoid unnecessary abstractions.

## Exception

One-off visual adjustments may use `copyWith`:

```dart
context.textStyle.body.copyWith(
  fontSize: 14,
  color: context.color.textSecondary,
)
```

If the same variation appears repeatedly across the application, promote it into the centralized Theme System.
