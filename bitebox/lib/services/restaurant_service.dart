import 'dart:convert';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RestaurantService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.requestTimeout;

  final StorageService _service = StorageService();

  Map<String, String> get _authHeader => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_service.getTokens() ?? ''}',
  };

  Future<List<Restaurant>> getRestaurant() async {
    final cached = _service.getRestaurnat();
    if (cached.isNotEmpty) return cached;
    return await refreshrestaurant();
  }

  Future<List<Restaurant>> refreshrestaurant() async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/restaurants'),
        headers: _authHeader,
      ).timeout(_timeout);
    } catch (e) {
      // Network unreachable — return offline cache
      debugPrint('[RestaurantService] network error: $e');
      return _service.getRestaurnat();
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonlist = jsonDecode(response.body);
      final list = jsonlist
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();
      await _service.savesRestaurant(list);
      return list;
    }

    // Server returned an error — throw so the provider can surface it
    debugPrint('[RestaurantService] server error ${response.statusCode}: ${response.body}');
    throw Exception('${response.statusCode}: ${response.body}');
  }

  Future<Map<String, dynamic>> toggleRestaurant({
    required String restaurantId,
    required bool isopen,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/restaurants/$restaurantId'),
        headers: _authHeader,
        body: jsonEncode({'is_open': isopen}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _service.savesRestaurant([]);
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}