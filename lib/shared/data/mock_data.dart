import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';

class MockData {
  static const List<Category> categories = [
    Category(
      id: 'electronics',
      name: 'Electronics',
      icon: Icons.devices,
      color: Color(0xFF4F46E5),
    ),
    Category(
      id: 'fashion',
      name: 'Fashion',
      icon: Icons.shopping_bag,
      color: Color(0xFF7C3AED),
    ),
    Category(
      id: 'home',
      name: 'Home',
      icon: Icons.home,
      color: Color(0xFF06B6D4),
    ),
    Category(
      id: 'sports',
      name: 'Sports',
      icon: Icons.sports_soccer,
      color: Color(0xFF10B981),
    ),
    Category(
      id: 'beauty',
      name: 'Beauty',
      icon: Icons.face,
      color: Color(0xFFEC4899),
    ),
    Category(
      id: 'books',
      name: 'Books',
      icon: Icons.book,
      color: Color(0xFFF59E0B),
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'Premium Wireless Headphones',
      description:
          'Noise-cancelling headphones with 30h battery life. '
          'Industry-leading audio quality.',
      price: 349.99,
      discountedPrice: 279.99,
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600',
      ],
      category: 'electronics',
      brand: 'AudioMax',
      rating: 4.8,
      reviewCount: 1247,
    ),
    Product(
      id: 'p2',
      name: 'Smart Watch Series 8',
      description:
          'Advanced health tracking with AMOLED display. '
          'Water resistant up to 50m.',
      price: 449.99,
      images: [
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600',
      ],
      category: 'electronics',
      brand: 'TechWear',
      rating: 4.6,
      reviewCount: 892,
    ),
    Product(
      id: 'p3',
      name: 'Designer Leather Jacket',
      description:
          'Genuine leather, hand-crafted. Timeless style.',
      price: 599.99,
      images: [
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
      ],
      category: 'fashion',
      brand: 'StyleCo',
      rating: 4.7,
      reviewCount: 234,
    ),
    Product(
      id: 'p4',
      name: 'Modern Coffee Table',
      description:
          'Solid oak, scandinavian design. '
          'Perfect for any living room.',
      price: 299.99,
      discountedPrice: 249.99,
      images: [
        'https://images.unsplash.com/photo-1499933374294-4584851497cc?w=600',
      ],
      category: 'home',
      brand: 'NordicHome',
      rating: 4.9,
      reviewCount: 156,
    ),
    Product(
      id: 'p5',
      name: 'Running Shoes Pro',
      description:
          'Lightweight, responsive cushioning. What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. '
          'Built for serious runners.',
      price: 159.99,
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      ],
      category: 'sports',
      brand: 'ActiveLife',
      rating: 4.5,
      reviewCount: 2103,
    ),
    Product(
      id: 'p6',
      name: 'Minimalist Backpack',
      description:
          'Water-resistant, laptop compartment, USB charging port.',
      price: 89.99,
      images: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      ],
      category: 'fashion',
      brand: 'UrbanGear',
      rating: 4.4,
      reviewCount: 567,
    ),
    Product(
      id: 'p7',
      name: 'Premium Skincare Set',
      description:
          'Complete routine: cleanser, serum, moisturizer, SPF.',
      price: 129.99,
      discountedPrice: 99.99,
      images: [
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600',
      ],
      category: 'beauty',
      brand: 'GlowLab',
      rating: 4.7,
      reviewCount: 891,
    ),
    Product(
      id: 'p8',
      name: 'Wireless Charging Pad',
      description:
          'Fast 15W wireless charging. Compatible with all devices.',
      price: 49.99,
      images: [
        'https://images.unsplash.com/photo-1591290619762-c34af2dc92ea?w=600',
      ],
      category: 'electronics',
      brand: 'TechWear',
      rating: 4.3,
      reviewCount: 1456,
    ),
    Product(
      id: 'p9',
      name: 'Yoga Mat Premium',
      description:
          '6mm thick, eco-friendly, non-slip surface.',
      price: 69.99,
      images: [
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600',
      ],
      category: 'sports',
      brand: 'ZenLife',
      rating: 4.6,
      reviewCount: 723,
    ),
    Product(
      id: 'p10',
      name: 'Bestseller Novel Collection',
      description:
          '5-book set of award-winning contemporary fiction.',
      price: 79.99,
      discountedPrice: 59.99,
      images: [
        'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=600',
      ],
      category: 'books',
      brand: 'PageTurner',
      rating: 4.8,
      reviewCount: 412,
    ),
  ];

  static List<Product> getProductsByCategory(String categoryId) =>
      products.where((p) => p.category == categoryId).toList();

  static List<Product> getFeatured() =>
      products.where((p) => p.hasDiscount).take(3).toList();

  static List<Product> getTrending() {
    final list = products.where((p) => p.reviewCount > 500).toList()
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return list;
  }

  static List<Product> getRecent() => products.take(5).toList();
}
