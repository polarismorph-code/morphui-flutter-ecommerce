// Smoke tests for the demo. Morph's bootstrap opens Hive boxes and
// platform channels — full widget tests need a `safeMode: true`
// MorphProvider override. We keep this file minimal to avoid
// pulling that scaffolding into the marketing demo.
import 'package:flutter_test/flutter_test.dart';

import 'package:morphui_flutter_ecommerce/shared/data/mock_data.dart';

void main() {
  test('mock catalog has products and categories', () {
    expect(MockData.products, isNotEmpty);
    expect(MockData.categories, isNotEmpty);
  });

  test('featured products all carry a discount', () {
    final featured = MockData.getFeatured();
    expect(featured.every((p) => p.hasDiscount), isTrue);
  });

  test('trending list is sorted by review count desc', () {
    final trending = MockData.getTrending();
    for (var i = 1; i < trending.length; i++) {
      expect(
        trending[i - 1].reviewCount >= trending[i].reviewCount,
        isTrue,
      );
    }
  });
}
