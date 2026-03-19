import 'package:bitebox/views/widgets/menuitem_card.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/bottomnavigationbar.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  int _activeNav = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'ADD ITEM',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      //body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'MENU ITEMS',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              // The padding here handles spacing between the cards and screen edges
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return const MenuitemCard(
                  title: 'Zinger Burger',
                  category: 'MEAL',
                  itemDescription: 'Zinger patty, dynamite sauce, iceberg...',
                  price: 'Rs 450.00',
                );
              },
            ),
          ),
        ],
      ),
      //bottom nav
      bottomNavigationBar: BBBottomNavBar(
        activeIndex: _activeNav,
        onTap: (i) => setState(() => _activeNav = i),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: BBColors.red,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
