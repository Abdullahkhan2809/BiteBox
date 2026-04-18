
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String tag; // 'MEAL', 'DRINK', etc.
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.tag,
    required this.imageUrl,
  });
}