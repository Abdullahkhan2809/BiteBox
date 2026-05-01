import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackFooter extends StatelessWidget {
  const FeedbackFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
         Navigator.pushNamed(context,BiteBoxRoutes.feedback);
        },
        child: Container(
          height: 120,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BBColors.surface2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BiteBox FeedBack',
                    style: GoogleFonts.koulen(letterSpacing: 1.2, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.mail, color: BBColors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'example@gmail.com',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: BBColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.call, color: BBColors.redMuted, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '0336-2725641',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: BBColors.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
