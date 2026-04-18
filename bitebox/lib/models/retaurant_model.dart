import 'menu_item_model.dart';
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.menu,
  });
}
