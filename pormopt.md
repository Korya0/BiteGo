# Project Prompt

Notes for AI features in this project. Copy the whole block below and paste it into your prompt.

---

## General Rules

- Do NOT write comments in code.
- Do NOT hardcode font sizes in code. Use the design tokens instead:
  - `context.fontSize.*` (e.g. `context.fontSize.md`, `context.fontSize.titleSm`).
  - `context.space.fontSizeXl`, etc.
- Do NOT hardcode colors, spacing, border-radius, or text styles in feature UI. Use the Theme System via `BuildContext` extensions (`context.color.*`, `context.space.*`, `context.radius.*`, `context.textStyle.*`).
- View widgets should pad content with `context.screenPadding`.
- All UI rules are documented in `lib/core/theme/THEME.md`.

## Strings

- Use `AppStrings` from `lib/core/constants/app_strings.dart` for all copy. If a string is not present, add it there first — do not inline literal strings in widgets.
- Example: `AppStrings.loginButton`, `AppStrings.cartEmptyTitle`.

## Assets

- ALWAYS reference assets through `AppAssets` (`core/constants/app_assets.dart`). Never hardcode asset paths like `'assets/svgs/empty_state.svg'` inline — use `AppAssets.svgsEmptyState` instead.
- If an asset constant does not exist yet, add it to `AppAssets` first.

## Empty States

- When a screen has no data, show the shared empty state widget:
  `lib/core/common/app_empty_state.dart` → `AppEmptyState`.
- Pass the shared empty asset via the constant: `assetPath: AppAssets.svgsEmptyState`.
- Provide `title`, `message`, and optional `actionLabel`/`onActionPressed`.
- Reference implementation: `lib/features/favorites/presentation/widgets/favorites_empty_view.dart`.

## Loading (Shimmer) States

- Follow the pattern in `lib/features/home/presentation/widgets/home_loading_view.dart`.
- Wrap the success view in `Skeletonizer` + `SkeletonizerConfig` using placeholder data models.
- Use shimmer colors from the theme: `context.color.shimmerBase`, `context.color.shimmerHighlight`.

## Components

- Reusable UI components live in `lib/core/common/`. Reuse them (`AppButton`, `AppTextButton`, `AppTextField`, `AppDialog`, `AppBottomSheet`, `AppGap`, `AppAppBar`, etc.) instead of building from scratch.

## Logging & Error Reporting

- Logging lives in `lib/core/logging/`:
  - `app_logger.dart` → `AppLogger` (debug, info, success, warning, error).
  - `error_reporter.dart` → `ErrorReporter` interface.
  - `reporters/firebase_crashlytics_reporter.dart`.
- Report errors worth reporting to the `ErrorReporter` (e.g. via `AppLogger.error(..., report: true)`).
- Avoid duplicating logging/reporting logic across more than one layer.
