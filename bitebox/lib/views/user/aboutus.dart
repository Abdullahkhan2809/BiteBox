import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(74), child: AppbarWidget(title: 'About Us')),
      body: Padding(padding: EdgeInsets.all(16),
      child: Card(
        color: BBColors.surface2,
        
      ),),
    );
  }
}