import 'package:flutter/material.dart';

/// Semantic color accessors that always read from the live [ThemeData].
/// Use these instead of [AppColors] constants whenever the color must
/// flip between light and dark mode.
///
/// ```dart
/// // ❌ hardcoded — stays light-mode in dark
/// color: AppColors.textSecondary
///
/// // ✅ theme-aware — flips with Morph's adapted theme
/// color: context.colorSubtle
/// ```
extension ThemeColors on BuildContext {
  ThemeData get _t => Theme.of(this);
  ColorScheme get _cs => _t.colorScheme;

  // ── Backgrounds ─────────────────────────────────────────────────────
  Color get colorBackground => _t.scaffoldBackgroundColor;
  Color get colorSurface => _cs.surface;
  Color get colorSurfaceHigh => _cs.surfaceContainerHighest;

  // ── Text ────────────────────────────────────────────────────────────
  Color get colorText => _cs.onSurface;
  Color get colorSubtle => _cs.onSurfaceVariant;
  Color get colorFaint => _cs.onSurface.withValues(alpha: 0.38);

  // ── Structure ───────────────────────────────────────────────────────
  Color get colorBorder => _cs.outlineVariant;
  Color get colorDivider => _cs.outlineVariant.withValues(alpha: 0.6);

  // ── Actions ─────────────────────────────────────────────────────────
  /// Primary CTA color — near-black in light, near-white in dark.
  Color get colorAction => _cs.onSurface;
  /// Text on primary action (CTA button label).
  Color get colorOnAction => _cs.surface;
}
