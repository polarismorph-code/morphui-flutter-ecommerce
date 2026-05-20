import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:morphui/morphui.dart';

import '../../core/icons/app_icons.dart';
import '../providers/cart_provider.dart';

// ─── Shell ────────────────────────────────────────────────────────────────────

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider).itemCount;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: _AppNavBar(
          currentIndex: navigationShell.currentIndex,
          cartCount: cartCount,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}

// ─── Nav item model ───────────────────────────────────────────────────────────

class _Item {
  final String id;
  final String asset;
  final String label;
  final int priority;
  const _Item(this.id, this.asset, this.label, this.priority);
}

const _kItems = [
  _Item('tab_home',     AppIcons.home,    'Home',     0),
  _Item('tab_browse',   AppIcons.browse,  'Browse',   1),
  _Item('tab_cart',     AppIcons.bag,     'Cart',     2),
  _Item('tab_settings', AppIcons.sliders, 'Settings', 3),
];

// ─── Nav bar ──────────────────────────────────────────────────────────────────

class _AppNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _AppNavBar({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Replicate MorphReorderableNav's reorder logic so the SDK still
    // controls tab order without forcing us to use BottomNavigationBar.
    final w = MorphInheritedWidget.maybeOf(context);
    final orderMap = w?.state.zoneOrder ?? const {};
    final sorted = [..._kItems]..sort((a, b) {
        final oa = orderMap[a.id] ?? a.priority;
        final ob = orderMap[b.id] ?? b.priority;
        return oa.compareTo(ob);
      });

    final currentId = _kItems[currentIndex].id;

    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    final bg = isDark
        ? cs.surface.withValues(alpha: 0.78)
        : cs.surfaceContainerHighest.withValues(alpha: 0.96);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottom > 0 ? bottom + 8 : 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.08),
                width: 0.75,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.14),
                  blurRadius: 40,
                  spreadRadius: -4,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: sorted.map((item) {
                final isSelected = item.id == currentId;
                final badge = item.id == 'tab_cart' ? cartCount : 0;

                return Expanded(
                  child: Semantics(
                    label: item.label,
                    selected: isSelected,
                    button: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        final originalIndex = _kItems
                            .indexWhere((i) => i.id == item.id);
                        if (originalIndex >= 0) onTap(originalIndex);
                        w?.db.trackClick(item.id, 'navigation');
                      },
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon
                            AnimatedScale(
                              scale: isSelected ? 1.10 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              child: AnimatedOpacity(
                                opacity: isSelected ? 1.0 : 0.36,
                                duration: const Duration(milliseconds: 200),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    AppIcon(
                                      item.asset,
                                      size: 22,
                                      color: cs.onSurface,
                                    ),
                                    if (badge > 0)
                                      Positioned(
                                        right: -8,
                                        top: -5,
                                        child: _Badge(
                                          count: badge,
                                          cs: cs,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Active dot
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOut,
                              width: isSelected ? 4 : 0,
                              height: isSelected ? 4 : 0,
                              decoration: BoxDecoration(
                                color: cs.onSurface
                                    .withValues(alpha: isSelected ? 0.8 : 0),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final int count;
  final ColorScheme cs;
  const _Badge({required this.count, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.surface, width: 1.5),
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        count > 9 ? '9+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
