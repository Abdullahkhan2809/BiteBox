import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color getBaseColor() {
    switch (status.toUpperCase()) {
      case "NEW":
        return const Color(0xFFFF0000); // Solid Red
      case "COOKING":
        return const Color.fromARGB(255, 148, 148, 148); // Solid Purple/Blue
      case "READY":
        return Colors.black;            // Solid Black
      default:
        return Colors.grey;
    }
  }

  Color getTextColor() {
    switch (status.toUpperCase()) {
      case "NEW":
      case "COOKING":
        return Colors.white;
      case "READY":
        return const Color(0xFF00FF08); // Green text for Ready
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // The padding keeps the container wide and pill-shaped
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical:2),
      decoration: BoxDecoration(
        color: getBaseColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow:[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8), // Dark shadow color
        blurRadius: 10,                            // Soft, realistic shadow
        offset: const Offset(0, 4),                // Y-4: Pushes shadow from the top
        spreadRadius: -4,
          )
        ]
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          color: getTextColor(),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}