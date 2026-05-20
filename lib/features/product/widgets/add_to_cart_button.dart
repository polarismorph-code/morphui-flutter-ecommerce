import 'package:flutter/material.dart';

import '../../../core/theme/theme_colors.dart';
import '../../../shared/models/product.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const AddToCartButton({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: context.colorAction,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: context.colorAction.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 17,
              color: context.colorOnAction,
            ),
            const SizedBox(width: 8),
            Text(
              'Add  ·  \$${product.effectivePrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: context.colorOnAction,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
