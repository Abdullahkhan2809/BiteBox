import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem extends StatefulWidget {
  final String title;
  final String category;
  final String? itemDescription;
  final String? price;
  final String? imageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDelete;
  final VoidCallback onDecrement;

  const CartItem({
    super.key,
    required this.title,
    required this.quantity,
    required this.category,
    required this.itemDescription,
    required this.price,
    required this.onIncrement,
    required this.onDelete,
    required this.onDecrement,
    this.imageUrl,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BBColors.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.itemDescription ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF9E9E9E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.category.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: BBColors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                widget.price != null ? 'Rs ${widget.price}' : 'Ask canteen',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: BBColors.red,
                ),
              ),
              const SizedBox(width: 16),
              _circleButton(
                onTap: widget.onDecrement,
                icon: Icons.remove,
                bgColor: Colors.white,
                iconColor: BBColors.red,
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.quantity}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              _circleButton(
                onTap: widget.onIncrement,
                icon: Icons.add,
                bgColor: BBColors.red,
                iconColor: Colors.white,
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onDelete,
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF9E9E9E),
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: BBColors.darkRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.fastfood_rounded, color: Colors.white54, size: 28),
    );
  }

  Widget _circleButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
