class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.images,
    required this.category,
    required this.brand,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.inStock = true,
  });

  bool get hasDiscount =>
      discountedPrice != null && discountedPrice! < price;

  double get effectivePrice => discountedPrice ?? price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return ((1 - discountedPrice! / price) * 100).round();
  }
}
