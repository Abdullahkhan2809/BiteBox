import 'dart:convert';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/models/order_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.requestTimeout;

  final StorageService _storage = StorageService();

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_storage.getTokens() ?? ''}',
      };

  Future<Map<String, dynamic>> placeOrder({
    required String studentId,
    required String studentName,
    required String restaurantId,
    required List<Order_items> item,
    required double totalAmount,
    required String paymentMethod,
    String? note,
  }) async {
    try {
      final order = Order(
        studentId:     studentId,
        restaurantId:  restaurantId,
        item:          item,
        totalAmount:   totalAmount,
        paymentMethod: paymentMethod,
        note:          note,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: _authHeaders,
        body: jsonEncode(order.toJson()),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'order': data};
      }
      return {'success': false, 'message': data['message'] ?? 'Failed to place order'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<Order>> getOrders({
    required String restaurantId,
    String? status,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/orders').replace(
        queryParameters: {
          'restaurant_id': restaurantId,
          if (status != null) 'status': status,
        },
      );

      final response = await http.get(uri, headers: _authHeaders)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/orders/$orderId/status'),
        headers: _authHeaders,
        body: jsonEncode({'status': status}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}