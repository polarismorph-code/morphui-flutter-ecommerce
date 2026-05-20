import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_icons.dart';
import '../../../shared/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────────────────────────────
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.images.first,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: cs.surfaceContainerHighest,
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: cs.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                          size: 28,
                        ),
                      ),
                    ),
                    // Wishlist button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _WishlistButton(cs: cs),
                    ),
                    // Discount badge
                    if (product.hasDiscount)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _DiscountBadge(
                          percent: product.discountPercent,
                          cs: cs,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      height: 1.3,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating row
                  _RatingRow(rating: product.rating, cs: cs),
                  const SizedBox(height: 8),
                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${product.effectivePrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                          color: cs.onSurface,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 5),
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                            decoration: TextDecoration.lineThrough,
                            decorationColor:
                                cs.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  final ColorScheme cs;
  const _WishlistButton({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          AppIcons.heart,
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(
            cs.onSurface.withValues(alpha: 0.6),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final int percent;
  final ColorScheme cs;
  const _DiscountBadge({required this.percent, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: cs.onSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-$percent%',
        style: TextStyle(
          color: cs.surface,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  final ColorScheme cs;
  const _RatingRow({required this.rating, required this.cs});

  @override
  Widget build(BuildContext context) {
    final filled = rating.floor();
    return Row(
      children: [
        ...List.generate(5, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: SvgPicture.asset(
              i < filled ? AppIcons.starFilled : AppIcons.star,
              width: 10,
              height: 10,
              colorFilter: ColorFilter.mode(
                i < filled
                    ? const Color(0xFFF59E0B)
                    : cs.onSurface.withValues(alpha: 0.18),
                BlendMode.srcIn,
              ),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
