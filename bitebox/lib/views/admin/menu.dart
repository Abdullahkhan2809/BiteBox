import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/services/menu_service.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:bitebox/views/widgets/menuitem_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MenuService _menuService = MenuService();
  List<MenuItem> _items = [];
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loaditem());
  }

  Future<void> _loaditem() async {
    final auth = context.read<AuthProvider>();
    if (auth.restaurantId == null) {
      return;
    }
    setState(() {
      _isloading = true;
    });

    final items = await _menuService.getMenuItems(auth.restaurantId!);
    setState(() {
      _items = items;
      _isloading = false;
    });
  }

  Future<void> _deleteItem(MenuItem item) async {
    final auth = context.read<AuthProvider>();

    // confirmation dialog before deleting
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BBColors.surface2,
        title: const Text(
          'Delete Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Delete "${item.name}"? This cannot be undone.',
          style: const TextStyle(color: BBColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: BBColors.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: BBColors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await _menuService.deleteMenuItem(
      itemId: item.id,
      restaurantId: auth.restaurantId!,
    );

    if (result['success'] == true) {
      _loaditem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Menu"),
      ),

      //body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'MENU ITEMS',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: _isloading
                ? const Center(
                    child: CircularProgressIndicator(color: BBColors.red),
                  )
                : _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: BBColors.muted,
                          size: 60,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No menu items yet',
                          style: TextStyle(color: BBColors.muted, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to add your first item',
                          style: TextStyle(
                            color: BBColors.hintText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return MenuitemCard(
                          title: item.name,
                          category: item.tag,
                          itemDescription: item.description,
                          price: "Rs ${item.price.toStringAsFixed(0)}",
                          onEdit: (){
                              //will do it in phase 5
                          },
                          ondelete: (){
                            _deleteItem(item);
                          },
                        );
                      },
                    ),
                    onRefresh: _loaditem,
                  ),
          ),
        ],
      ),
    );
  }
}
