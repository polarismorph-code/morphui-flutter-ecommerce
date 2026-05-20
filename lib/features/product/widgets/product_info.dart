import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/models/product.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                product.brand.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: context.colorSubtle,
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, size: 13, color: AppColors.rating),
              const SizedBox(width: 4),
              Text(
                '${product.rating} (${product.reviewCount})',
                style: TextStyle(fontSize: 12, color: context.colorSubtle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorText,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${product.effectivePrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: context.colorText,
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: 10),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colorFaint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Divider(height: 1, color: context.colorDivider),
          const SizedBox(height: 24),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 15,
              color: context.colorSubtle,
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 16),
          if (product.inStock)
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'In stock — ships in 2–3 days',
                  style: TextStyle(fontSize: 13, color: context.colorSubtle),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
