import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morphui/morphui.dart';

/// Holds the live [MorphAnalyticsConfig].
///
/// • Default is `null` — privacy-first. Nothing leaves the device until
///   the user flips the consent switch in Settings.
/// • Setting it to a config with `userConsent: true` makes the SDK start
///   uploading anonymized aggregates. Flipping back to `null` (or to
///   `userConsent: false`) triggers an immediate revocation: the SDK
///   wipes its local behavioral store and stops the timer.
class AnalyticsConsentNotifier extends StateNotifier<MorphAnalyticsConfig?> {
  AnalyticsConsentNotifier() : super(null);

  void enable() {
    state = MorphAnalyticsConfig(
      enabled: true,
      userConsent: true,
      // Demo override — push every minute so a reviewer can see the
      // pipeline live without waiting 24 h.
      uploadInterval: const Duration(minutes: 1),
      minInteractions: 1,
    );
  }

  /// Revoke consent. Setting back to null is the privacy-correct way:
  /// MorphProvider.didUpdateWidget detects the transition and calls
  /// `_db.clearAll()`.
  void revoke() {
    state = null;
  }
}

final analyticsConsentProvider =
    StateNotifierProvider<AnalyticsConsentNotifier, MorphAnalyticsConfig?>(
  (ref) => AnalyticsConsentNotifier(),
);
