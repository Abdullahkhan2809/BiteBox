import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menuitemcarduser extends StatelessWidget {
  final String title;
  final String category;
  final String? itemDescription;
  final String? price;
  final String? imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const Menuitemcarduser({
    super.key,
    required this.title,
    required this.category,
    this.itemDescription,
    this.onTap,
    this.price,
    this.imageUrl,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BBColors.surface2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Top row: image + title + description + category badge ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food image or fallback avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallbackAvatar(),
                        )
                      : _fallbackAvatar(),
                ),
                const SizedBox(width: 12),

                // Title + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        itemDescription ?? '',
                        style:  GoogleFonts.poppins(
                          color: BBColors.muted,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: category.toLowerCase() == 'drink'
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style:  GoogleFonts.poppins(
                      color: BBColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Bottom row: price + edit/delete ──
            Row(
              children: [
                Text(
                  price != null ? 'Rs $price' : 'Ask from the canteen',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: BBColors.red,
                  ),
                ),
                const Spacer(),

                // Edit button — only shown if onEdit provided
                if (onEdit != null) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.edit, color: BBColors.bg, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Delete button — only shown if onDelete provided
                if (onDelete != null)
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: BBColors.redMuted,
                    child: IconButton(
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete,
                          color: Colors.white, size: 16),
                    ),
                  ),

                // ✅ Customer-facing: add to cart button (no callbacks = customer view)
                if (onEdit == null && onDelete == null)
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add, color: BBColors.darkRed, size: 28),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: BBColors.darkRed,
      child: Text('B',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}