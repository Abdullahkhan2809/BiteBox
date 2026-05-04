import 'package:hive/hive.dart';

part 'menu_item_model.g.dart';

@HiveType(typeId: 0)
class MenuItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String tag;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final bool isAvailable;

  @HiveField(7)
  final String restaurantId;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.tag,
    required this.imageUrl,
    this.isAvailable = true,
    required this.restaurantId,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id:           json['id'].toString(),
        name:         json['name'] as String,
        description:  json['description'] as String? ?? '',
        price:        (json['price'] as num).toDouble(),
        tag:          json['category'] as String? ?? '',
        imageUrl:     json['image_url'] as String? ?? '',
        isAvailable:  json['is_available'] as bool? ?? true,
        restaurantId: json['restaurant_id'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id':            id,
        'name':          name,
        'description':   description,
        'price':         price,
        'category':      tag,
        'image_url':     imageUrl,
        'is_available':  isAvailable,
        'restaurant_id': restaurantId,
      };
}