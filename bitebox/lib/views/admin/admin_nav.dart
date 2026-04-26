import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/admin/admin_live_order.dart';
import 'package:bitebox/views/admin/dashboardscreen.dart';
import 'package:bitebox/views/admin/menu.dart';
import 'package:bitebox/views/widgets/bottomnavigationbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class AdminNav extends StatefulWidget {
  final int index;
  const AdminNav({super.key, this.index = 0});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  late int _activeIndex = widget.index;

  void _onTabTapped(int index) {
  if (index == 3) {
    Navigator.pushNamed(context, BiteBoxRoutes.adminProfile,arguments: _activeIndex);
    return;
  }
  setState(() => _activeIndex = index);
}

  List<Widget> get _screens => [
    const DashboardScreen(),
    const Menu(),
    const AdminLiveOrder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: BBColors.darkRed,
      body: IndexedStack(index: _activeIndex, children: _screens),
      bottomNavigationBar: BBBottomNavBar(
        activeIndex: _activeIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacementNamed(context, BiteBoxRoutes.adminAddItem);
      },
      backgroundColor: BBColors.red,
      shape: const CircleBorder(),
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 26),    ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
