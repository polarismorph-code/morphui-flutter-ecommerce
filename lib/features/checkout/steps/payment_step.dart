import 'package:flutter/material.dart';
import 'package:morphui/morphui.dart';

import '../../../core/theme/theme_colors.dart';

class PaymentStep extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final ValueChanged<Map<String, dynamic>> onCompleted;
  final VoidCallback? onStartOver;

  const PaymentStep({
    super.key,
    this.initialData,
    required this.onCompleted,
    this.onStartOver,
  });

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cardNumber;
  late final TextEditingController _holder;
  late final TextEditingController _expiry;
  late final TextEditingController _cvc;

  int _prevCardLen = 0;
  int _prevHolderLen = 0;
  int _prevExpiryLen = 0;
  int _prevCvcLen = 0;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData ?? const {};
    _cardNumber = TextEditingController(text: d['cardNumber'] as String? ?? '');
    _holder = TextEditingController(text: d['holder'] as String? ?? '');
    _expiry = TextEditingController(text: d['expiry'] as String? ?? '');
    _cvc = TextEditingController(text: d['cvc'] as String? ?? '');
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _holder.dispose();
    _expiry.dispose();
    _cvc.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCompleted({
      'cardNumber': _cardNumber.text,
      'holder': _holder.text,
      'expiry': _expiry.text,
      'cvc': _cvc.text,
    });
  }

  void _onFieldChanged(String value, int prevLen) {
    final fd = context.morphFatigueDetector;
    if (fd == null) return;
    fd.recordKeystroke();
    if (value.length < prevLen) fd.recordTypingError();
  }

  Widget _field(
    TextEditingController controller, {
    required String label,
    String? hint,
    TextInputType? keyboard,
    int minLength = 1,
    required int Function() prevLen,
    required void Function(int) setPrevLen,
  }) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.38)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.onSurface, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),
      validator: (v) => v == null || v.length < minLength ? 'Required' : null,
      onChanged: (v) {
        _onFieldChanged(v, prevLen());
        setPrevLen(v.length);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.morphFatigueDetector?.recordTapError(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorText,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Demo only — values stay on device.',
                style: TextStyle(fontSize: 13, color: context.colorSubtle),
              ),
              const SizedBox(height: 20),
              FatigueAdaptiveForm(
                onReset: () {
                  debugPrint('🦎 PAYMENT FatigueAdaptiveForm.onReset called');
                  _cardNumber.clear();
                  _holder.clear();
                  _expiry.clear();
                  _cvc.clear();
                  widget.onStartOver?.call();
                },
                normalFields: [
                  _field(_cardNumber,
                      label: 'Card number',
                      hint: '4242 4242 4242 4242',
                      keyboard: TextInputType.number,
                      minLength: 12,
                      prevLen: () => _prevCardLen,
                      setPrevLen: (l) => _prevCardLen = l),
                  const SizedBox(height: 12),
                  _field(_holder,
                      label: 'Cardholder',
                      prevLen: () => _prevHolderLen,
                      setPrevLen: (l) => _prevHolderLen = l),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: _field(_expiry,
                          label: 'Expiry',
                          hint: 'MM/YY',
                          prevLen: () => _prevExpiryLen,
                          setPrevLen: (l) => _prevExpiryLen = l),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(_cvc,
                          label: 'CVC',
                          keyboard: TextInputType.number,
                          minLength: 3,
                          prevLen: () => _prevCvcLen,
                          setPrevLen: (l) => _prevCvcLen = l),
                    ),
                  ]),
                ],
                simplifiedFields: [
                  _field(_cardNumber,
                      label: 'Card number',
                      hint: '4242 4242 4242 4242',
                      keyboard: TextInputType.number,
                      minLength: 12,
                      prevLen: () => _prevCardLen,
                      setPrevLen: (l) => _prevCardLen = l),
                  const SizedBox(height: 12),
                  _field(_cvc,
                      label: 'CVC',
                      keyboard: TextInputType.number,
                      minLength: 3,
                      prevLen: () => _prevCvcLen,
                      setPrevLen: (l) => _prevCvcLen = l),
                ],
                submitButton: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Review order'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
