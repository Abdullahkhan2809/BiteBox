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
  final TextEditingController _promoCode = TextEditingController();

  @override
  void dispose() {
    _promoCode.dispose();
    super.dispose();
  }

  void _handleDetail(CartProvider cart) {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cart is empty. Add an item first.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: BBColors.redMuted,
        ),
      );
      return;
    }
    Navigator.pushNamed(context, BiteBoxRoutes.UserDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: 'CART'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final subtotal = cart.total;
          final discount = subtotal * 0.1;
          final total = subtotal - discount;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Indicator(current_step: 1),
                const SizedBox(height: 24),

                // ITEMS pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  height: 44,
                  decoration: BoxDecoration(
                    color: BBColors.surface2,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'ITEMS',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: BBColors.red,
                        child: Text(
                          '${cart.itemCount}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cart items or empty state
                if (cart.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Your cart is empty',
                        style: GoogleFonts.poppins(color: BBColors.muted, fontSize: 15),
                      ),
                    ),
                  )
                else
                  ...cart.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CartItem(
                          title: entry.item.name,
                          category: entry.item.tag,
                          quantity: entry.quantity,
                          itemDescription: entry.item.description,
                          price: entry.item.price.toStringAsFixed(2),
                          imageUrl: entry.item.imageUrl,
                          onIncrement: () => cart.increment(entry.item.id),
                          onDecrement: () => cart.decrement(entry.item.id),
                          onDelete: () => cart.removeItem(entry.item.id),
                        ),
                      )),

                const SizedBox(height: 8),

                // Promo code
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: BBColors.surface2,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_outlined, color: Colors.white54, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _promoCode,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Enter promo code',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BBColors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          elevation: 0,
                        ),
                        child: Text('Apply', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order Summary
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: BBColors.surface2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _summaryRow(
                        label: 'Subtotal',
                        value: 'Rs ${subtotal.toStringAsFixed(0)}',
                        valueColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      _summaryRow(
                        label: 'Discount (10%)',
                        value: '- Rs ${discount.toStringAsFixed(0)}',
                        valueColor: BBColors.green,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.white12, thickness: 1),
                      ),
                      _summaryRow(
                        label: 'Total',
                        value: 'Rs ${total.toStringAsFixed(0)}',
                        valueColor: BBColors.red,
                        bold: true,
                        fontSize: 17,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Proceed to Checkout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleDetail(cart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BBColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed to Checkout',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    required Color valueColor,
    bool bold = false,
    double fontSize = 14,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: bold ? Colors.white : BBColors.muted,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
