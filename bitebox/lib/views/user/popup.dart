import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderConfirmationPopup extends StatelessWidget {
  final String? customerName;
  final String? cmsId;
  final List<Map<String, dynamic>>? items;
  final double? totalAmount;
  final String? paymentMethod;

  const OrderConfirmationPopup({
    super.key,
    this.customerName,
    this.cmsId,
    this.items,
    this.totalAmount,
    this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        final order = orderProvider.placedOrder;
        final displayCmsId = cmsId ?? order?.studentId ?? 'N/A';
        final displayItems = items ?? (order?.item?.map((item) => {
          'name': item.name,
          'quantity': item.quantity ?? 1,
          'price': item.priceAtpurchase.toStringAsFixed(0),
        }).toList() ?? []);
        final displayTotal = totalAmount ?? (order?.totalAmount ?? 0);
        final displayPayment = paymentMethod ?? order?.paymentMethod ?? 'cash';
        final displayOrderId = order?.id ?? 'BB-${Random().nextInt(90000) + 10000}';

        return Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BBColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.green, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text('Order placed!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Your order is being prepared',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                  const SizedBox(height: 20),
                  _InfoCard(
                    children: [
                      _InfoRow(label: 'Order ID', value: displayOrderId, mono: true),
                      _InfoRow(label: 'CMS ID', value: displayCmsId, mono: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('Items ordered',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500)),
                      ),
                      ...displayItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name'] ?? 'Item',
                                style: const TextStyle(fontSize: 13)),
                            Text(
                              'x${item['quantity']}   Rs. ${item['price']}',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Rs. ${displayTotal.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green.shade600),
                      const SizedBox(width: 6),
                      Text(
                        'Paid via ${displayPayment == 'tab' ? 'Online' : 'Cash'}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, BiteBoxRoutes.home, (route) => false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BBColors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Done',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BBColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  const _InfoRow(
      {required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: mono ? 'monospace' : null,
              )),
        ],
      ),
    );
  }
}