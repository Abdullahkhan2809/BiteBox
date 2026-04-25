import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem extends StatefulWidget {
  final String title;
  final String category;
  final String? itemDescription;
  final String? price;
  const CartItem({super.key,required this.title,required this.category, required this.itemDescription, required this.price});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
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
                          Text(widget.title, style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),),
                          SizedBox(height: 4,),
                          Text(widget.itemDescription??'',
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 111, 110, 110)
                          ),)
                        ],
                      ),
                    ),
                   Chip(
                  label: Text(widget.category),
                  backgroundColor: Colors.white,
                  labelStyle: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 12),
                  shape: StadiumBorder(), // Automatically gives that perfect pill shape
                    )
                  ],
                ),
                SizedBox(height:18 ,),
                Row(
                  children: [
                    Text(widget.price != null ? " Rs.${widget.price}" : 'Ask from the canteen',style: GoogleFonts.poppins( fontSize: 20, fontWeight: FontWeight.w900, color: BBColors.red),),
                    SizedBox(width: 16,),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){},
                       padding: EdgeInsets.zero,
                       icon: Icon(Icons.remove_outlined  , color: BBColors.red, size: 24,)),
                    ),
                    SizedBox(width: 8,),
                    Text('1', style: GoogleFonts.poppins( fontSize:18,fontWeight:FontWeight.bold),), // dynamic counter for the addition of items
                    SizedBox(width: 8,),
                     CircleAvatar(
                        radius: 16,
                        backgroundColor: BBColors.redMuted,
                       child: IconButton(onPressed: (){},
                       padding: EdgeInsets.zero,
                       icon: Icon(Icons.add, color:Colors.white, size: 24,)),
                     ),
                     Spacer(),
                     IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline))
                  ],
                )
              ],
              
          ),
        ),
    );
  }
}