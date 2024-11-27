import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../repositories/product_repository.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get cart => List.unmodifiable(_cart);

  double get _totalPrice => _cart.fold(
    0,
        (sum, item) => sum + item.product.price * item.quantity,
  );

  double get totalPrice => _totalPrice;

  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _cart.add(CartItem(product: product, quantity: 1));
    } else {
      _cart[index].quantity++;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
    } else {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cart[index].quantity = quantity;
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _cart.map((item) => {
      'product': {
        'id': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'image': item.product.image,
        'description': item.product.description,
      },
      'quantity': item.quantity,
    }).toList();
    await prefs.setString('cart', jsonEncode(cartData));
  }

  Future<void> loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');
    if (cartString != null) {
      final cartData = jsonDecode(cartString) as List;
      _cart.clear();
      for (final item in cartData) {
        final productData = item['product'];
        _cart.add(
          CartItem(
            product: Product(
              id: productData['id'],
              name: productData['name'],
              price: productData['price'],
              image: productData['image'],
              description: productData['description'],
            ),
            quantity: item['quantity'],
          ),
        );
      }
      notifyListeners();
    }
  }

  Future<void> clearStoredCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    notifyListeners();
  }
}
