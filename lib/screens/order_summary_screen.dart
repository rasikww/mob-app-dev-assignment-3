import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cart[index];
                return ListTile(
                  title: Text(cartItem.product.name),
                  subtitle: Text(
                    'Rs.${NumberFormat.decimalPattern('en_US').format(cartItem.product.price)} x ${cartItem.quantity}',
                  ),
                  trailing: Text(
                    'Rs.${NumberFormat.decimalPattern('en_US').format(cartItem.product.price * cartItem.quantity)}',
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed!'),
                        behavior: SnackBarBehavior.floating,
                        width: 200,
                        showCloseIcon: true,),
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
