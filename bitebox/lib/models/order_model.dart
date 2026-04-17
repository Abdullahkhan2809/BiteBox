//orders notes
class Order {
  final String restaurantId;
  final List items;
  final String note;

  Order({
    required this.restaurantId,
    required this.items,
    required this.note,
  });
}