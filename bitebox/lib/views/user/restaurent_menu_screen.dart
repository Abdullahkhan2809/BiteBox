import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/feedback_footer.dart';
import 'package:bitebox/views/widgets/menuitemCardUser.dart';
import 'package:flutter/material.dart';
import 'package:bitebox/models/retaurant_model.dart';

class RestaurentMenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurentMenuScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurentMenuScreen> createState() => _RestaurentMenuScreenState();
}

class _RestaurentMenuScreenState extends State<RestaurentMenuScreen> {
  // count of items into the badge
  int itemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: AppbarWidget(title: 'Menu'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //bread crumbs
                        Row(
                          children: [
                            InkWell(
                              onDoubleTap: () {
                                //navigate to home screen
                              },
                              child: Text(
                                'NBC',
                                style: TextStyle(
                                  color: BBColors.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '> ... > as Per the retaurant ',
                              style: TextStyle(
                                color: BBColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        //restaurant info Row
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12),
                              //statemanagement of picture of the retaurant
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //state manage both of the requirement
                                Text(
                                  widget.restaurant.cuisine,
                                  style: TextStyle(
                                    color: BBColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.restaurant.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //ratting Row
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: BBColors.amber,
                              size: 26,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              //statemanagement of the reviews
                              '${widget.restaurant.rating}/5 (${widget.restaurant.reviewCount})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ' See reviews',
                              style: TextStyle(
                                color: BBColors.muted,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: BBColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'More info',
                              style: TextStyle(
                                color: const Color.fromARGB(213, 255, 255, 255),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //menu items lists
                // --- Menu Items List ---
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = widget.restaurant.menu[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Menuitemcarduser(
                        title: item.name,
                        category: item.tag,
                        itemDescription: item.description,
                        price: item.price.toStringAsFixed(0),
                        imageUrl: item.imageUrl,
                        // ✅ No onEdit/onDelete = customer view (shows + button)
                        // For admin page pass:
                        // onEdit: () => _editItem(item),
                        // onDelete: () => _deleteItem(item),
                      ),
                    );
                  }, childCount: widget.restaurant.menu.length),
                ),
                const SliverToBoxAdapter(child: Divider(height: 1)),
                const SliverToBoxAdapter(child: FeedbackFooter()),
                const SliverToBoxAdapter(child: Divider(height: 1)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Badge(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        backgroundColor: BBColors.red,

        label: Text(itemCount.toString(), style: TextStyle(fontSize: 14)),
        isLabelVisible: itemCount > 0,
        offset: Offset(-8, -2),
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          backgroundColor: BBColors.darkRed,
          onPressed: () {
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
