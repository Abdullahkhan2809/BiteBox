import 'dart:io';

import 'package:bitebox/views/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'dart:ui';
class AddmenuItems extends StatefulWidget {
  const AddmenuItems({super.key});

  @override
  State<AddmenuItems> createState() => _AddmenuItemsState();
}

class _AddmenuItemsState extends State<AddmenuItems> {
  String? selected='Meal';
  int _activeNav=0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'ADD ITEM',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      //container to add the items

      body:Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Card(
                elevation: 4,
                color: BBColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: BBColors.hinttext,width: 1.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Left align labels
                    children: [
                      const Center(
                        child: Text(
                          'Add New Item',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      
                      const LabelText('Name Item'),
                      const RoundedTextField(hintText: 'Item name...'),

                      const LabelText('Item Category'),
                      RoundedDropdownField(
                        value: selected,
                        onChanged: (newValue) {
                          setState(() {
                            selected = newValue;
                          });
                        },
                      ),

                      const LabelText('Price'),
                      const RoundedTextField(hintText: 'Enter price...', keyboardType: TextInputType.number),

                      const LabelText('Item Icon'),
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement Image Picker
                        },
                        child: CustomPaint(
                          foregroundPainter: DashedBorderPainter(color: Colors.grey),
                          child: Container(
                            width: 130,
                            height: 130,
                            color: Colors.transparent, // Required to make it tapped
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Item',
                                  style: TextStyle(color: BBColors.hinttext, fontSize: 13),
                                ),
                                Text(
                                  'Picture',
                                  style: TextStyle(color: BBColors.hinttext, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons: Cancel and Save
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 97,
                            height: 40,
                            child: ElevatedButton(
                              
                              onPressed: () {
                              },
                              style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.grey[200],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            height: 40,
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Handle 40ve Item
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BBColors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

     bottomNavigationBar: BBBottomNavBar(
        activeIndex: _activeNav,
        onTap: (i) => setState(() => _activeNav = i),
      ),
      floatingActionButton: FloatingActionButton(onPressed: 
      (){

      },
      backgroundColor: BBColors.darkRed,
    shape: const CircleBorder(),
    elevation: 4,
    child: const Icon(Icons.close, color: Colors.white, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
    );
  }
}

// Reusable rounded input field widget
class RoundedTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;

  const RoundedTextField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: BBColors.hinttext),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none, // Removes default underline
        ),
      ),
    );
  }
}

// Reusable rounded dropdown widget
class RoundedDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const RoundedDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: BBColors.red,
          borderRadius: BorderRadius.circular(30),
          isExpanded: true, // Takes up full rounded container width
          hint: Text('Choose category...', style: TextStyle(color: BBColors.hinttext)),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 0, 0, 0)),
          items: [
            DropdownMenuItem(value: 'Meal', child: Text('Meal')),
            DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
            DropdownMenuItem(value: 'Drink', child: Text('Drink')),
          ],
        ),
      ),
    );
  }
}

// Simple Painter for the dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.5,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(15)));

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashWidth < metric.length - distance ? dashWidth : metric.length - distance;
        final Path dash = metric.extractPath(distance, distance + length);
        canvas.drawPath(dash, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LabelText extends StatelessWidget {
  final String text;
  const LabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}