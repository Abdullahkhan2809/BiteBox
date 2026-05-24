import 'package:bitebox/core/routes.dart';
import 'package:bitebox/core/toast.dart';
import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/services/image_service.dart';
import 'package:bitebox/services/menu_service.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AddmenuItems extends StatefulWidget {
  final MenuItem? existingItem;

  const AddmenuItems({super.key, this.existingItem});
  @override
  State<AddmenuItems> createState() => _AddmenuItemsState();
}

class _AddmenuItemsState extends State<AddmenuItems> {
  String? selected = 'Fast Food';
  String? _imageUrl;
  bool _isUploading = false;

  final ImageService _imageService = ImageService();
  final MenuService _menuService = MenuService();
  final _formkey = GlobalKey<FormState>();

  //controller
  late final TextEditingController _namecontorller;
  late final TextEditingController _pricecontroller;
  late final TextEditingController _descriptioncontorller;

  bool _isloading = false;

  //for edit and add
  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    _namecontorller = TextEditingController(
      text: widget.existingItem?.name ?? '',);
    _pricecontroller = TextEditingController(
      text: widget.existingItem?.price.toStringAsFixed(0) ?? '',);
    _descriptioncontorller = TextEditingController(
      text: widget.existingItem?.description ?? '',);
    selected = widget.existingItem?.tag ?? 'Fast Food';
    _imageUrl = widget.existingItem?.imageUrl.isNotEmpty == true
        ? widget.existingItem!.imageUrl
        : null;
  }

  Future<void> _pickAndUpload() async {
    final file = await _imageService.pickImage();
    if (file == null) return;
    setState(() => _isUploading = true);
    final result = await _imageService.uploadImage(file);
    if (result['success']) {
      setState(() => _imageUrl = result['image_url'] as String);
    } else {
      if (mounted) {
        BBToast.showToast(context, result['message'] ?? 'Upload failed');
      }
    }
    setState(() => _isUploading = false);
  }

  @override
  void dispose() {
    _namecontorller.dispose();
    _pricecontroller.dispose();
    _descriptioncontorller.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formkey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    if (auth.restaurantId == null) {
      BBToast.showToast(context, 'Restaurant not found');
      return;
    }

    setState(() => _isloading = true);

    Map<String, dynamic> result;

    if (isEditing) {
      result = await _menuService.updateMenuItem(
        itemId: widget.existingItem!.id,
        restaurantId: auth.restaurantId!,
        name: _namecontorller.text.trim(),
        description: _descriptioncontorller.text.trim(),
        price: double.parse(_pricecontroller.text.trim()),
        imageUrl: _imageUrl,
      );
    } else {
      result = await _menuService.addMenuItem(
        restaurantId: auth.restaurantId!,
        name: _namecontorller.text.trim(),
        description: _descriptioncontorller.text.trim(),
        price: double.parse(_pricecontroller.text.trim()),
        tag: selected ?? 'Fast Food',
        imageUrl: _imageUrl ?? '',
      );
    }

    if (mounted) {
      if (result['success']) {
        BBToast.showToast(context, isEditing ? 'Item updated!' : 'Item added!');
        // go back to menu tab
        Navigator.pushReplacementNamed(
          context,
          BiteBoxRoutes.adminRoot,
          arguments: 1, // 1 = menu tab index
        );
      } else {
        BBToast.showToast(context, result['message'] ?? 'Failed to save');
      }
    }

    setState(() => _isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Add Menu"),
      ),

      //container to add the items
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: _formkey,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Card(
                  elevation: 4,
                  color: BBColors.surface2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: BBColors.hintText, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isEditing ? 'Edit Item' : 'Add New Item',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        const LabelText('Name Item'),
                        RoundedTextField(
                          controller: _namecontorller,
                          hintText: 'Item name...',
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),

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
                        RoundedTextField(
                          controller: _pricecontroller,
                          hintText: 'Enter price...',
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),

                        const LabelText('Description'),
                        RoundedTextField(
                          controller: _descriptioncontorller,
                          hintText: 'Description',
                          maxLines: 3,
                        ),
                        const LabelText('Item Icon'),
                        GestureDetector(
                          onTap: _isUploading ? null : _pickAndUpload,
                          child: CustomPaint(
                            foregroundPainter: DashedBorderPainter(
                              color: Colors.grey,
                            ),
                            child: Container(
                              width: 130,
                              height: 130,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: _isUploading
                                  ? const CircularProgressIndicator(
                                      color: BBColors.red,
                                      strokeWidth: 2,
                                    )
                                  : _imageUrl != null
                                  ? Image.network(
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                      width: 130,
                                      height: 130,
                                      errorBuilder: (ctx, e, stack) =>
                                          const Icon(
                                            Icons.broken_image,
                                            color: BBColors.hintText,
                                            size: 40,
                                          ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_a_photo,
                                          color: BBColors.hintText,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Tap to upload',
                                          style: TextStyle(
                                            color: BBColors.hintText,
                                            fontSize: 12,
                                          ),
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
                                  Navigator.pushReplacementNamed(
                                    context,
                                    BiteBoxRoutes.adminRoot,
                                    arguments: 1,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BBColors.surface,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              height: 40,
                              width: 90,
                              child: ElevatedButton(
                                onPressed: _isloading ? null : _saveItem,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BBColors.red,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: _isloading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Save',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

// Reusable rounded input field widget
class RoundedTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final TextEditingController? controller; // ← added
  final String? Function(String?)? validator; // ← added

  const RoundedTextField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: BBColors.hintText),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: BBColors.red,
          borderRadius: BorderRadius.circular(10),
          isExpanded: true, // Takes up full rounded container width
          hint: Text(
            'Choose category...',
            style: TextStyle(color: BBColors.hintText),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          items: [
            DropdownMenuItem(value: 'Fast Food', child: Text('Fast Food')),
            DropdownMenuItem(value: 'Beverages', child: Text('Beverages')),
            DropdownMenuItem(value: 'Desserts', child: Text('Desserts')),
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
  final VoidCallback? addpicture;
  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.5,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.addpicture,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(15),
        ),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashWidth < metric.length - distance
            ? dashWidth
            : metric.length - distance;
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
