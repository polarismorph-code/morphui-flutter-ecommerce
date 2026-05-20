import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralized SVG icon widget. All icons read `color` from the
/// current theme by default — pass an explicit [color] to override.
class AppIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color? color;

  const AppIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}

/// Icon asset paths — single source of truth.
abstract final class AppIcons {
  static const home         = 'assets/icons/home.svg';
  static const browse       = 'assets/icons/browse.svg';
  static const bag          = 'assets/icons/bag.svg';
  static const sliders      = 'assets/icons/sliders.svg';
  static const search       = 'assets/icons/search.svg';
  static const heart        = 'assets/icons/heart.svg';
  static const arrowBack    = 'assets/icons/arrow_back.svg';
  static const chevronRight = 'assets/icons/chevron_right.svg';
  static const star         = 'assets/icons/star.svg';
  static const starFilled   = 'assets/icons/star_filled.svg';
}

/// Layered shadow presets — consistent across the whole app.
abstract final class AppShadows {
  /// Subtle lift for cards and surfaces.
  static List<BoxShadow> card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ];
  }

  /// Strong lift for floating elements (nav bar).
  static List<BoxShadow> float(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
        blurRadius: 32,
        offset: const Offset(0, -8),
      ),
    ];
  }
}
