import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Adduserdetails extends StatefulWidget {
  const Adduserdetails({super.key});

  @override
  State<Adduserdetails> createState() => _AdduserdetailsState();
}

class _AdduserdetailsState extends State<Adduserdetails> {
  final _keyform = GlobalKey<FormState>();
  final _fullname = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _cmsId = TextEditingController();
  String? _selectedPayment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.student != null) {
      _fullname.text = auth.student!.name;
      _phoneNumber.text = auth.student!.phone;
      _cmsId.text = auth.student!.cmsid;
      _selectedPayment = auth.student!.paymentMethod.toLowerCase();
    }
  }

  @override
  void dispose() {
    _fullname.dispose();
    _phoneNumber.dispose();
    _cmsId.dispose();
    super.dispose();
  }

  Future<void> _onConfirmOrder() async {
    if (!_keyform.currentState!.validate()) return;
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a payment method', style: GoogleFonts.poppins()),
          backgroundColor: BBColors.redMuted,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _placeOrder();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: $e', style: GoogleFonts.poppins()),
            backgroundColor: BBColors.redMuted,
          ),
        );
      }
    }
  }

  Future<void> _placeOrder() async {

    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    // Step 1: Authenticate → get JWT token
    final loginSuccess = await authProvider.Studentlogin(
      cmsId: _cmsId.text,
      name: _fullname.text,
      phone: _phoneNumber.text,
      category: authProvider.student?.category ?? 'student',
      paymentMethod: _selectedPayment!,
    );

    if (!mounted) return;

    if (!loginSuccess) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Authentication failed. Check CMS-ID.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: BBColors.redMuted,
        ),
      );
      return;
    }

    // Step 2: Place order (token is now saved in Hive)
    final restaurantId = cartProvider.restaurantId ?? '';
    final orderSuccess = await orderProvider.placeOrder(
      studentName: _fullname.text,
      studentId: _cmsId.text,
      restaurantId: restaurantId,
      cartProvider: cartProvider,
      paymentMethod: _selectedPayment!,
    );

    if (!mounted) return;

    if (orderSuccess) {
      Navigator.pushNamed(context, BiteBoxRoutes.checkout);
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderProvider.errorMessage ?? 'Failed to place order. Try again.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: BBColors.redMuted,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: 'DETAILS'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final subtotal = cartProvider.total;
          final discount = subtotal * 0.1;
          const deliveryFee = 99.0;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Form(
              key: _keyform,
              child: Column(
                children: [
                  const Indicator(current_step: 2),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // YOUR DETAILS header
                          _sectionHeader('YOUR DETAILS'),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _fullname,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            validator: (n) {
                              if (n == null || n.trim().isEmpty) return 'Full name is required';
                              if (!n.trim().contains(' ')) return 'Enter first and last name';
                              if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(n.trim())) {
                                return 'Only letters and spaces allowed';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _phoneNumber,
                            label: 'Phone Number',
                            hint: '+92 300 0000000',
                            keyboardType: TextInputType.phone,
                            validator: (n) {
                              if (n == null || n.isEmpty) return 'Phone number is required';
                              if (!RegExp(r'^[0-9]+$').hasMatch(n)) return 'Only numbers allowed';
                              if (n.length != 11) return 'Must be exactly 11 digits';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _cmsId,
                            label: 'Cms-ID',
                            hint: '123456',
                            keyboardType: TextInputType.number,
                            validator: (c) {
                              if (c == null || c.isEmpty) return 'CMS-ID is required';
                              if (!RegExp(r'^[0-9]+$').hasMatch(c)) return 'Only numbers allowed';
                              if (c.length != 6) return 'Must be exactly 6 digits';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // PAYMENT METHOD header
                          _sectionHeader('PAYMENT METHOD'),
                          const SizedBox(height: 16),

                          // Payment method cards
                          Row(
                            children: [
                              Expanded(
                                child: _paymentCard(
                                  value: 'cash',
                                  title: 'Cash on Delivery',
                                  subtitle: 'Pay when order arrives',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _paymentCard(
                                  value: 'tab',
                                  title: 'Online Payment',
                                  subtitle: 'Card / JazzCash / EasyPaisa',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

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
                                _summaryRow('Subtotal', 'Rs ${subtotal.toStringAsFixed(0)}', Colors.white),
                                const SizedBox(height: 10),
                                _summaryRow('Delivery Fee', 'Rs ${deliveryFee.toStringAsFixed(0)}', Colors.white),
                                const SizedBox(height: 10),
                                _summaryRow(
                                  'Discount (10%)',
                                  '- Rs ${discount.toStringAsFixed(0)}',
                                  BBColors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Confirm & Place Order button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onConfirmOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading ? BBColors.muted : BBColors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Confirm & Place Order',
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
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: BBColors.surface2,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _paymentCard({
    required String value,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BBColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? BBColors.red : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? BBColors.red : Colors.white38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BBColors.red,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: BBColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: BBColors.muted),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  String? hint,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: BBColors.muted,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint ?? 'Enter ${label.toLowerCase()}',
          hintStyle: const TextStyle(color: Color(0xFF737373)),
          filled: true,
          fillColor: BBColors.border,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: BBColors.red, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    ],
  );
}
