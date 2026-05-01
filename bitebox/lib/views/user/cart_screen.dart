import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/cartitem.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // void _handleDetail() {
  //   if (CartItem.empty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Cart Empty. Add items.',
  //           style: GoogleFonts.poppins(fontSize: 16),
  //         ),
  //         backgroundColor: BBColors.redMuted,
  //       ),
  //     );
  //   }
  //   Navigator.pushNamed(context, BiteBoxRoutes.UserDetails);
  // }

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "CART"),
      ),

      //body for the cart
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                      'ITEMS',
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
                      '3',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            //add dynamic list of items added to the cart
            const SizedBox(height: 16),
            CartItem(
              title: 'Zinger burger',
              category: 'Meal',
              itemDescription: 'Zinger patty etc',
              price: '450',
            ),
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
              height: 180,
              decoration: BoxDecoration(
                color: BBColors.surface2,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Align(
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
                          'Rs. 1234',
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
                          '- Rs. 1234',
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
                          'Rs. 1234',
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
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed:(){}, //_handleDetail,
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
        // TextField
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

        // Apply Button
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
