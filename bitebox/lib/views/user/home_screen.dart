import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/menuitemCardUser.dart';
import 'package:bitebox/views/widgets/restaurantcard.dart';
import 'package:bitebox/views/widgets/feedback_footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomestate();
}

class _UserHomestate extends State<UserHome> {
  //defining controller and state
  final TextEditingController _Searchfield = TextEditingController();
  int SelectedIndexFeild = 0;
  final List<String> _categories = [
    'All',
    'Beverages',
    'Desserts',
    'Fast Food',
  ];

  //disposal for the controller
  @override
  void dispose() {
    _Searchfield.dispose();
    super.dispose();
  }

  //badge item itemCount
  int itemCount = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 74,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 74,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Guest!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(201, 255, 255, 255),
                  ),
                ),
                Text(
                  'HUNGRY? LET`S FIND...',
                  style: GoogleFonts.koulen(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(
              controller: _Searchfield,
              label: 'Search for Biryani, Pizza, Tea...',
              onfiltertap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: BBColors.darkRed,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           ListTile(
                            leading: const Icon(Icons.shopping_cart_outlined,
                                color: Color.fromARGB(255, 255, 29, 40)),
                            title:  Text('My Cart',
                                style: GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pushNamed(context,BiteBoxRoutes.cart);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.storefront,
                                color: BBColors.amber),
                            title:  Text('Become a Vendor',
                                style: GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                                BiteBoxRoutes.logout(context);
                            },
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.info_outline, color: BBColors.red),
                            title: Text('About Us',
                                style: GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                                Navigator.pushNamed(context,BiteBoxRoutes.aboutUs);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },

            ),
            const SizedBox(height: 16),
            Text(
              'Top Restarurants',
              style: GoogleFonts.poppins(fontSize: 22,fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            //horizontal scroll view
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //restaurant cards
                  Specialmenucard(
                    foodImage: 'assets/images/logo.jpg',
                    itemName: 'Spicy Karachi Biryani',
                    rate: 4.8,
                    timetext: 5,
                  ),
                  Specialmenucard(
                    foodImage: 'assets/images/logo.jpg',
                    itemName: 'Spicy Karachi Biryani',
                    rate: 4.8,
                    timetext: 5,
                  ),
                  Specialmenucard(
                    foodImage: 'assets/images/logo.jpg',
                    itemName: 'Spicy Karachi Biryani',
                    rate: 4.8,
                    timetext: 5,
                  ),
                  Specialmenucard(
                    foodImage: 'assets/images/logo.jpg',
                    itemName: 'Spicy Karachi Biryani',
                    rate: 4.8,
                    timetext: 5,
                  ),
                  Specialmenucard(
                    foodImage: 'assets/images/logo.jpg',
                    itemName: 'Spicy Karachi Biryani',
                    rate: 4.8,
                    timetext: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Explore Categories',
              style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == SelectedIndexFeild;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        SelectedIndexFeild = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? BBColors.darkRed
                            : const Color.fromARGB(70, 35, 35, 35),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: BBColors.red, width: 1.5),
                      ),
                      child: Text(
                        _categories[index],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //menu filter
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7, // Replace with your actual list length
              itemBuilder: (context, index) {
                return const Menuitemcarduser(
                  title: 'Biryani',
                  category: 'Meal',
                  price: '350',
                  itemDescription: 'Delicious spicy chicken biryani with raita.',
                );
              },
            ),
            //feedback_footer
            Divider(),
            FeedbackFooter(),
            Divider(),
          ],
        ),
      ),
      floatingActionButton: Badge.count(
        count: itemCount,
        padding: const EdgeInsets.all(6),
        backgroundColor: BBColors.red,
        isLabelVisible: itemCount > 0,
        offset: Offset(-8, -2),
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          backgroundColor: BBColors.darkRed,
          onPressed: () {
            Navigator.pushNamed(context,BiteBoxRoutes.cart);
          },
          label:  Text('Orders',style: GoogleFonts.poppins(),),
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
      border: Border.all(color: BBColors.red, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white54, size: 22),

          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardtype,
              style: GoogleFonts.poppins(
                color: Color.fromARGB(215, 255, 255, 255),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(Icons.menu, color: BBColors.red, size: 18),
            ),
          ),
        ],
      ),
    ),
  );
}
