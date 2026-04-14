import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/bottomnavigationbar.dart';
import 'package:bitebox/views/widgets/live_order_card.dart';
import 'package:bitebox/views/widgets/stat_card.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/status_button_live_orders.dart';
import 'package:flutter/material.dart';


class AdminLiveOrder extends StatefulWidget {
  const AdminLiveOrder({super.key});

  @override
  State<AdminLiveOrder> createState() => _AdminLiveOrderState();
}

enum OrderStatus { pending, ready, served }

class _AdminLiveOrderState extends State<AdminLiveOrder> {
  int _activeNav=0;
  OrderStatus selectedStatus = OrderStatus.pending;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: "AdminLiveOrder")),


      //body 
      body:SafeArea(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ── FIXED TOP SECTION ──
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // stats cards
            Row(
              children: [
                Expanded(
                  child: BBStatCard(icon: Icons.payments_outlined, iconColor: BBColors.red, iconBg: const Color(0x26E51904), label: 'Revenue', value: r'$1,243', change: r'20%'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BBStatCard(icon: Icons.shopping_bag_outlined, iconColor: BBColors.red, iconBg: const Color(0x26E51904), label: 'Sales', value: r'123', change: r'20%'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // status buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusButtonLiveOrders(orders: 12, status: 'Pending', isSelected: selectedStatus == OrderStatus.pending, onTap: () => setState(() => selectedStatus = OrderStatus.pending)),
                StatusButtonLiveOrders(orders: 3, status: 'Ready', isSelected: selectedStatus == OrderStatus.ready, onTap: () => setState(() => selectedStatus = OrderStatus.ready)),
                StatusButtonLiveOrders(orders: 40, status: 'Served', isSelected: selectedStatus == OrderStatus.served, onTap: () => setState(() => selectedStatus = OrderStatus.served)),
              ],
            ),
            const SizedBox(height: 12),
            // order header
            Row(
              children: [
                const Text('LIVE ORDERS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: 105,
                  height: 25,
                  decoration: BoxDecoration(color: BBColors.redMuted, borderRadius: BorderRadius.circular(20)),
                  child: const Text('8 ACTIVE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 255, 8, 0))),
                ),
              ],
            ),
          ],
        ),
      ),

      // ── SCROLLABLE CARDS ──
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3, 
          itemBuilder: (context, index) {
            final orders = [
              {'name': 'Abdullah Khan', 'cms': 514779, 'items': '1x pizza', 'price': 350, 'paymentType': 'Cash', 'status': 'NEW'},
              {'name': 'Abdullah Khan', 'cms': 514779, 'items': '1x pizza', 'price': 350, 'paymentType': 'Online Payment', 'status': 'COOKING'},
              {'name': 'Abdullah Khan', 'cms': 514779, 'items': '1x pizza', 'price': 350, 'paymentType': 'Cash', 'status': 'READY'},
            ];
            final o = orders[index];
            return LiveOrderCard(
              name: o['name'] as String,
              cms: o['cms'] as int,
              items: o['items'] as String,
              price: o['price'] as int,
              paymentType: o['paymentType'] as String,
              status: o['status'] as String,
            );
          },
        ),
      ),
    ],
  ),
),
      bottomNavigationBar: BBBottomNavBar(
        activeIndex: _activeNav,
        onTap: (i) => setState(() => _activeNav = i),
      ),
      floatingActionButton: FloatingActionButton(onPressed: 
      (){

      },
      backgroundColor: BBColors.red,
    shape: const CircleBorder(),
    elevation: 4,
    child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}