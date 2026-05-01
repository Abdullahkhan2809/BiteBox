import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _keyform = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void disposal() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: AppbarWidget(title: 'CHECKOUT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyform,
          child: Column(
            children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 115,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: BBColors.surface2,
                            border: Border.all(color: BBColors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'User Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      //pop to add user Details
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: BBColors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                //state management
                                children: [
                                  Text(
                                    'Name: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Abdullah name statemanagement ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: BBColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                //state management
                                children: [
                                  Text(
                                    'CMSID: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'CMS id statemanagement',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: BBColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: BBColors.surface2,
                            border: Border.all(color: BBColors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.add_card_rounded, color: BBColors.muted),
                                  Spacer(),
                                  Text(
                                    'Payment Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      //pop to add user Details
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: BBColors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: AlignmentGeometry.centerLeft,
                                child: Text(
                                  'payment statemanagement',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: BBColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                        const SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          height: 70,
                          decoration: BoxDecoration(
                            color: BBColors.redTint,
                            border: Border.all(color: BBColors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.watch_later),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimate Delivery Time',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: BBColors.muted,
                                    ),
                                  ),
                                  //statemanagement
                                  Text(
                                    '15-20 minutes',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                //order items Container and convert the singlescroll to list view in statemanagement
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 120,
                    decoration: BoxDecoration(
                      color: BBColors.surface2,
                      border: Border.all(color: BBColors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Orders Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: ListView.separated(
                            itemCount: 6, // replace with your cart list length
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    'Spicy Karachi Biryani',
                                    style: TextStyle(
                                      color: BBColors.muted,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'x2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Rs 700',
                                    style: TextStyle(
                                      color: BBColors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Divider(color: BBColors.border, thickness: 2),
                      Row(
                        children: [
                          Text(
                            'Total Payable',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          // statemanagement for the total calculated payment as per the items
                          Text(
                            'Rs 1,234',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: BBColors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      //text form to send the notes to the retaurant owner
                      _buildTextField(
                        controller: _notesController,
                        label: 'a note for the restaurant',
                        maxLines: 3,
                      ),

                      const SizedBox(height: 16),
                      //button to add the order to the admin Side
                      ElevatedButton(
                        onPressed: () {
                          //add order to the retaurant live orders as new and navgative to popup
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            const Size(double.infinity, 50),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            BBColors.red,
                          ),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          padding: WidgetStateProperty.all(EdgeInsets.all(24)),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, size: 16, color: BBColors.muted),
                          SizedBox(width: 8),
                          Text(
                            'Secure & encrypted transaction',
                            style: TextStyle(color: BBColors.muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

//notes
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
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: '📝 Add ${label.toLowerCase()}...',
          hintStyle: const TextStyle(color: Color(0xFF737373)),
          filled: true,
          fillColor: BBColors.border,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    ],
  );
}
