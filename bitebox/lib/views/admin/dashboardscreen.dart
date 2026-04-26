import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/stat_card.dart';
import 'package:bitebox/views/widgets/dashboard_Shell.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/order_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BBColors.bg,

      // ── AppBar (kept exactly as yours, just colours from design system) ──
      appBar: PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: "Dashboard")),

      // ── Body ──────────────────────────────────────────────────────────────
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stat Cards Row ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: BBStatCard(
                      icon: Icons.payments_outlined,
                      iconColor: BBColors.red,
                      iconBg: const Color(0x26E51904),
                      label: 'Revenue',
                      value: r'$1,243',
                      change: r'+$1,243',
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
                      value: '120',
                      change: '+20%',
                      changeUp: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Sales Chart ────────────────────────────────────────────
              BBSalesChartCard(),
              const SizedBox(height: 16),

              // ── Live Orders Header ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Orders',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, BiteBoxRoutes.adminLiveOrders);
                    },
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: BBColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Live Order Cards ───────────────────────────────────────
              const BBOrderCard(
                orderNum: '3',
                customerName: 'Ali Umair',
                items: '2x Burger 1x Fries',
                status: OrderStatus.ready,
                time: '2m ago',
              ),
              const SizedBox(height: 8),
              const BBOrderCard(
                orderNum: '2',
                customerName: 'Ali Umair',
                items: '2x Burger 1x Fries',
                status: OrderStatus.cooking,
                time: '5m ago',
              ),
              const SizedBox(height: 8),
              const BBOrderCard(
                orderNum: '1',
                customerName: 'Ali Umair',
                items: '2x Burger 1x Fries',
                status: OrderStatus.pending,
                time: '8m ago',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
