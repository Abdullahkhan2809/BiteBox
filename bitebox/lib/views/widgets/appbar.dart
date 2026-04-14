import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget {
  final String title;
  const AppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
           
            Text(title, style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
    );
  }
}