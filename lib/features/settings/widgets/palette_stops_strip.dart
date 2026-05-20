import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';

/// Visualization of [AppColorsNeutral.stops] — 12 swatches s25 → s950
/// with their names. Reads [AppColorsNeutral.of(context)] so the scale
/// auto-mirrors when Morph flips to dark (s25 ↔ s950, …).
class PaletteStopsStrip extends StatelessWidget {
  const PaletteStopsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColorsNeutral.of(context);
    final entries = <(String, Color)>[
      ('s25', p.s25),
      ('s50', p.s50),
      ('s100', p.s100),
      ('s200', p.s200),
      ('s300', p.s300),
      ('s400', p.s400),
      ('s500', p.s500),
      ('s600', p.s600),
      ('s700', p.s700),
      ('s800', p.s800),
      ('s900', p.s900),
      ('s950', p.s950),
    ];

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final (name, color) = entries[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colorBorder,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: context.colorSubtle,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
