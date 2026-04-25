import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(74), child: AppbarWidget(title: 'About BiteBox')),
      body: Padding(padding: EdgeInsets.all(16),
      child: Card(
        color: BBColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
        shadowColor:BBColors.red,
        elevation: 5,
        child: Padding(padding: EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                  Icon(Icons.fastfood, color: BBColors.redMuted, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      "BiteBox",
                      style: GoogleFonts.oswald(
                        fontSize: 30,
                      )
                    ),
                ],
              ),
              const Divider(height: 30),
              Text(
                  "BiteBox is a smart canteen management solution designed specifically for university students and staff.",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 15),
                 Text(
                  "Our Mission",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 Text(
                  "We aim to eliminate long queues and simplify payments. With our unique 'Lazy Auth' system, students can order instantly using their CMS ID and manage their campus 'Tabs' effortlessly.",
                  style: GoogleFonts.poppins(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 15),
                _buildFeatureRow(Icons.bolt, "Instant CMS Login"),
                _buildFeatureRow(Icons.account_balance_wallet, "Digital Tab System"),
                _buildFeatureRow(Icons.timer, "Real-time Order Tracking"),
                const SizedBox(height: 20),
                 Center(
                  child: Text(
                    "v1.0.0 • Developed for Campus Efficiency",
                    style: GoogleFonts.koulen(fontSize: 12, color: Colors.grey),
                  ),
                )
          ],
        ),
        ),
      ),),
    );
  }
}

Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: BBColors.red),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }
