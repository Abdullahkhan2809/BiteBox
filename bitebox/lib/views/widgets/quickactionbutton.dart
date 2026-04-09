import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Quickactionbutton extends StatefulWidget {
  final Icon icon;
  final String actionName;
  final Color coloricon;
  const Quickactionbutton({super.key, required this.icon, required this.actionName, required this.coloricon});

  @override
  State<Quickactionbutton> createState() => _QuickactionbuttonState();
}

class _QuickactionbuttonState extends State<Quickactionbutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:BBColors.surface2,
        
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Add your action here
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon.icon, size: 50, color: widget.coloricon,),
              const SizedBox(height: 4,),
              Text(widget.actionName, style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}