<div align="center">

<img src="https://morphui.dev/icon.png" alt="Morph" width="64" height="64" />

# morph — Flutter E-commerce Demo

**Every Morph SDK feature, one app, one checkout.**

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)](https://flutter.dev)
[![SDK](https://img.shields.io/badge/morphui-0.1.2-4F46E5)](https://pub.dev/packages/morphui)
[![License](https://img.shields.io/badge/license-MIT-06B6D4)](LICENSE)

[SDK docs](https://morphui.dev/docs/flutter) · [pub.dev](https://pub.dev/packages/morphui) · [Dashboard](https://app.morphui.dev/dashboard)

</div>

---

## What this demonstrates

A fully functional e-commerce app — browse, cart, checkout — where every
screen exercises one or more Morph SDK features on a real device.
No toy examples. No stubs. Each feature has an exact test path described below.

| # | Feature | Plan | Screen |
|---|---------|------|--------|
| 1 | AI dark mode from `AppColors` | Free | System toggle |
| 2 | Semantic color extension (`ThemeColors`) | Free | All screens |
| 3 | Zone reorder (`MorphReorderableColumn`) | Pro | Home |
| 4 | Navigation reorder (`MorphReorderableNav`) | Pro | Bottom nav |
| 5 | Grip detection (`GripAdaptiveLayout`) | Pro | Product |
| 6 | Battery-aware UI (`BatteryAwareWidget`) | Pro | Catalog |
| 7 | Interruption recovery — checkout (`morphSetCheckoutMultiStepContext`) | Pro | Checkout |
| 8 | Recovery card refusal → restart (`onSuggestionRefused`) | Pro | Checkout |
| 9 | Fatigue detection — banner + simplified form (`FatigueAdaptiveForm`) | Agency | Checkout |
| 10 | Analytics consent toggle | Agency | Settings |

---

## Prerequisites

- Flutter 3.10+, Dart 3+
- The SDK lives at `../chameleon_flutter` (path dependency — same parent folder)
- Physical device recommended. Grip detection and battery signals don't work on emulators.
- Android or iOS — both work. Samsung tested on SM-S921B.

---

## Quick start

```bash
git clone https://github.com/morphuiapp/morphui-flutter-ecommerce
cd morphui-flutter-ecommerce
flutter pub get
flutter run
```

> The app uses a local `path:` dependency on `../chameleon_flutter`.
> Once the SDK ships on pub.dev, replace with `morphui: ^0.1.2` in `pubspec.yaml`.

---

## Demo configuration

Two `MorphConfig` flags are active in this demo. **Remove them before shipping to production.**

```dart
// lib/main.dart
config: const MorphConfig(
  devMinPauseSeconds: 5,       // Default is 30 s. Lets recovery card appear after 5 s.
  devEnableAllFeatures: true,  // Unlocks Agency features (fatigue, GPS) on a FREE key.
),
```

The overlay timers are also shortened for demos:

```dart
MorphSuggestionOverlay(
  firstCheckDelay: const Duration(seconds: 3),  // Default 30 s
  checkInterval:   const Duration(seconds: 15), // Default 3 min
  child: child,
)
```

---

## Feature test guide

### 1 · AI dark mode

Morph generates the opposite theme from your `AppColors` — no hand-written `darkTheme`.

```dart
MorphProvider(
  baseTheme: AppTheme.light,
  colors: const MorphColors(
    background: AppColors.background,
    primary:    AppColors.primary,
    // ...
  ),
  child: MaterialApp.router(
    theme:     AppTheme.light,
    darkTheme: AppTheme.dark,   // soft fallback — Morph overrides this
    themeMode: ThemeMode.system,
  ),
)
```

**How to test**
1. Open the app in light mode.
2. Toggle system dark mode.
3. Every screen animates to the AI-generated palette. Text, surfaces, buttons
   all adapt — nothing turns pure black.

---

### 2 · Semantic colors (`ThemeColors`)

All widgets read from `Theme.of(context)` through a `BuildContext` extension.
Switching brightness is automatic — no `if (isDark)` anywhere in the UI code.

```dart
// lib/core/theme/theme_colors.dart
extension ThemeColors on BuildContext {
  Color get colorBackground => Theme.of(this).scaffoldBackgroundColor;
  Color get colorText        => Theme.of(this).colorScheme.onSurface;
  Color get colorSubtle      => Theme.of(this).colorScheme.onSurfaceVariant;
  // ...
}
```

**How to test**
Toggle dark mode while browsing any screen. Headings, subtitles, borders,
and backgrounds all update together. No widget needs a manual color override.

---

### 3 · Zone reorder (`MorphReorderableColumn`)

Morph tracks interaction frequency per zone locally (Hive — nothing leaves the
device). After `minInteractions: 20` threshold, zones promoted by the scorer
float upward automatically.

```dart
// lib/features/home/home_screen.dart
MorphReorderableColumn(
  zones: [
    MorphZone(id: 'featured',    priority: 0, child: FeaturedSection()),
    MorphZone(id: 'categories',  priority: 1, child: CategoriesSection()),
    MorphZone(id: 'trending',    priority: 2, child: TrendingSection()),
    MorphZone(id: 'recent',      priority: 3, child: RecentSection()),
  ],
)
```

**How to test**
1. Open the home page.
2. Tap items inside **Trending** or **Recent** repeatedly (20+ taps total).
3. Navigate away and come back — the heavily-tapped zone floats toward the top.

---

### 4 · Navigation reorder (`MorphReorderableNav`)

Same behavioral scorer — applied to the bottom nav. Tabs you visit most
often shift toward your dominant thumb side.

**How to test**
1. Visit **Catalog** and **Cart** repeatedly over several sessions.
2. After 20+ tab switches, the most-used tab migrates toward position 1 or 2.

---

### 5 · Grip detection (`GripAdaptiveLayout`)

The accelerometer decides which hand is dominant. The primary action
(Add to Cart) repositions toward the active thumb — no permission required.

```dart
// lib/features/product/product_screen.dart
GripAdaptiveLayout(
  primaryAction: AddToCartButton(product: product),
  child: ProductDetail(product: product),
)
```

**How to test**
1. Open any product page.
2. Hold the phone naturally in your **right** hand — the Add to Cart button
   appears at **bottom-right**.
3. Switch to your **left** hand — the button slides to **bottom-left** within
   a second.

---

### 6 · Battery-aware UI (`BatteryAwareWidget`)

Four image-quality tiers driven by live battery level.
Charging overrides battery level — a phone at 12% while plugged in stays in `normal`.

```dart
// lib/features/catalog/widgets/adaptive_product_card.dart
BatteryAwareWidget(
  normal:   AdaptiveProductCard(quality: ImageQuality.high,    showAnimations: true),
  medium:   AdaptiveProductCard(quality: ImageQuality.medium,  showAnimations: true),
  low:      AdaptiveProductCard(quality: ImageQuality.low,     showAnimations: false),
  critical: AdaptiveProductCard(quality: ImageQuality.minimal, minimalMode: true),
)
```

| Battery | Tier | What changes |
|---------|------|-------------|
| ≥ 40 % | `normal` | Full images, animations on |
| 20–40 % | `medium` | Compressed images |
| 10–20 % | `low` | Thumbnail only, no animations |
| < 10 % | `critical` | Text-only card |

**How to test**
1. Open the Catalog screen.
2. Watch the battery badge in the card — updates as battery level changes.
3. Unplug the device and let it drain to < 20 % to see a tier downgrade.

---

### 7 · Interruption recovery — checkout

The user fills the shipping form, backgrounds the app for 5 s+, and comes back.
Morph surfaces a recovery card: **"Pick up where you left off?"**

```dart
// lib/features/checkout/checkout_screen.dart
context.morphSetCheckoutMultiStepContext(
  workflowId: _workflowId,
  step:        _currentStep,
  totalSteps:  3,
  cartData:    { 'total': cart.total, 'itemCount': cart.itemCount },
  savedData:   { for (final e in _savedStepData.entries) 'step${e.key}': e.value },
  strategy:    RecoveryStrategy.confirm,  // explicit confirm before rehydrate
  ttl:         const Duration(minutes: 15),
);
```

Each step completion is also recorded as a navigation signal:

```dart
void _completeStep(int step, Map<String, dynamic> data) {
  context.morphFatigueDetector?.recordNavigationError(); // feeds fatigue scorer
  setState(() { _savedStepData[step] = data; ... });
  _declareStep();
}
```

**How to test**
1. Start checkout → fill **Shipping** → tap **Continue to payment**.
2. Press Home (background the app) → wait 5 s.
3. Return to the app.
4. The recovery card appears: tap **Continue** — you resume at **Payment** with
   shipping data pre-filled.

**Recovery card — "Start over" behavior**

When the user taps **Start over** on the recovery card, `onSuggestionRefused`
fires and resets the checkout to step 1 via a Riverpod signal:

```dart
// lib/main.dart
MorphSuggestionOverlay(
  onSuggestionRefused: (s) {
    if (s.id.startsWith('recovery_/checkout')) {
      ref.read(checkoutStartOverSignalProvider.notifier).state++;
    }
  },
  child: child,
)

// lib/features/checkout/checkout_screen.dart
ref.listen<int>(checkoutStartOverSignalProvider, (_, _) {
  if (mounted) _startOver(); // resets to step 1, clears saved data
});
```

---

### 8 · Fatigue detection (`FatigueAdaptiveForm`)

Morph scores six behavioral signals in real time. When the score crosses
the banner threshold, an inline notice appears at the top of the form.
Past the simplified threshold, non-essential fields hide automatically.

```dart
// lib/features/checkout/steps/payment_step.dart
FatigueAdaptiveForm(
  normalFields: [
    cardNumberField, cardholderField, expiryField, cvcField,
  ],
  simplifiedFields: [
    cardNumberField, cvcField, // only essentials when fatigue is high
  ],
  submitButton: ElevatedButton(onPressed: _submit, child: Text('Review order')),
  onReset: () {
    _cardNumber.clear(); _holder.clear(); _expiry.clear(); _cvc.clear();
    widget.onStartOver?.call(); // walks back to step 1 Shipping
  },
)
```

**Fatigue score — signal weights**

| Signal | How it's recorded | Max contribution |
|--------|-------------------|-----------------|
| Missed taps (last 10) | `recordTap(position, targetCenter, targetSize)` | 40 pts |
| Typing slowdown | `recordKeystroke()` on every keystroke | 20 pts |
| Navigation errors | `recordNavigationError()` on each step completion | 15 pts |
| Typing errors | `recordTypingError()` on each backspace | 5 pts |
| Tap errors | `recordTapError()` on background tap | 5 pts |
| Session > 30 min | automatic | 10 pts |

**Thresholds (demo — lowered for fast testing)**

| Score | Effect |
|-------|--------|
| ≥ 15 | Banner `"Interface adjusted"` fades in |
| ≥ 40 | Simplified form activates, banner reads `"Simplified view active"` |

Production defaults: banner at 40, simplified at 70.

**How to test — natural path**

1. Enter the checkout → fill Shipping → **Continue** (1 nav error, +3 pts).
2. Fill Payment → **Review order** (2 nav errors, +6 pts).
3. Tap **Start over** on the recovery card or go back and repeat 2–3 more times.
4. After **5 step completions** (15 pts), the banner appears automatically.
5. Making typos (backspace) and tapping the form background accelerates it.

**How to test — debug FAB (debug builds only)**

A small brain icon FAB appears at bottom-right of the checkout screen in
debug builds (`kDebugMode`). Tap it once to instantly saturate all error
counters and see the banner without filling forms repeatedly.

```dart
// Visible in debug only — removed from release builds automatically
FloatingActionButton.small(
  onPressed: () => context.morphFatigueDetector?.debugForceHighFatigue(),
  child: Icon(Icons.psychology_alt_outlined),
)
```

**"Start over" on the fatigue banner**

The inline banner has its own **"Start over"** button — separate from the
recovery card. Tapping it:
1. Resets the fatigue score to 0 (`detector.resetFatigue()`).
2. Clears all form fields.
3. Navigates the checkout back to step 1 Shipping.

---

### 9 · Analytics consent

Morph never sends data without `enabled: true` AND `userConsent: true`.
The Settings screen wires the toggle.

```dart
// lib/main.dart
analytics: analytics, // null → nothing leaves the device

// lib/shared/providers/analytics_provider.dart
final analyticsConsentProvider = StateProvider<MorphAnalyticsConfig?>((ref) => null);
```

**How to test**
1. Open **Settings → Share usage data**.
2. Toggle ON → analytics starts (aggregated, never content).
3. Toggle OFF → local store wiped immediately via `_db.clearAll()`.

---

## Morph integration map

```
main.dart
 └── MorphProvider                      ← SDK root: colors, features, config
      └── MaterialApp.router
           └── builder:
                └── MorphSuggestionOverlay ← recovery card surface
                     ├── onSuggestionRefused → checkoutStartOverSignalProvider
                     └── navigator

home_screen.dart
 └── MorphReorderableColumn             ← zone reorder
      └── MorphZone × 4

product_screen.dart
 └── GripAdaptiveLayout                 ← thumb tracking
      └── primaryAction: AddToCartButton

catalog_screen.dart
 └── BatteryAwareWidget                 ← 4 image-quality tiers

checkout_screen.dart
 ├── context.morphSetCheckoutMultiStepContext  ← step snapshot + chain
 ├── ref.listen(checkoutStartOverSignalProvider) ← reacts to card refusal
 └── steps/
      ├── shipping_step.dart
      │    └── FatigueAdaptiveForm      ← adaptive fields + inline banner
      └── payment_step.dart
           └── FatigueAdaptiveForm
```

---

## Project structure

```text
lib/
├── main.dart                        # MorphProvider · MorphSuggestionOverlay
├── core/
│   ├── constants/app_constants.dart # license key · workflow prefix
│   ├── routes/app_router.dart       # GoRouter · MorphNavigatorObserver
│   └── theme/
│       ├── app_colors.dart          # brand palette constants
│       ├── app_theme.dart           # AppTheme.light / AppTheme.dark
│       └── theme_colors.dart        # BuildContext color extension
├── features/
│   ├── home/                        # MorphReorderableColumn · 4 zones
│   ├── catalog/                     # BatteryAwareWidget grid
│   ├── product/                     # GripAdaptiveLayout · Add to cart
│   ├── cart/                        # Cart summary
│   ├── checkout/
│   │   ├── checkout_screen.dart     # Recovery chain · fatigue signals
│   │   ├── steps/
│   │   │   ├── shipping_step.dart   # FatigueAdaptiveForm
│   │   │   ├── payment_step.dart    # FatigueAdaptiveForm
│   │   │   └── review_step.dart
│   │   └── widgets/checkout_progress.dart
│   └── settings/                    # Analytics toggle · plan badge · clear data
└── shared/
    ├── models/                      # Product · Cart · Category
    ├── data/                        # Mock products
    ├── providers/
    │   ├── cart_provider.dart
    │   ├── analytics_provider.dart
    │   └── checkout_reset_provider.dart  # Riverpod signal for card refusal
    └── widgets/                     # MorphStatusBadge · FeatureCallout
```

---

## Tech stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.10+ |
| Language | Dart 3+ |
| Routing | go_router |
| State | flutter_riverpod |
| SDK | morphui (path dep → pub.dev on release) |
| Storage | Hive (via SDK) — all behavioral data local |

---

## License

MIT — clone, fork, customize, ship.

---

<div align="center">

[morphui.dev](https://morphui.dev) · [Docs](https://morphui.dev/docs/flutter) · [Dashboard](https://app.morphui.dev/dashboard) · [pub.dev](https://pub.dev/packages/morphui)

Built with [Morph](https://morphui.dev) — the Intelligent UI SDK for Flutter + React.

</div>
