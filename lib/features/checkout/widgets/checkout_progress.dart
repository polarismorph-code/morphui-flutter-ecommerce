import 'package:flutter/material.dart';

import '../../../core/theme/theme_colors.dart';

class CheckoutProgress extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const CheckoutProgress({
    super.key,
    required this.currentStep,
    this.labels = const ['Shipping', 'Payment', 'Review'],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < currentStep
                          ? context.colorText
                          : context.colorBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: i + 1 == currentStep
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: i < currentStep
                          ? context.colorText
                          : context.colorFaint,
                    ),
                  ),
                ],
              ),
            ),
            if (i < labels.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
