import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/services/menu_service.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/feedback_footer.dart';
import 'package:bitebox/views/widgets/menuitemCardUser.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/core/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  final MenuService _menuService =MenuService();
  List<MenuItem> items=[];
  bool isloading=false;

    @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMenu();
    });
  }

  Future<void> _loadMenu() async {
    setState(() => isloading = true);
    try {
      final fetched = await _menuService.getMenu(widget.restaurant.id);
      setState(() {
        items = fetched;
        isloading = false;
      });
    } catch (e) {
      setState(() => isloading = false);
      debugPrint('Error loading menu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final itemCount = cartProvider.itemCount;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: AppbarWidget(title: 'Menu'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _menuService
            .refreshMenuItems(widget.restaurant.id)
            .then((fetched) => setState(() => items = fetched)),
        child: Column(
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
                                onTap: () {
                                  //navigate to home screen
                                  Navigator.pushNamedAndRemoveUntil(context, BiteBoxRoutes.home, (route) => false);
                                },
                                child: Text(
                                  'Home',
                                  style: GoogleFonts.poppins(
                                    color: BBColors.muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                               SizedBox(width: 4),
                              Text(
                                '> ... > as Per the retaurant ',
                                style: GoogleFonts.poppins(
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
                                borderRadius: BorderRadius.circular(12),
                                child: widget.restaurant.imageUrl.isNotEmpty
                                    ? Image.network(
                                        widget.restaurant.imageUrl,
                                        height: 64,
                                        width:  64,
                                        fit:    BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _fallbackImage(),
                                      )
                                    : _fallbackImage(),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //state manage both of the requirement
                                  Text(
                                    widget.restaurant.cuisine,
                                    style: GoogleFonts.poppins(
                                      color: BBColors.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    widget.restaurant.name,
                                    style: GoogleFonts.koulen(
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
                                style:GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ' See reviews',
                                style: GoogleFonts.poppins(
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
                                style: GoogleFonts.poppins(
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
                  // --- Menu Items ---
                  if (isloading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: BBColors.red)),
                    )
                  else if (items.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No menu items available',
                          style: GoogleFonts.poppins(color: BBColors.muted, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Menuitemcarduser(
                            title: item.name,
                            category: item.tag,
                            itemDescription: item.description,
                            price: item.price.toStringAsFixed(0),
                            imageUrl: item.imageUrl,
                            onTap: () {
                              context.read<CartProvider>().addItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item.name} added to cart',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: BBColors.darkRed,
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: items.length),
                    ),
                  const SliverToBoxAdapter(child: Divider(height: 1)),
                  const SliverToBoxAdapter(child: FeedbackFooter()),
                  const SliverToBoxAdapter(child: Divider(height: 1)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Badge(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        backgroundColor: BBColors.red,

        label: Text(itemCount.toString(), style: GoogleFonts.poppins(fontSize: 14)),
        isLabelVisible: itemCount > 0,
        offset: Offset(-8, -2),
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          backgroundColor: BBColors.darkRed,
          onPressed: () => Navigator.pushNamed(context, BiteBoxRoutes.cart),
          label: const Text('Orders'),
          icon: const Icon(Icons.shopping_cart),
          shape: StadiumBorder(),
        ),
      ),
    );
  }
    Widget _fallbackImage() {
    return Container(
      width:  64,
      height: 64,
      decoration: BoxDecoration(
        color:        BBColors.darkRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.restaurant, color: Colors.white),
    );
  }
}
