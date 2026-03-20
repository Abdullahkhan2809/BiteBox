import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/status_badge.dart';
import 'package:bitebox/views/widgets/payment_badge.dart';
import 'package:flutter/material.dart';


class LiveOrderCard extends StatefulWidget {
  final int orderNumber;
  final String? name;
  final int cms;
  final String items;
  final String paymentType;
  final String status;
  final int price;

  const LiveOrderCard._internal({
    super.key,
    required this.orderNumber,
    required this.name,
    required this.cms,
    required this.items,
    required this.price,
    required this.paymentType,
    required this.status,
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
  }) {
    return LiveOrderCard._internal(
      key: key,
      orderNumber: orderNumber ??
          (DateTime.now().microsecondsSinceEpoch % 10000),
      name: name,
      cms: cms,
      items: items,
      price: price,
      paymentType: paymentType,
      status: status,
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
                      style: const TextStyle(
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
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FF00), // Bright green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),

              // Delete Button (White Circle)
              GestureDetector(
                onTap: () {},
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