 import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

 class PaymentBadge extends StatelessWidget {
  final String payStatus;
  const PaymentBadge({super.key ,required this.payStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: BBColors.red,
        borderRadius: BorderRadius.circular(20),
         boxShadow:[
          BoxShadow(
            color:Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          )
        ]
      ),
      child: Text(
        payStatus,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}