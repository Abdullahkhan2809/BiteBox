import 'dart:async';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Future<ImageProvider> _loadImage(String assetPath) async {
    final imageProvider = AssetImage(assetPath);

    // Preload image (this actually triggers async loading)
    final completer = Completer<ImageInfo>();
    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (info, _) {
              completer.complete(info);
            },
            onError: (error, stackTrace) {
              completer.completeError(error);
            },
          ),
        );

    await completer.future;
    return imageProvider;
  }

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
            child: FutureBuilder<ImageProvider>(
              future: _loadImage(widget.foodImage),
              builder: (context, snapshot) {
                //loading screen
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                // exception
                if (snapshot.hasError) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                    ),
                  );
                }

                //after loading the picture
                return Image(image: snapshot.data!, fit: BoxFit.cover);
              },
            ),
          ),

          //Text content
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Text(
              widget.itemName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Rating + time 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: BBColors.amber, size: 14),
                const SizedBox(width: 3),
                Text(
                  '${widget.rate} - Time ${widget.timetext} min',
                  style: GoogleFonts.poppins(color: BBColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          //Add to Order button 
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
                label: Text(
                  'See More',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2
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
