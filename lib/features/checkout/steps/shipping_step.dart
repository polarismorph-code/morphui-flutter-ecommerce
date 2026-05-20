import 'package:flutter/material.dart';
import 'package:morphui/morphui.dart';

import '../../../core/theme/theme_colors.dart';

class ShippingStep extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final ValueChanged<Map<String, dynamic>> onCompleted;
  final VoidCallback? onStartOver;

  const ShippingStep({
    super.key,
    this.initialData,
    required this.onCompleted,
    this.onStartOver,
  });

  @override
  State<ShippingStep> createState() => _ShippingStepState();
}

class _ShippingStepState extends State<ShippingStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _postal;

  // Previous lengths to detect backspace (typing error signal)
  int _prevNameLen = 0;
  int _prevStreetLen = 0;
  int _prevCityLen = 0;
  int _prevPostalLen = 0;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData ?? const {};
    _name = TextEditingController(text: d['name'] as String? ?? '');
    _street = TextEditingController(text: d['street'] as String? ?? '');
    _city = TextEditingController(text: d['city'] as String? ?? '');
    _postal = TextEditingController(text: d['postal'] as String? ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _street.dispose();
    _city.dispose();
    _postal.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCompleted({
      'name': _name.text,
      'street': _street.text,
      'city': _city.text,
      'postal': _postal.text,
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
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      onChanged: (v) {
        _onFieldChanged(v, prevLen());
        setPrevLen(v.length);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Taps on the form background (not hitting a TextField) = tap error
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
                'Shipping address',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorText,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Where should we deliver your order?',
                style: TextStyle(fontSize: 13, color: context.colorSubtle),
              ),
              const SizedBox(height: 20),
              FatigueAdaptiveForm(
                onReset: () {
                  debugPrint('🦎 SHIPPING FatigueAdaptiveForm.onReset called');
                  _name.clear();
                  _street.clear();
                  _city.clear();
                  _postal.clear();
                  widget.onStartOver?.call();
                },
                normalFields: [
                  _field(_name, label: 'Full name',
                      prevLen: () => _prevNameLen,
                      setPrevLen: (l) => _prevNameLen = l),
                  const SizedBox(height: 12),
                  _field(_street, label: 'Street',
                      prevLen: () => _prevStreetLen,
                      setPrevLen: (l) => _prevStreetLen = l),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: _field(_city, label: 'City',
                          prevLen: () => _prevCityLen,
                          setPrevLen: (l) => _prevCityLen = l),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(_postal,
                          label: 'Postal code',
                          keyboard: TextInputType.number,
                          prevLen: () => _prevPostalLen,
                          setPrevLen: (l) => _prevPostalLen = l),
                    ),
                  ]),
                ],
                simplifiedFields: [
                  _field(_name, label: 'Full name',
                      prevLen: () => _prevNameLen,
                      setPrevLen: (l) => _prevNameLen = l),
                  const SizedBox(height: 12),
                  _field(_postal,
                      label: 'Postal code',
                      keyboard: TextInputType.number,
                      prevLen: () => _prevPostalLen,
                      setPrevLen: (l) => _prevPostalLen = l),
                ],
                submitButton: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Continue to payment'),
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
