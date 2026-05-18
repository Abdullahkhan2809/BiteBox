import 'dart:convert';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class MenuService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.requestTimeout;

  final StorageService _storage = StorageService();

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_storage.getTokens() ?? ''}',
      };

  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    final cached = _storage.getMenuItems(restaurantId);
    if (cached.isNotEmpty) return cached;
    return await refreshMenuItems(restaurantId);
  }

  Future<List<MenuItem>> refreshMenuItems(String restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/menu/$restaurantId'),
        headers: _authHeaders,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final list = jsonList
            .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList();
        await _storage.saveMenuItems(restaurantId, list);
        return list;
      }
      return _storage.getMenuItems(restaurantId);
    } catch (e) {
      return _storage.getMenuItems(restaurantId);
    }
  }

  Future<Map<String, dynamic>> addMenuItem({
    required String restaurantId,
    required String name,
    required String description,
    required double price,
    required String tag,
    required String imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/menu'),
        headers: _authHeaders,
        body: jsonEncode({
          'restaurant_id': restaurantId,
          'name':          name,
          'description':   description,
          'price':         price,
          'category':      tag,
          'image_url':     imageUrl,
        }),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await _storage.clearMenuItems(restaurantId);
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'Failed to add'};
    } catch (e) {
      return {'success': false, 'message': 'No internet connection'};
    }
  }

  Future<Map<String, dynamic>> updateMenuItem({
    required String itemId,
    required String restaurantId,
    String? name,
    String? description,
    double? price,
    bool? isAvailable,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (name != null)        body['name'] = name;
      if (description != null) body['description'] = description;
      if (price != null)       body['price'] = price;
      if (isAvailable != null) body['is_available'] = isAvailable;
      if (imageUrl != null)    body['image_url'] = imageUrl;

      final response = await http.patch(
        Uri.parse('$_baseUrl/menu/$itemId'),
        headers: _authHeaders,
        body: jsonEncode(body),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _storage.clearMenuItems(restaurantId);
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'Failed to update'};
    } catch (e) {
      return {'success': false, 'message': 'No internet connection'};
    }
  }

  Future<Map<String, dynamic>> deleteMenuItem({
    required String itemId,
    required String restaurantId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/menu/$itemId'),
        headers: _authHeaders,
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _storage.clearMenuItems(restaurantId);
        return {'success': true};
      }
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Failed to delete'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<dynamic> getMenu(String id) async {}
}