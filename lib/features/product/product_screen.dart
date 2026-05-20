import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:morphui/morphui.dart';
import 'package:morphui_flutter_ecommerce/core/theme/theme_colors.dart';

import '../../core/icons/app_icons.dart';
import '../../shared/models/product.dart';
import '../../shared/providers/cart_provider.dart';
import 'widgets/add_to_cart_button.dart';
import 'widgets/product_gallery.dart';
import 'widgets/product_info.dart';

class ProductScreen extends ConsumerWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorBackground,
      body: GripAdaptiveLayout(
        primaryAction: AddToCartButton(
          product: product,
          onPressed: () {
            ref.read(cartProvider.notifier).addItem(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added to cart'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Cart',
                  onPressed: () => context.go('/cart'),
                ),
              ),
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: context.colorBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: context.colorSurface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.pop(),
                    child: AppIcon(
                      AppIcons.arrowBack,
                      size: 18,
                      color: context.colorText,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: context.colorSurface,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 20,
                          color: context.colorText,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: ProductGallery(images: product.images),
            ),
            SliverToBoxAdapter(
              child: ProductInfo(product: product),
            ),
            const SizedBox(height: 120).sliver,
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}
