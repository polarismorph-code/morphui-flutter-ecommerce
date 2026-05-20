import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphui/morphui.dart';

import '../../features/browse/browse_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/product/product_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/widgets/main_shell.dart';

/// GoRouter's own root Navigator. Detail routes (product / catalog /
/// checkout) point [parentNavigatorKey] at this so they render full
/// screen above the shell, hiding the bottom nav.
final _rootKey = GlobalKey<NavigatorState>();

/// Separate keys per branch so each tab has its own Navigator stack —
/// switching to Cart and back doesn't reset Home's scroll position.
final _homeKey = GlobalKey<NavigatorState>();
final _browseKey = GlobalKey<NavigatorState>();
final _cartKey = GlobalKey<NavigatorState>();
final _settingsKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootKey,
  // The Morph navigator observer is what feeds page-level click +
  // time-spent data into the local behavior store. Without it the
  // recovery and zone-reorder engines have no signal to work with.
  observers: [MorphNavigatorObserver.instance],
  routes: [
    // ── Shell with bottom nav ──────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _browseKey,
          routes: [
            GoRoute(
              path: '/browse',
              builder: (context, state) => const BrowseScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _cartKey,
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Detail routes outside the shell (full-screen) ──────────────
    GoRoute(
      path: '/catalog/:categoryId',
      parentNavigatorKey: _rootKey,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CatalogScreen(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/product/:productId',
      parentNavigatorKey: _rootKey,
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        final product = MockData.products.firstWhere(
          (p) => p.id == productId,
        );
        return ProductScreen(product: product);
      },
    ),
    GoRoute(
      path: '/checkout',
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);
