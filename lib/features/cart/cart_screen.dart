import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_colors.dart';
import '../../shared/models/cart.dart';
import '../../shared/providers/cart_provider.dart';
import 'widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorBackground,
       foregroundColor: context.colorText,
        title: Text(cart.isEmpty ? 'Cart' : 'Cart (${cart.itemCount})', style: TextStyle(fontWeight: FontWeight.w700, color: context.colorText)),
        automaticallyImplyLeading: false,
      ),
      body: cart.isEmpty
          ? _emptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemTile(
                        item: item,
                        onQuantityChanged: (q) =>
                            notifier.updateQuantity(item.product.id, q),
                        onRemove: () => notifier.removeItem(item.product.id),
                      );
                    },
                  ),
                ),
                _Summary(cart: cart),
              ],
            ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 56,
            color: context.colorFaint,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'Add something you love',
            style: TextStyle(color: context.colorSubtle, fontSize: 14),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => context.go('/browse'),
            child: const Text('Browse products'),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final Cart cart;
  const _Summary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: context.colorBackground,
        border: Border(top: BorderSide(color: context.colorBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(context, 'Subtotal', cart.subtotal),
          const SizedBox(height: 8),
          _row(context, 'Tax (8%)', cart.tax),
          const SizedBox(height: 8),
          _row(context, 'Shipping', cart.shipping,
              note: cart.shipping == 0 ? 'Free' : null),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: context.colorDivider),
          ),
          _row(context, 'Total', cart.total, isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/checkout'),
              child: const Text('Proceed to checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, double amount,
      {bool isTotal = false, String? note}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? context.colorText : context.colorSubtle,
            letterSpacing: isTotal ? -0.3 : 0,
          ),
        ),
        if (note != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              note,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ),
        ],
        const Spacer(),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: isTotal ? -0.3 : 0,
          ),
        ),
      ],
    );
  }
}
