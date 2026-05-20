import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Incremented each time the user taps the dismiss button ("Start over")
/// on a checkout recovery card. CheckoutScreen listens and resets to step 1.
final checkoutStartOverSignalProvider = StateProvider<int>((ref) => 0);
