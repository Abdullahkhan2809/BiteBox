import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/stat_card.dart';
import 'package:bitebox/views/widgets/dashboard_Shell.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/order_card.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    // fetch orders as soon as dashboard loads
    // use addPostFrameCallback so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.restaurantId != null) {
        context.read<OrderProvider>().fetchOrders(
          restaurantId: auth.restaurantId!,
          status: 'pending', // show pending orders on dashboard
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BBColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Dashboard"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Stat Cards — Consumer rebuilds when orders change ──────
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
                          change: 'Pending',
                          changeUp: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── Sales Chart — stays hardcoded until Phase 6 ────────────
              const BBSalesChartCard(),
              const SizedBox(height: 16),

              // ── Live Orders Header ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Live Orders',
                    style:GoogleFonts.poppins (
                      
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        BiteBoxRoutes.adminLiveOrders,
                      );
                    },
                    child: Text(
                      'View all',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: BBColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Live Order Cards — Consumer rebuilds list ──────────────
              Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {

                  // loading state
                  if (orderProvider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: BBColors.red),
                      ),
                    );
                  }

                  // empty state
                  if (orderProvider.orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No pending orders',
                          style: GoogleFonts.poppins(
                            color: BBColors.muted,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  // show max 3 orders on dashboard
                  final preview = orderProvider.orders.take(3).toList();

                  return Column(
                    children: preview.map((order) {
                      // map order status to BBOrderCard status
                      final cardStatus = switch (order.status) {
                        'preparing' => OrderStatus.cooking,
                        'ready'     => OrderStatus.ready,
                        _           => OrderStatus.pending,
                      };

                      // format items as "2x Burger, 1x Fries"
                      final itemsText = order.items
                          .map((i) => '${i.quantity}x ${i.name}')
                          .join(', ');

                      // format time
                      final createdAt = order.createdAt;
                      final timeText = createdAt != null
                          ? _timeAgo(createdAt)
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BBOrderCard(
                          orderNum:     order.id ?? '—',
                          customerName: order.studentId,
                          items:        itemsText,
                          status:       cardStatus,
                          time:         timeText,
                          order:        order,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── helper: "2m ago", "1h ago" ───────────────────────────────────────────
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}