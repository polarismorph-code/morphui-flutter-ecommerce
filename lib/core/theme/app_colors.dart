import 'package:flutter/material.dart';
import 'package:morphui/morphui.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7);
  static const Color surfaceSecondary = Color(0xFFEFEFEF);

  // Brand — near-black as primary CTA, indigo reserved for accents
  static const Color primary = Color(0xFF0D0D0D);
  static const Color accent = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF4F46E5);

  // Text
  static const Color text = Color(0xFF0D0D0D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFFA3A3A3);
  static const Color textInverted = Color(0xFFFFFFFF);

  // Structure
  static const Color border = Color(0xFFE8E8E8);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color disabled = Color(0xFFEBEBEB);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);

  // E-commerce
  static const Color price = Color(0xFF0D0D0D);
  static const Color discount = Color(0xFFDC2626);
  static const Color rating = Color(0xFFF59E0B);
}

/// 12-stop neutral scale (s25 → s950). Drives the in-app palette
/// visualizer in Settings and demonstrates how Morph mirrors the scale
/// when the system flips to dark mode (s25 ↔ s950, s50 ↔ s900, …).
///
/// Reach the brightness-aware version via
/// `AppColorsNeutral.of(context).s50`.
class AppColorsNeutral {
  static const Color s25 = Color(0xFFFFFFFF);
  static const Color s50 = Color(0xFFFAFAFA);
  static const Color s100 = Color(0xFFF4F4F4);
  static const Color s200 = Color(0xFFE8E8E8);
  static const Color s300 = Color(0xFFD4D4D4);
  static const Color s400 = Color(0xFFA3A3A3);
  static const Color s500 = Color(0xFF737373);
  static const Color s600 = Color(0xFF525252);
  static const Color s700 = Color(0xFF404040);
  static const Color s800 = Color(0xFF262626);
  static const Color s900 = Color(0xFF171717);
  static const Color s950 = Color(0xFF0A0A0A);

  static const MorphPaletteStops stops = MorphPaletteStops(
    s25: s25,
    s50: s50,
    s100: s100,
    s200: s200,
    s300: s300,
    s400: s400,
    s500: s500,
    s600: s600,
    s700: s700,
    s800: s800,
    s900: s900,
    s950: s950,
  );

  /// Brightness-aware accessor — auto-mirrors stops in dark mode so
  /// each position keeps its semantic meaning (s25 stays the
  /// lightest-end, s950 the darkest-end relative to current bg).
  static MorphPaletteStops of(BuildContext ctx) => stops.adapt(ctx);
}
