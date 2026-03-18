import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/colors.dart';

enum OrderStatus {
  pending(
    label: 'Pending',
    color: Color(0xFFFFB800),
    bgColor: Color(0x26FFB800),
  ),
  cooking(
    label: 'Cooking',
    color: Color(0xFFFF8C00),
    bgColor: Color(0x26FF8C00),
  ),
  ready(
    label: 'Ready',
    color: BBColors.green,
    bgColor: Color(0x2630D158),
  );

  const OrderStatus({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final Color color;
  final Color bgColor;
}

/// Live order card for dashboard.
/// Matches Figma admin "Live Orders" section.
class BBOrderCard extends StatelessWidget {
  final String orderNum;
  final String customerName;
  final String items;
  final OrderStatus status;
  final String time;

  const BBOrderCard({
    super.key,
    required this.orderNum,
    required this.customerName,
    required this.items,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BBColors.border),
      ),
      child: Row(
        children: [
          // Order avatar / number
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                orderNum,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: status.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  items,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: BBColors.muted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: status.color,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Time
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: BBColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
