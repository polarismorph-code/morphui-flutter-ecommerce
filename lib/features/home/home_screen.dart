import 'package:flutter/material.dart';
import 'package:morphui/morphui.dart';

import '../../core/constants/app_constants.dart';
import 'widgets/categories_section.dart';
import 'widgets/featured_section.dart';
import 'widgets/home_header.dart';
import 'widgets/recent_section.dart';
import 'widgets/trending_section.dart';

/// Home — demonstrates Morph's behavioral zone reordering.
///
/// Each section is wrapped in a [MorphZone] so click + time-spent are
/// tracked independently. After enough sessions, the local
/// [ZoneScorer] decides on a new order and [MorphReorderableColumn]
/// applies it on next frame. Nothing leaves the device.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HomeHeader(),
            MorphReorderableColumn(
              zones: const [
                MorphZone(
                  id: AppConstants.zoneFeatured,
                  priority: 0,
                  child: FeaturedSection(),
                ),
                MorphZone(
                  id: AppConstants.zoneCategories,
                  priority: 1,
                  child: CategoriesSection(),
                ),
                MorphZone(
                  id: AppConstants.zoneTrending,
                  priority: 2,
                  child: TrendingSection(),
                ),
                MorphZone(
                  id: AppConstants.zoneRecent,
                  priority: 3,
                  child: RecentSection(),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
