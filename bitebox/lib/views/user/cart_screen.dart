import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/cartitem.dart';
import 'package:bitebox/views/widgets/indicator.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController _PromoCode = TextEditingController();
  @override
  void dispose() {
    _PromoCode.dispose();
    super.dispose();
  }

  void _handleDetail(CartProvider cart) {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cart Empty. Add item.',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          backgroundColor: BBColors.redMuted,
        ),
      );
    }
    Navigator.pushNamed(context, BiteBoxRoutes.UserDetails);
  }

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "CART"),
      ),

      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Indicator(current_step: 1),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: BBColors.surface2,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Align(
                        widthFactor: 1.4,
                        child: Text(
                          'item',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: BBColors.red,
                        child: Text(
                          '${cart.itemCount}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (cart.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Your cart is empty',
                      style: GoogleFonts.poppins(color: BBColors.muted),
                    ),
                  )
                else
                  ...cart.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CartItem(
                        title: entry.item.name,
                        category: entry.item.tag,
                        quantity: entry.quantity,
                        itemDescription: entry.item.description,
                        price: entry.item.price.toStringAsFixed(0),
                        onIncrement: () => cart.increment(entry.item.id),
                        onDecrement: () => cart.decrement(entry.item.id),
                        onDelete: () => cart.removeItem(entry.item.id),
                      ),
                    );
                  }).toList(),

                const SizedBox(height: 16),

                _PromoCodeTextField(
                  controller: _PromoCode,
                  onApply: () {
                    print(_PromoCode.text);
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: BBColors.surface2,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 15,
                              color: BBColors.hintText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Rs. ${cart.total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 15,
                              color: BBColors.hintText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '- Rs. 0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: BBColors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Rs. ${cart.total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 18, 18),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => _handleDetail(cart),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(BBColors.red),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    padding: WidgetStateProperty.all(EdgeInsets.all(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _PromoCodeTextField({
  required TextEditingController controller,
  required VoidCallback onApply,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: BBColors.surface2,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white24, width: 2),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.label),
        const SizedBox(width: 6),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter promo code",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: BBColors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text("Apply", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}