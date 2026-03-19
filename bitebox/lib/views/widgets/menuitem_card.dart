import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class MenuitemCard extends StatefulWidget {
  final String title;
  final String category;
  final String? itemDescription;
  final String? price;
  const MenuitemCard({super.key,required this.title,required this.category, required this.itemDescription, required this.price});

  @override
  State<MenuitemCard> createState() => _MenuitemCardState();
}

class _MenuitemCardState extends State<MenuitemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: BBColors.surface2,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: BBColors.darkRed,
                      child: Text('B'),
                      
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title, style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),),
                          SizedBox(height: 4,),
                          Text(widget.itemDescription??'',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 111, 110, 110)
                          ),)
                        ],
                      ),
                    ),
                   Chip(
                  label: Text(widget.category),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 12),
                  shape: StadiumBorder(), // Automatically gives that perfect pill shape
                    )
                  ],
                ),
                SizedBox(height:18 ,),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(widget.price??'Ask from the canteen',style: TextStyle( fontSize: 20, fontWeight: FontWeight.w900, color: BBColors.red),),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){},
                       padding: EdgeInsets.zero,
                       icon: Icon(Icons.edit, color: BBColors.red, size: 18,)),
                    ),
                    SizedBox(width: 8,),
                     CircleAvatar(
                        radius: 16,
                        backgroundColor: BBColors.redMuted,
                       child: IconButton(onPressed: (){},
                       padding: EdgeInsets.zero,
                       icon: Icon(Icons.delete, color:Colors.white, size: 18,)),
                     )
                  ],
                )
              ],
              
          ),
        ),
    );
  }
}