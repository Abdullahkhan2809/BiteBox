class Order_items {
  final String menuItem;
  final String name;
  final int quantity;
  final double priceAtpurchase;

  Order_items({
    required this.menuItem,
    required this.name,
    required this.quantity,
    required this.priceAtpurchase,
  });

  factory Order_items.fromJson(Map<String, dynamic> json) => Order_items(
    menuItem: json['menu_item'].toString(),
    name: json['name'] as String? ?? '',
    quantity: json['quantity'] as int,
    priceAtpurchase: (json['priceAtpurchase'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'menu_item': menuItem,
    'name': name,
    'quantity': quantity,
    'priceAtpurchase': priceAtpurchase,
  };
}

//orders notes
class Order {
  final String? id;
  final String studentId;
  final String restaurantId;
  final List<Order_items> items;
  final double totalAmount;
  final String paymentMethod; // 'cash' | 'tab'
  final String status;        // 'pending' | 'preparing' | 'ready' | 'completed'
  final String? note;
  final DateTime? createdAt;

  Order({
    this.id,
    required this.studentId,
    required this.restaurantId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.status = 'pending',
    this.note,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id:            json['id'].toString(),
        studentId:     json['student_id'] as String,
        restaurantId:  json['restaurant_id'].toString(),
        items:         (json['items'] as List<dynamic>? ?? [])
                           .map((e) => Order_items.fromJson(e as Map<String, dynamic>))
                           .toList(),
        totalAmount:   (json['total_amount'] as num).toDouble(),
        paymentMethod: json['payment_method'] as String,
        status:        json['status'] as String? ?? 'pending',
        note:          json['note'] as String?,
        createdAt:     json['created_at'] != null
                           ? DateTime.parse(json['created_at'] as String)
                           : null,
      );

  Map<String, dynamic> toJson() => {
        'student_id':     studentId,
        'restaurant_id':  restaurantId,
        'items':          items.map((e) => e.toJson()).toList(),
        'total_amount':   totalAmount,
        'payment_method': paymentMethod,
        'note':           note,
      };
}