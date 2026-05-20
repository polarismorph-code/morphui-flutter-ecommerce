import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_colors.dart';
import '../../../shared/providers/cart_provider.dart';

class ReviewStep extends ConsumerWidget {
  final Map<String, dynamic> shippingData;
  final Map<String, dynamic> paymentData;
  final VoidCallback onConfirm;

  const ReviewStep({
    super.key,
    required this.shippingData,
    required this.paymentData,
    required this.onConfirm,
  });

  String _maskCard(String card) {
    if (card.length < 4) return '••••';
    return '•••• •••• •••• ${card.substring(card.length - 4)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: ListView(
        children: [
          Text(
            'Review order',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: context.colorText,
                ),
          ),
          const SizedBox(height: 16),
          _section(context, 'Ship to', [
            shippingData['name'] as String? ?? '',
            shippingData['street'] as String? ?? '',
            '${shippingData['city'] ?? ''}, ${shippingData['postal'] ?? ''}',
          ]),
          const SizedBox(height: 10),
          _section(context, 'Payment', [
            _maskCard(paymentData['cardNumber'] as String? ?? ''),
            paymentData['holder'] as String? ?? '',
          ]),
          const SizedBox(height: 10),
          _section(context, 'Items', [
            for (final i in cart.items) '${i.quantity} × ${i.product.name}',
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colorBorder),
            ),
            child: Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Place order'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<String> lines) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: context.colorSubtle,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            if (line.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colorText,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
