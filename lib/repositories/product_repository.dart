import 'dart:async';

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });
}

class ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop',
      price: 299999.99,
      image: 'assets/images/laptop.jpg',
      description: 'A high-performance laptop.',
    ),
    Product(
      id: '2',
      name: 'Smartphone',
      price: 239999.99,
      image: 'assets/images/smart-phone.jpg',
      description: 'A feature-packed smartphone.',
    ),
    Product(
      id: '3',
      name: 'Headphones',
      price: 23999.99,
      image: 'assets/images/headphone.jpg',
      description: 'Noise-cancelling headphones.',
    ),
    Product(
      id: '4',
      name: 'Smartwatch',
      price: 89999.99,
      image: 'assets/images/smart-watch.jpg',
      description: 'A stylish smartwatch.',
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  Future<List<Product>> fetchProducts() async {
    try {
      // Simulating API delay by 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      return products;
    } catch (error) {
      // Throw an error for the simulated API
      throw Exception('Failed to fetch products: $error');
    }
  }
}
