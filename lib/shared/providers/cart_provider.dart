import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(const Cart());

  void addItem(Product product, {int quantity = 1}) {
    final existing = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existing >= 0) {
      final updated = [...state.items];
      updated[existing] = updated[existing].copyWith(
        quantity: updated[existing].quantity + quantity,
      );
      state = Cart(items: updated);
    } else {
      state = Cart(
        items: [
          ...state.items,
          CartItem(product: product, quantity: quantity),
        ],
      );
    }
  }

  void removeItem(String productId) {
    state = Cart(
      items:
          state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updated = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    state = Cart(items: updated);
  }

  void clear() {
    state = const Cart();
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Cart>((ref) => CartNotifier());
