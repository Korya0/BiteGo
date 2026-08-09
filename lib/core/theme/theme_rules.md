# AI Coding Rules for Theme & Design System

Future agents and developers modifying this codebase must adhere to the following rules:

1. **Never hardcode application colors** inside widgets. Always use `context.colors.<name>` or `AppColors.<name>`.
2. **Never hardcode repeated spacing values**. Use `context.sizes.spacingXs` to `context.sizes.spacingXxl`.
3. **Never hardcode repeated component dimensions**. Use `context.sizes.buttonHeight`, `context.sizes.inputHeight`, etc.
4. **Never create duplicate color constants**. Check [app_colors.dart](file:///d:/flutter/flutter_Projects/bite_go/lib/core/theme/app_colors.dart) first.
5. **Never create duplicate typography constants**. Check [app_text_styles.dart](file:///d:/flutter/flutter_Projects/bite_go/lib/core/theme/app_text_styles.dart) first.
6. **Always reuse existing design tokens**.
7. **Use semantic color names** (e.g., `backgroundPrimary`, `textPrimary`) instead of physical ones (e.g., `white`, `darkGray`).
8. **Use TextTheme for standard typography** through `context.textStyles.<name>`.
9. **Use ColorScheme for Material components**.
10. **Add a new token only when the value is genuinely reusable** across multiple screens/components.
11. **Do not create a new file for a token category** unless the category is verified and the project size warrants it.
12. **Do not introduce a new abstraction** when an existing one is sufficient.
13. **Do not introduce a new dependency** without a clear requirement.
14. **Never create another ThemeCubit** since the project uses a single light mode theme as configured.
15. **Never create another LocalStorage implementation** if one already exists.
16. **Never bypass the LocalStorage interface** if theme configurations need persistence in the future.
17. **Respect the selected font's supported weights**. For Inter in this project, only `FontWeight.w500` (Medium) and `FontWeight.w600` (SemiBold) are available.
18. **Do not invent unsupported font weights** like `w300`, `w400`, or `w700`.
19. **Do not use arbitrary colors from UI code**.
20. **Prefer semantic tokens** over raw hex/Color values.
