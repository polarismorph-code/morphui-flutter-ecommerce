import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/models/product.dart';

enum CardQuality { high, medium, low, minimal }

class AdaptiveProductCard extends StatelessWidget {
  final Product product;
  final CardQuality quality;
  final bool showAnimations;

  const AdaptiveProductCard({
    super.key,
    required this.product,
    this.quality = CardQuality.high,
    this.showAnimations = true,
  });

  String _imageUrl() {
    const widths = {
      CardQuality.high: 600,
      CardQuality.medium: 400,
      CardQuality.low: 200,
      CardQuality.minimal: 80,
    };
    final base = product.images.first;
    final uri = Uri.parse(base);
    final params = Map<String, String>.from(uri.queryParameters)
      ..['w'] = '${widths[quality]}';
    return uri.replace(queryParameters: params).toString();
  }

  @override
  Widget build(BuildContext context) {
    if (quality == CardQuality.minimal) {
      return _MinimalCard(product: product);
    }

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _imageUrl(),
                    fit: BoxFit.cover,
                    fadeInDuration: showAnimations
                        ? const Duration(milliseconds: 200)
                        : Duration.zero,
                    placeholder: (_, _) =>
                        Container(color: context.colorSurfaceHigh),
                    errorWidget: (_, _, _) =>
                        Container(color: context.colorSurfaceHigh),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorAction,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: TextStyle(
                            color: context.colorOnAction,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                '\$${product.effectivePrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: -0.3,
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: 5),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.colorFaint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MinimalCard extends StatelessWidget {
  final Product product;
  const _MinimalCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colorSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.battery_2_bar, size: 16, color: AppColors.warning),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const Spacer(),
            Text(
              '\$${product.effectivePrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
