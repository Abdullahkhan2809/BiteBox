import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Adduserdetails extends StatefulWidget {
  const Adduserdetails({super.key});

  @override
  State<Adduserdetails> createState() => _AdduserdetailsState();
}

class _AdduserdetailsState extends State<Adduserdetails> {
  final _keyform = GlobalKey<FormState>();
  final _fullname = TextEditingController();
  final _PhoneNumber = TextEditingController();
  final _CMSID = TextEditingController();
  String? _selectedPayment;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.student != null) {
      _fullname.text = auth.student!.name;
      _PhoneNumber.text = auth.student!.phone;
      _CMSID.text = auth.student!.cmsid;
      _selectedPayment = auth.student!.paymentMethod.toLowerCase();
    }
  }

  @override
  void dispose() {
    _fullname.dispose();
    _PhoneNumber.dispose();
    _CMSID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: 'DETAILS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyform,
          child: Column(
            children: [
              const Indicator(current_step: 2),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: BBColors.surface2,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Text(
                          'YOUR DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _fullname,
                        label: 'Full Name',
                        validator: (n) {
                          if (n == null || n.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          String c = n.trim();
                          if (!c.contains(' ')) {
                            return 'Enter first and last name';
                          }
                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(c)) {
                            return 'Only letters and spaces allowed';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _PhoneNumber,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (n) {
                          if (n == null || n.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(n)) {
                            return 'Only numbers are allowed';
                          }
                          if (n.length != 11) {
                            return 'Must be exactly 11 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _CMSID,
                        label: 'CMS-ID',
                        keyboardType: TextInputType.number,
                        validator: (c) {
                          if (c == null || c.isEmpty) {
                            return 'CMS-ID is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(c)) {
                            return 'Only numbers are allowed';
                          }
                          if (c.length != 6) {
                            return 'Must be exactly 6 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: BBColors.surface2,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Text(
                          'PAYMENT METHOD',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                          value: _selectedPayment,
                          decoration: InputDecoration(
                          filled: true,
                          fillColor: BBColors.border,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),
                        dropdownColor: BBColors.surface2,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        icon: const Icon(Icons.keyboard_arrow_down, color: BBColors.muted),
                        items: const [
                          DropdownMenuItem(
                            value: 'cash',
                            child: Row(
                              children: [
                                Icon(Icons.payments_outlined, color: BBColors.green, size: 20),
                                SizedBox(width: 10),
                                Text('Cash'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'tab',
                            child: Row(
                              children: [
                                Icon(Icons.credit_card, color: BBColors.amber, size: 20),
                                SizedBox(width: 10),
                                Text('Tab (Credit)'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedPayment = value);
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: BBColors.surface2,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                            final subtotal = cartProvider.total;
                            final discount = 0.0;
                            final total = subtotal - discount;
                            return Column(
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
                                      'Rs. ${subtotal.toStringAsFixed(0)}',
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
                                      '- Rs. ${discount.toStringAsFixed(0)}',
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
                                      'Rs. ${total.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 255, 18, 18),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_keyform.currentState!.validate()) {
                            context.read<AuthProvider>().updateStudentDetails(
                              name: _fullname.text,
                              phone: _PhoneNumber.text,
                              cmsid: _CMSID.text,
                              paymentMethod: _selectedPayment ?? 'cash',
                            );
                            Navigator.pushNamed(context, BiteBoxRoutes.checkout);
                          }
                        },
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardType,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: BBColors.muted,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter ${label.toLowerCase()}...',
          hintStyle: const TextStyle(color: Color(0xFF737373)),
          filled: true,
          fillColor: BBColors.border,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    ],
  );
}