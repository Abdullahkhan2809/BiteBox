import 'dart:math';

import 'package:bitebox/models/order_model.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/status_badge.dart';
import 'package:bitebox/views/widgets/payment_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class LiveOrderCard extends StatefulWidget {
  final int orderNumber;
  final String? name;
  final int cms;
  final String items;
  final String paymentType;
  final String status;
  final int price;
  final VoidCallback? onAccept;
  final Order order;

  const LiveOrderCard._internal({
    super.key,
    required this.orderNumber,
    required this.name,
    required this.cms,
    required this.items,
    required this.price,
    required this.paymentType,
    required this.status, 
    required this.order,
    this.onAccept,
  });

  factory LiveOrderCard({
    Key? key,
    int? orderNumber,
    required String? name,
    required int cms,
    required String items,
    required int price,
    required String paymentType,
    required String status, 
    required Order order,
     VoidCallback? onAccept,
  }) {
    return LiveOrderCard._internal(
      key: key,
      orderNumber: orderNumber ??
          Random().nextInt(9000)+1000,
      name: name,
      cms: cms,
      items: items,
      price: price,
      paymentType: paymentType,
      status: status,
      order: order,
      onAccept: onAccept,
    );
  }

  @override
  State<LiveOrderCard> createState() => _LiveOrderCardState();
}

class _LiveOrderCardState extends State<LiveOrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16), // Slightly more padding for the clean look
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Darker background as per target
        borderRadius: BorderRadius.circular(24), // Smoother corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${widget.orderNumber}',
                      style: GoogleFonts.koulen(
                        color: Colors.white,
                        fontSize: 22, // Increased font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.name} (CMS : ${widget.cms})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: widget.status),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.white, thickness: 1), // Brighter divider
          ),

          /// Items + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.items.toUpperCase(), // Match the uppercase look
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rs ${widget.price}",
                style: const TextStyle(
                  color: BBColors.red, // Price is red in target
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// Bottom Row
          Row(
            children: [
              PaymentBadge(payStatus: widget.paymentType),
              const Spacer(),

              // Accept Button (Green Circle)
              GestureDetector(
                onTap: widget.onAccept != null
                    ? () {
                        // Optimistically trigger the callback
                        widget.onAccept!();
                        
                        // Provide immediate visual feedback if needed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Updating order status...'),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: BBColors.green, // Bright green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),

              // Delete Button (White Circle)
              GestureDetector(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cancel Order'),
                      content: const Text('Are you sure you want to cancel this order?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && mounted) {
                    final success = await context.read<OrderProvider>().advanceOrderStatus(
                      orderId: widget.order.id!,
                      currentStatus: 'ready', // Forcing 'completed' status as a way to clear from live view
                    );
                    
                    if (mounted && !success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to cancel order'),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}