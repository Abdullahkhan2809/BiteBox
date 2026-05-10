
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/live_order_card.dart';
import 'package:bitebox/views/widgets/stat_card.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/status_button_live_orders.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLiveOrder extends StatefulWidget {
  const AdminLiveOrder({super.key});

  @override
  State<AdminLiveOrder> createState() => _AdminLiveOrderState();
}

enum LiveOrderTab { pending, ready, served }

class _AdminLiveOrderState extends State<AdminLiveOrder> {
  LiveOrderTab _selectedTab = LiveOrderTab.pending;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrders();
    });
  }

  void _fetchOrders() {
    final auth = context.read<AuthProvider>();
    if (auth.restaurantId != null) {
      context.read<OrderProvider>().fetchOrders(
            restaurantId: auth.restaurantId!,
            status: _statusToString(_selectedTab),
          );
    }
  }

  String _statusToString(LiveOrderTab status) {
    switch (status) {
      case LiveOrderTab.pending: return 'pending';
      case LiveOrderTab.ready: return 'ready';
      case LiveOrderTab.served: return 'completed';
    }
  }

  //calls when staff taps accept button on the card
  Future<void> _advanceStatus(
    String orderId,
    String currentStatus,
  ) async {
    final success = await context.read<OrderProvider>().advanceOrderStatus(
          orderId: orderId,
          currentStatus: currentStatus,
        );

    if (success) {
       _fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "AdminLiveOrder"),
      ),

      //body
      body: SafeArea(
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
                   Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  final orderCount = orderProvider.orders.length;

                  return Row(
                    children: [
                      Expanded(
                        child: BBStatCard(
                          icon: Icons.payments_outlined,
                          iconColor: BBColors.red,
                          iconBg: const Color(0x26E51904),
                          label: 'Revenue',
                          // Phase 6: replace with real revenue from analytics API
                          value: 'Rs 0',
                          change: 'Live',
                          changeUp: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BBStatCard(
                          icon: Icons.shopping_bag_outlined,
                          iconColor: BBColors.amber,
                          iconBg: const Color(0x20EF9F27),
                          label: 'Orders',
                          value: '$orderCount',   // ← real order count
                          change: _statusToString(_selectedTab),
                          changeUp: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
                  const SizedBox(height: 12),
                  // status buttons
                  Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusButtonLiveOrders(
                            orders:     orderProvider.orders
                                .where((o) => o.status == 'pending')
                                .length,
                            status:     'Pending',
                            isSelected: _selectedTab == LiveOrderTab.pending,
                            onTap: () {
                              setState(() => _selectedTab = LiveOrderTab.pending);
                              _fetchOrders();
                            },
                          ),
                          StatusButtonLiveOrders(
                            orders:     orderProvider.orders
                                .where((o) => o.status == 'ready')
                                .length,
                            status:     'Ready',
                            isSelected: _selectedTab == LiveOrderTab.ready,
                            onTap: () {
                              setState(() => _selectedTab = LiveOrderTab.ready);
                              _fetchOrders();
                            },
                          ),
                          StatusButtonLiveOrders(
                            orders:     orderProvider.orders
                                .where((o) => o.status == 'completed')
                                .length,
                            status:     'Served',
                            isSelected: _selectedTab == LiveOrderTab.served,
                            onTap: () {
                              setState(() => _selectedTab = LiveOrderTab.served);
                              _fetchOrders();
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  // order header
                   Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return Row(
                        children: [
                          const Text(
                            'LIVE ORDERS',
                            style: TextStyle(
                              fontSize:   16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.center,
                            width:  120,
                            height: 25,
                            decoration: BoxDecoration(
                              color:        BBColors.redMuted,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              // ← real active count
                              '${orderProvider.orders.length} ACTIVE',
                              style: GoogleFonts.poppins(
                                fontSize:   14,
                                fontWeight: FontWeight.w500,
                                color:      Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── SCROLLABLE CARDS ──
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {

                  // loading
                  if (orderProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: BBColors.red),
                    );
                  }

                  // empty
                  if (orderProvider.orders.isEmpty) {
                    return Center(
                      child: Text(
                        'No ${_statusToString(_selectedTab)} orders',
                        style: const TextStyle(
                          color:    BBColors.muted,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // pull to refresh + order list
                  return RefreshIndicator(
                    color:     BBColors.red,
                    onRefresh: () async {
                      _fetchOrders();
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding:   const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (context, index) {
                        final order = orderProvider.orders[index];

                        // format items string
                        final itemsText = order.items
                            .map((i) => '${i.quantity}x ${i.name}')
                            .join(', ');

                        // map status to LiveOrderCard status string
                        final cardStatus = switch (order.status) {
                          'pending'   => 'NEW',
                          'preparing' => 'COOKING',
                          'ready'     => 'READY',
                          _           => 'DONE',
                        };

                        return LiveOrderCard(
                          name:        order.studentId,
                          cms:         int.tryParse(order.studentId) ?? 0,
                          items:       itemsText,
                          price:       order.totalAmount.toInt(),
                          paymentType: order.paymentMethod == 'tab'
                              ? 'Online'
                              : 'Cash',
                          status:      cardStatus,
                          order:       order,
                          // Pass the callback to the card's action button
                          onAccept: order.status != 'completed'
                              ? () => _advanceStatus(order.id!, order.status)
                              : null,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  }