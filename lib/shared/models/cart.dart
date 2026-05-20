import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.effectivePrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );
  }
}

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.08;

  double get shipping => subtotal > 100 ? 0 : 9.99;

  double get total => subtotal + tax + shipping;

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;
}
