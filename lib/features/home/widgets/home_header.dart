import 'package:flutter/material.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/theme/theme_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Overlay approach: always readable regardless of the generated theme.
    // Dark mode → white tint lifts the surface above the background.
    // Light mode → black tint drops it below the background.
    final fieldBg = Color.alphaBlend(
      isDark
          ? Colors.white.withValues(alpha: 0.09)
          : Colors.black.withValues(alpha: 0.055),
      cs.surface,
    );
    final placeholderColor = cs.onSurface.withValues(alpha: 0.40);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting row ─────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                            color: context.colorText,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Curated picks, just for you',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colorSubtle,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: fieldBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.onSurface.withValues(alpha: 0.08),
                    width: 0.75,
                  ),
                ),
                child: Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Search bar ───────────────────────────────────────────────
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.onSurface.withValues(alpha: 0.08),
                width: 0.75,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                AppIcon(
                  AppIcons.search,
                  size: 18,
                  color: placeholderColor,
                ),
                const SizedBox(width: 10),
                Text(
                  'Search products…',
                  style: TextStyle(
                    fontSize: 14,
                    color: placeholderColor,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
