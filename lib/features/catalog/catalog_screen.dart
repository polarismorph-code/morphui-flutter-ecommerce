import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphui/morphui.dart';
import 'package:morphui_flutter_ecommerce/core/theme/theme_colors.dart';

import '../../core/icons/app_icons.dart';
import '../../shared/data/mock_data.dart';
import 'widgets/adaptive_product_card.dart';

class CatalogScreen extends StatelessWidget {
  final String categoryId;

  const CatalogScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final products = MockData.getProductsByCategory(categoryId);
    final category = MockData.categories.firstWhere(
      (c) => c.id == categoryId,
    );

    return Scaffold(
      appBar: AppBar(
         backgroundColor: context.colorBackground,
          foregroundColor: context.colorText,
        title: Text(category.name, style: TextStyle(fontWeight: FontWeight.w700, color: context.colorText)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: AppIcon(AppIcons.arrowBack, size: 20, color: context.colorText),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return BatteryAwareWidget(
            normal: AdaptiveProductCard(
              product: product,
              quality: CardQuality.high,
              showAnimations: true,
            ),
            medium: AdaptiveProductCard(
              product: product,
              quality: CardQuality.medium,
              showAnimations: true,
            ),
            low: AdaptiveProductCard(
              product: product,
              quality: CardQuality.low,
              showAnimations: false,
            ),
            critical: AdaptiveProductCard(
              product: product,
              quality: CardQuality.minimal,
              showAnimations: false,
            ),
          );
        },
      ),
    );
  }
}
