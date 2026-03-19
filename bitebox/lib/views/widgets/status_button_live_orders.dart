import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class StatusButtonLiveOrders extends StatelessWidget {
  final int orders;
  final String status;
  final bool isSelected;

  const StatusButtonLiveOrders({super.key , required this.orders,required this.status, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
      width: 120,
      height: 70,
      decoration: BoxDecoration(
        color: isSelected?BBColors.red : BBColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BBColors.red,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orders.toString(),style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
          ),),
          Text(status, style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),)
        ],

      ),
    );
  }
}