import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget{
  
  const UserHome({super.key});

  @override
  State<UserHome> createState()=>_UserHomestate();

}

class _UserHomestate extends State<UserHome>{
  //defining controller and state
  final TextEditingController _Searchfield= TextEditingController();
  final int _SelectedIndexFeild=0;
  final List<String> _categories = ['All', 'Beverages', 'Desserts', 'Fast Food'];

  //disposal for the controller
  @override
   void dispose(){
    _Searchfield.dispose();
    super.dispose();
   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
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

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child:Column(
          children: [
            _buildSearchField(controller: _Searchfield, label: 'Search for Biryani, Pizza, Tea...', onfiltertap: () { }),
          ],
        ),
      ),
    );
  }
}

//TextFormField

Widget _buildSearchField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardtype,
  VoidCallback? onfiltertap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(61, 255, 0, 0),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: BBColors.red,
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.white54,
            size: 22,
          ),

          const SizedBox(width: 4,),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardtype,
              style: const TextStyle(
                color: Color.fromARGB(215, 255, 255, 255),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

        
          GestureDetector(
            onTap: onfiltertap,
            child: Container(
              margin: const EdgeInsets.only(right: 3),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius:BorderRadius.circular(30),
              ),
              child:Icon(Icons.menu,
              color: BBColors.red,
              size: 18,
              )
            ),
          ),
        ],
      ),
    ),
  );
}