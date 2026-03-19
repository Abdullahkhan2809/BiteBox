import 'package:bitebox/views/widgets/bottomnavigationbar.dart';
import 'package:bitebox/views/widgets/stat_card.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/status_button_live_orders.dart';
import 'package:flutter/material.dart';


class AdminLiveOrder extends StatefulWidget {
  const AdminLiveOrder({super.key});

  @override
  State<AdminLiveOrder> createState() => _AdminLiveOrderState();
}

class _AdminLiveOrderState extends State<AdminLiveOrder> {
  int _activeNav=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 74,
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
                height: 74,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'LIVE ORDERS',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      //body 
      body: SafeArea(
        child:SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //stats cards
              Row(
                children: [
                  Expanded(
                    child:
                    BBStatCard(icon:Icons.payments_outlined , iconColor:BBColors.red , iconBg:const Color(0x26E51904) , label:'Revenue' , value:r'$1,243' , change:r'20%',),
                     ),
                     SizedBox(width: 12,),
                  Expanded(
                    child:
                    BBStatCard(icon:Icons.shopping_bag_outlined , iconColor:BBColors.red , iconBg:const Color(0x26E51904) , label:'Sales' , value:r'123' , change:r'20%',),
                     )
                ],
              ),
              //status card
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  StatusButtonLiveOrders(orders: 12, status: 'pending',isSelected: true,),
                  Spacer(),
                  StatusButtonLiveOrders(orders: 12, status: 'Ready',isSelected: false,),
                  Spacer(),
                  StatusButtonLiveOrders(orders: 12, status: 'Served',isSelected: false,),
                ],
              ),
              
              //order header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                ],
              )
            ],
          ),
          ) 
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