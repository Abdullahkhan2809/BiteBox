import 'package:bitebox/views/widgets/appbar.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: "Menu")),

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
    
    );
  }
}
