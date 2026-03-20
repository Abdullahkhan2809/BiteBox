import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class StatusButtonLiveOrders extends StatelessWidget {
  final int orders;
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusButtonLiveOrders({
    super.key,
    required this.orders,
    required this.status,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 110,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? BBColors.red : BBColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BBColors.red),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: BBColors.red.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(orders.toString()),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}