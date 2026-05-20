import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morphui/morphui.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/analytics_provider.dart';
import 'shared/providers/checkout_reset_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MorphEcommerceApp()));
}

class MorphEcommerceApp extends ConsumerWidget {
  const MorphEcommerceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Live analytics config — null when the user hasn't opted in.
    // Toggling the switch in Settings rebuilds this widget; MorphProvider's
    // didUpdateWidget detects the new config and starts/stops the reporter.
    final analytics = ref.watch(analyticsConsentProvider);

    return MorphProvider(
      // FREE-tier demo key. Pro features print upgrade hints in debug
      // logs and silently no-op at runtime — perfect for an OSS demo.
      // Replace with a paid key from https://morphui.dev to unlock the
      // full feature set.
      licenseKey: AppConstants.morphLicenseKey,

      // Pass the existing brand palette through MorphColors slots.
      // Morph uses these to generate the dark variant on brightness flip.
      colors: const MorphColors(
        background: AppColors.background,    // #FFFFFF
        surface: AppColors.surface,          // #F7F7F7
        surfaceSecondary: AppColors.surfaceSecondary,
        primary: AppColors.primary,          // #0D0D0D near-black
        secondary: AppColors.accent,         // #4F46E5 Morph indigo
        text: AppColors.text,
        textSecondary: AppColors.textSecondary,
        textTertiary: AppColors.textTertiary,
        textInverted: AppColors.textInverted,
        border: AppColors.border,
        error: AppColors.error,
        success: AppColors.success,
        warning: AppColors.warning,
      ),

      // Field-by-field opt-in so the README can map each flag to a
      // demo screen. Use MorphFeatures.ecommerce() in your own app for
      // the curated preset.
      config: const MorphConfig(
        devMinPauseSeconds: 5,
        devEnableAllFeatures: true,
      ),
      features: const MorphFeatures(
        interruptionRecovery: true,
        gripDetection: true,
        batteryAware: true,
        fatigueDetection: true,
        gpsContext: false,
      ),

      // Driving theme generation off the live light theme. Morph fills
      // in `context.morph.adaptedTheme` once the brightness flips.
      baseTheme: AppTheme.light,

      // Privacy-first analytics. Default `null` = nothing leaves the
      // device. Settings → "Share usage data" toggles this on.
      analytics: analytics,

      // MaterialApp.router is built ONCE — adapting the theme inside
      // the outer Builder would tear down and rebuild the entire
      // Router (and its branch Navigators) every time MorphProvider's
      // bootstrap or brightness change fires, causing GlobalKey
      // reservation collisions in `Navigator._updatePages`. Instead,
      // we wrap the Navigator output via [MaterialApp.builder] —
      // there, rebuilds only swap the theme around the existing
      // navigation tree without remounting any Navigator state.
      child: MaterialApp.router(
        title: 'Morph E-commerce Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        builder: (ctx, child) {
          final adapted = ctx.maybeMorph?.adaptedTheme;
          // When a checkout recovery card is refused ("Start over"),
          // signal CheckoutScreen to reset to step 1 via the provider.
          Widget overlayed = MorphSuggestionOverlay(
            firstCheckDelay: const Duration(seconds: 3),
            checkInterval: const Duration(seconds: 15),
            onSuggestionRefused: (s) {
              if (s.id.startsWith('recovery_/checkout')) {
                debugPrint('🦎 MAIN recovery refused: ${s.id} → signalling checkout reset');
                ref.read(checkoutStartOverSignalProvider.notifier).state++;
              }
            },
            child: child ?? const SizedBox.shrink(),
          );
          if (adapted != null) {
            overlayed = Theme(data: adapted, child: overlayed);
          }
          return overlayed;
        },
      ),
    );
  }
}
