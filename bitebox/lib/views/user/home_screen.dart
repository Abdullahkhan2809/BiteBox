import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/quickactionbutton.dart';
import 'package:bitebox/views/widgets/specialmenucard.dart';
import 'package:bitebox/views/widgets/feedback_footer.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget{
  
  const UserHome({super.key});

  @override
  State<UserHome> createState()=>_UserHomestate();

}

class _UserHomestate extends State<UserHome>{
  //defining controller and state
  final TextEditingController _Searchfield= TextEditingController();
  int SelectedIndexFeild=0;
  final List<String> _categories = ['All', 'Beverages', 'Desserts', 'Fast Food'];

  //disposal for the controller
  @override
   void dispose(){
    _Searchfield.dispose();
    super.dispose();
   }

    //badge item itemCount
    int itemCount=4;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(controller: _Searchfield, label: 'Search for Biryani, Pizza, Tea...', onfiltertap: () { }),
            const SizedBox(height: 16),

            //action button
            Row(
              children:[
                Quickactionbutton(icon: Icon(Icons.menu_book_rounded), actionName: 'Menu', coloricon: const Color(0xFFCB2121),),
                Spacer(),
                Quickactionbutton(icon: Icon(Icons.local_fire_department), actionName: 'Hot Deals', coloricon: const Color.fromARGB(255, 236, 105, 18),),
                Spacer(),
                Quickactionbutton(icon: Icon(Icons.access_time), actionName: 'Recent', coloricon: Colors.orange,),
              ]
            ),
            const SizedBox(height: 16,),
            Text('Todays special',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 16,),

            //horizontal scroll view

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //restaurant cards
                  Specialmenucard(foodImage:'https://cdn.cosmos.so/763c6b96-774a-406d-bffb-807ea3812dbd?format=jpeg' , itemName: 'Spicy Karachi Biryani', rate: 4.8, timetext: 5),
                  Specialmenucard(foodImage:'https://cdn.cosmos.so/edd1fdb5-f615-4b33-b97a-5074febe5047?format=jpeg' , itemName: 'Spicy Karachi Biryani', rate: 4.8, timetext: 5),
                  Specialmenucard(foodImage:'https://cdn.cosmos.so/423b3acf-5a67-4038-8dda-de34acf5e8fb?format=jpeg' , itemName: 'Spicy Karachi Biryani', rate: 4.8, timetext: 5),
                  Specialmenucard(foodImage:'https://cdn.cosmos.so/863b3482-82bd-45e3-a752-fb9e51b1278b?format=jpeg' , itemName: 'Spicy Karachi Biryani', rate: 4.8, timetext: 5),
                  Specialmenucard(foodImage:'https://cdn.cosmos.so/7548584f-cce3-4795-b740-56c5d648e59b?format=jpeg' , itemName: 'Spicy Karachi Biryani', rate: 4.8, timetext: 5),
                ],
              )),
              const SizedBox(height: 16,),
              Text('Explore Categories',style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 16,),
              SizedBox(
                height:50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder:(context,index){
                    final isSelected=index==SelectedIndexFeild;
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          SelectedIndexFeild=index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          color: isSelected ? BBColors.darkRed : const Color.fromARGB(70, 35, 35, 35),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: BBColors.red, width: 1.5)
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } )
              ),
              //feedback_footer
              Divider(),
              FeedbackFooter(),
              Divider(),
          ],
        ),
      ),
      floatingActionButton: Badge(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        backgroundColor: BBColors.red,

        label:Text(itemCount.toString()),
        isLabelVisible: itemCount>0,
        offset: Offset(-8, -2),
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          backgroundColor: BBColors.darkRed,
          onPressed: (){
            // to the cart
          },
          label: const Text('Orders'),
          icon: const Icon(Icons.shopping_cart),
          shape: StadiumBorder(),
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