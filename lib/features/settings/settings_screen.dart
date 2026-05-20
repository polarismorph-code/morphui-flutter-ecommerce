import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morphui/morphui.dart';
import 'package:morphui_flutter_ecommerce/core/theme/theme_colors.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/providers/analytics_provider.dart';
import 'widgets/palette_stops_strip.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _storageKb = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshStorage();
  }

  Future<void> _refreshStorage() async {
    final size = await context.morphStorageSize;
    if (!mounted) return;
    setState(() => _storageKb = size);
  }

  @override
  Widget build(BuildContext context) {
    final plan = context.morphPlan;
    // Null-safe read — Settings can be the very first tab if the
    // user deep-links there before MorphProvider's bootstrap finishes.
    final isDark =
        context.maybeMorph?.theme.mode == ThemeMode.dark;
    final analytics = ref.watch(analyticsConsentProvider);
    final analyticsOn = analytics?.canUpload ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorBackground,
   foregroundColor: context.colorText,
        title:  Text('Settings', style: TextStyle(fontWeight: FontWeight.w700, color: context.colorText)),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            title: 'Morph SDK',
            children: [
              _row('Plan', plan.label),
              _row(
                'Theme',
                isDark
                    ? 'Dark (auto-generated)'
                    : 'Light (your AppColors)',
              ),
              _row('Local data', '$_storageKb KB'),
            ],
          ),
          const SizedBox(height: 12),

          // ── Palette stops — demonstrates MorphPaletteStops + the
          //    s25 ↔ s950 mirroring on brightness flip.
          _card(
            title: 'Palette stops',
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  'Your neutral scale, mirrored in dark mode so every '
                  'stop keeps its semantic role.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: PaletteStopsStrip(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Analytics consent — drives MorphAnalyticsConfig live ──
          _card(
            title: 'Privacy',
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Behavioral data stays on this device by default. '
                  'Nothing is transmitted unless you opt in below.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                title: const Text('Share anonymized usage data'),
                subtitle: Text(
                  analyticsOn
                      ? 'Aggregates upload every ${analytics!.uploadInterval.inMinutes} min.'
                      : 'Off — Morph keeps everything local.',
                  style: const TextStyle(fontSize: 12),
                ),
                value: analyticsOn,
                onChanged: (v) {
                  final notifier =
                      ref.read(analyticsConsentProvider.notifier);
                  if (v) {
                    notifier.enable();
                  } else {
                    // Revoking nulls the config — MorphProvider then
                    // wipes the local store and stops the reporter.
                    notifier.revoke();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear local Morph data'),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await context.clearMorphData();
                  if (!mounted) return;
                  await _refreshStorage();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Local data cleared.')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Pro-tier feature gated by PlanGate. Settings is one of
          //    the surfaces where the SDK-branded MorphUpsellCard is
          //    safe to show — devs typically hide it everywhere else.
          _card(
            title: 'Premium features',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: PlanGate(
                  requiredPlan: MorphPlan.business,
                  featureName: 'AI insights dashboard',
                  fallback: MorphUpsellCard(
                    featureName: 'AI insights dashboard',
                    requiredPlan: MorphPlan.business,
                    onUpgrade: () => debugPrint(
                      'Wire your billing flow here (e.g. RevenueCat).',
                    ),
                  ),
                  child: _aiInsightsCard(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: const Text('Show upgrade dialog'),
                subtitle: const Text(
                  'Demonstrates context.requireMorphPro + MorphUpgradeDialog.',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
                onTap: () {
                  context.requireMorphPro(
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pro is active — running the gated callback.',
                        ),
                      ),
                    ),
                    onDenied: () => showDialog(
                      context: context,
                      builder: (_) => const MorphUpgradeDialog(
                        requiredPlan: MorphPlan.professional,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          _card(
            title: 'About this demo',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Morph + Flutter E-commerce'),
                subtitle: Text('Reference implementation · MIT licensed'),
              ),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text('morphui.dev'),
                trailing: const Icon(
                  Icons.open_in_new,
                  color: AppColors.textTertiary,
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aiInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'AI insights',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Conversion drivers, abandonment patterns, cohort retention. '
            'Refreshed daily from the local behavior store.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
