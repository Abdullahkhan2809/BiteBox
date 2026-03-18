// views/widgets/stat_card.dart
// Place this file at: lib/views/widgets/stat_card.dart

import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/colors.dart';

/// Stat card — Revenue / Orders / etc.
/// Matches the two cards in the Figma admin dashboard header.
class BBStatCard extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;
  final String   label;
  final String   value;
  final String   change;
  final bool     changeUp;

  const BBStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.change,
    this.changeUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = changeUp ? BBColors.green : BBColors.red;
    final trendIcon  = changeUp
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BBColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: BBColors.muted,
                    letterSpacing: 0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Trend
          Row(
            children: [
              Icon(trendIcon, size: 12, color: trendColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  change,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: trendColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
