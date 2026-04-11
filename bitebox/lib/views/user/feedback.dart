import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Feedback extends StatelessWidget {
  const Feedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 74,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom:Radius.circular(35) ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:Image.asset('assets/images/logo.jpg', height: 74, fit: BoxFit.cover,),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, Guest!', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(201, 255, 255, 255),
                ),),
                Text('HUNGRY? LET`S FIND...', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),)
              ],
            )
          ],
        ),
      ),
      body: Container(
        
      ),
    );
  }
}