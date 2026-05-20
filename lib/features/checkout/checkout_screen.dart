import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../../core/icons/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:morphui/morphui.dart';
import 'package:morphui_flutter_ecommerce/core/theme/theme_colors.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/checkout_reset_provider.dart';
import 'steps/payment_step.dart';
import 'steps/review_step.dart';
import 'steps/shipping_step.dart';
import 'widgets/checkout_progress.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final String _workflowId;
  static const int _totalSteps = 3;
  int _currentStep = 1;
  final Map<int, Map<String, dynamic>> _savedStepData = {};

  @override
  void initState() {
    super.initState();
    _workflowId =
        '${AppConstants.checkoutWorkflowPrefix}-'
        '${DateTime.now().millisecondsSinceEpoch}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _declareStep();
      _restoreFromChainIfAny();
    });
  }

  Map<String, dynamic> _cartSnapshot() {
    final cart = ref.read(cartProvider);
    return {
      'subtotal': cart.subtotal,
      'total': cart.total,
      'itemCount': cart.itemCount,
    };
  }

  void _declareStep() {
    context.morphSetCheckoutMultiStepContext(
      workflowId: _workflowId,
      step: _currentStep,
      totalSteps: _totalSteps,
      cartData: _cartSnapshot(),
      savedData: {
        for (final e in _savedStepData.entries) 'step${e.key}': e.value,
      },
      // Checkout is stakes-sensitive — surface the recovery card so the
      // user explicitly accepts before we rehydrate sensitive payment
      // values. (auto-restore would be a UX trap here.)
      strategy: RecoveryStrategy.confirm,
      // Tighter than the 30-min default: card numbers + shipping go
      // stale fast. Shorter TTL = fewer "did I really want this?" carts.
      ttl: const Duration(minutes: 15),
    );
  }

  void _restoreFromChainIfAny() {
    final fullChain = MorphInheritedWidget.maybeOf(context)
            ?.recovery
            ?.pendingChain ??
        const [];
    // Filter to THIS checkout's workflowId only. The SDK's pendingChain
    // can still contain snapshots from a previous (abandoned) checkout —
    // restoring those would warp the user to the wrong step.
    final chain = fullChain
        .where((s) => s.workflowId == _workflowId)
        .toList();
    debugPrint('🦎 CHECKOUT _restoreFromChainIfAny — '
        'fullChain.length=${fullChain.length} '
        'relevant.length=${chain.length}');
    if (chain.isEmpty) return;
    int latestStep = 0;
    for (final snap in chain) {
      final step = snap.workflowStep ?? 0;
      if (step > latestStep) latestStep = step;
      if (snap.formData.isNotEmpty && step > 0) {
        final d = snap.formData['step$step'];
        if (d is Map) {
          _savedStepData[step] = Map<String, dynamic>.from(d);
        }
      }
    }
    debugPrint('🦎 CHECKOUT chain restored — jumping to step ${latestStep + 1}');
    if (latestStep > 0 && mounted) {
      setState(() => _currentStep = (latestStep + 1).clamp(1, _totalSteps));
    }
  }

  void _startOver() {
    debugPrint('🦎 CHECKOUT _startOver called — was on step $_currentStep');
    setState(() {
      _currentStep = 1;
      _savedStepData.clear();
    });
    debugPrint('🦎 CHECKOUT after setState — currentStep=$_currentStep');
    _declareStep();
  }

  void _completeStep(int step, Map<String, dynamic> data) {
    debugPrint('🦎 CHECKOUT _completeStep called for step $step');
    // Each step completion is a navigation event — feeds the fatigue
    // detector's navigation-error signal (strong indicator of cognitive
    // load when the user repeatedly goes back and forth between steps).
    context.morphFatigueDetector?.recordNavigationError();
    setState(() {
      _savedStepData[step] = data;
      if (step < _totalSteps) _currentStep = step + 1;
    });
    _declareStep();
  }

  void _placeOrder() {
    ref.read(cartProvider.notifier).clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Order placed'),
        content: const Text(
          'Thank you for your purchase. You\'ll receive a confirmation shortly.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Continue shopping'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // When the user taps "Start over" on the recovery card, restart checkout.
    ref.listen<int>(checkoutStartOverSignalProvider, (_, _) {
      debugPrint('🦎 CHECKOUT recovery-card refusal signal received → _startOver');
      if (mounted) _startOver();
    });

    return Scaffold(
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              heroTag: 'fatigue_debug',
              tooltip: 'Force fatigue (debug)',
              onPressed: () {
                debugPrint('🦎 DEBUG FAB — forcing high fatigue');
                context.morphFatigueDetector?.debugForceHighFatigue();
              },
              child: const Icon(Icons.psychology_alt_outlined, size: 20),
            )
          : null,
      appBar: AppBar(
      backgroundColor: context.colorBackground,
     foregroundColor: context.colorText,
        title:  Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700, color: context.colorText)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: AppIcon(AppIcons.arrowBack, size: 18, color: context.colorText),
        ),
      ),
      body: Column(
        children: [
          CheckoutProgress(currentStep: _currentStep),
          Expanded(
            child: IndexedStack(
              index: _currentStep - 1,
              children: [
                ShippingStep(
                  initialData: _savedStepData[1],
                  onCompleted: (d) => _completeStep(1, d),
                  onStartOver: _startOver,
                ),
                PaymentStep(
                  initialData: _savedStepData[2],
                  onCompleted: (d) => _completeStep(2, d),
                  onStartOver: _startOver,
                ),
                ReviewStep(
                  shippingData: _savedStepData[1] ?? const {},
                  paymentData: _savedStepData[2] ?? const {},
                  onConfirm: _placeOrder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
