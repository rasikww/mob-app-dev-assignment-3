import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_summary_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    cartItem.product.image,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(cartItem.product.name),
                  subtitle: Text(
                      'Rs.${NumberFormat.decimalPattern('en_US').format(cartItem.product.price)} x ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cartProvider.updateQuantity(
                              cartItem.product, cartItem.quantity - 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProvider.updateQuantity(
                              cartItem.product, cartItem.quantity + 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cartProvider.removeFromCart(cartItem.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Item removed from cart'),
                                  behavior: SnackBarBehavior.floating,
                                  width: 300,
                                  showCloseIcon: true,
                            ));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: Rs.${NumberFormat.decimalPattern('en_US').format(cartProvider.totalPrice)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: cartProvider.clearCart,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.redAccent,
                  ),
                  child: const Row(
                     mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Clear Cart '),
                        Icon(Icons.delete),
                      ]
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cartProvider.cart.isEmpty
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderSummaryScreen(),
                      ),
                    );
                  },
                  child: const Text('Proceed to Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
