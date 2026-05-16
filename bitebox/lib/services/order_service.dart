import 'dart:convert';
import 'package:bitebox/models/order_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String _baseUrl = 'http://10.0.2.2:3000';
  final StorageService _storage = StorageService();

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_storage.getTokens() ?? ''}',
      };

  // PLACE ORDER
  // POST /orders  (student)  

  Future<Map<String, dynamic>> placeOrder({
    required String studentId,
    required String restaurantId,
    required List<Order_items> items,
    required double totalAmount,
    required String paymentMethod, // 'cash' | 'onlinepayment'
    String? note, required String studentName,
  }) async {
    try {
      final order = Order(
        studentId:     studentId,
        restaurantId:  restaurantId,
        items:         items,
        totalAmount:   totalAmount,
        paymentMethod: paymentMethod,
        note:          note,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: _authHeaders,
        body: jsonEncode(order.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'order': data};
      }
      return {
        'success': false,
        // backend sends this when tab limit is exceeded
        'message': data['message'] ?? 'Failed to place order',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // GET ORDERS
  // GET /orders?restaurant_id=x&status=y  (staff)
  // ════════════════════════════════════════════════════════════════════════

  Future<List<Order>> getOrders({
    required String restaurantId,
    String? status, // 'pending' | 'preparing' | 'ready' | 'completed'
  }) async {
    try {
      // build query string
      final uri = Uri.parse('$_baseUrl/orders').replace(
        queryParameters: {
          'restaurant_id': restaurantId,
          if (status != null) 'status': status,
        },
      );

      final response = await http.get(uri, headers: _authHeaders);

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

  // UPDATE ORDER STATUS
  // PATCH /orders/:id/status  (staff)
  // pending → preparing → ready → completed

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/orders/$orderId/status'),
        headers: _authHeaders,
        body: jsonEncode({'status': status}),
      );

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