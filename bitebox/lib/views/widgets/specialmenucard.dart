import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Specialmenucard extends StatefulWidget {
  final String foodImage;
  final String itemName;
  final double rate;
  final int timetext;

  const Specialmenucard({
    super.key,
    required this.foodImage,
    required this.itemName,
    required this.rate,
    required this.timetext,
  });

  @override
  State<Specialmenucard> createState() => _SpecialmenucardState();
}

class _SpecialmenucardState extends State<Specialmenucard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
      width: 200,
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Food image (fills full width, fixed height) ──────────────────
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Image.network(
              widget.foodImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: BBColors.surface2,
                child: const Icon(Icons.image_not_supported, color: BBColors.hintText),
              ),
            ),
          ),

          // ── Text content ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Text(
              widget.itemName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Rating + time ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: BBColors.amber, size: 14),
                const SizedBox(width: 3),
                Text(
                  '${widget.rate} - Time ${widget.timetext} min',
                  style: const TextStyle(
                    color: BBColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Add to Order button ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: BBColors.redMuted),
                  backgroundColor: BBColors.redTint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 14),
                label: const Text(
                  'Add to Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}