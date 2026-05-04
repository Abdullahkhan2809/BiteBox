import 'package:hive/hive.dart';

import 'menu_item_model.dart';

part 'retaurant_model.g.dart';

@HiveType(typeId: 1)
class Restaurant extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String cuisine;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final int reviewCount;
  @HiveField(6)
  final List<MenuItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'].toString(),
        name: json['name'] as String,
        cuisine: json['cuisine'] as String? ?? '',
        imageUrl: json['image_url'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['review_count'] as int? ?? 0,
        menu: (json['menu'] as List? ?? [])
            .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cuisine': cuisine,
        'image_url': imageUrl,
        'rating': rating,
        'review_count': reviewCount,
        'menu': menu.map((item) => item.toJson()).toList(),
      };
}
