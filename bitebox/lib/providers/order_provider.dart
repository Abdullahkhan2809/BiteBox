import 'package:bitebox/models/order_model.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/services/order_service.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();

  // ── State
  List<Order> _orders       = [];
  Order?      _placedOrder;   // last successfully placed order
  bool        _isLoading    = false;
  String?     _errorMessage;

  // ── Getters 
  List<Order> get orders       => _orders;
  Order?      get placedOrder  => _placedOrder;
  bool        get isLoading    => _isLoading;
  String?     get errorMessage => _errorMessage;

 
  // PLACE ORDER — called from checkout screen
  

  Future<bool> placeOrder({
    required String studentId,
    required String studentName,
    required String restaurantId,
    required CartProvider cartProvider, // passed in so we can clear cart
    required String paymentMethod,
    String? note,
  }) async {
    _setLoading(true);

    // convert cart entries to OrderItems
    final items = cartProvider.entries.map((e) => Order_items(
      menuItem:      e.items.id,
      name:            e.items.name,
      quantity:        e.quantity,
      priceAtpurchase: e.items.price,
    )).toList();

    final result = await _service.placeOrder(
      studentId:     studentId,
      studentName:   studentName,
      restaurantId:  restaurantId,
      items:         items,
      totalAmount:   cartProvider.total,
      paymentMethod: paymentMethod,
      note:          note,
    );

    if (result['success']) {
      _placedOrder  = Order.fromJson(result['order'] as Map<String, dynamic>);
      _errorMessage = null;
      cartProvider.clear(); // wipe cart after successful order
      _setLoading(false);
      return true;
    } else {
      _errorMessage = result['message'];
      _setLoading(false);
      return false;
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // GET ORDERS — staff live order queue
  // ════════════════════════════════════════════════════════════════════════

  Future<void> fetchOrders({
    required String restaurantId,
    String? status,
  }) async {
    _setLoading(true);
    final list = await _service.getOrders(
      restaurantId: restaurantId,
      status:       status,
    );
    _orders       = list;
    _errorMessage = null;
    _setLoading(false);
  }

  // ════════════════════════════════════════════════════════════════════════
  // UPDATE ORDER STATUS — staff taps accept/next on live order card
  // pending → preparing → ready → completed
  // ════════════════════════════════════════════════════════════════════════

  Future<bool> advanceOrderStatus({
    required String orderId,
    required String currentStatus,
  }) async {
    // map current → next status
    const nextStatus = {
      'pending':   'preparing',
      'preparing': 'ready',
      'ready':     'completed',
    };

    final next = nextStatus[currentStatus];
    if (next == null) return false; // already completed

    final result = await _service.updateOrderStatus(
      orderId: orderId,
      status:  next,
    );

    if (result['success']) {
      // update locally without refetching whole list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = Order(
          id:            _orders[index].id,
          studentId:     _orders[index].studentId,
          restaurantId:  _orders[index].restaurantId,
          items:         _orders[index].items,
          totalAmount:   _orders[index].totalAmount,
          paymentMethod: _orders[index].paymentMethod,
          status:        next,
          note:          _orders[index].note,
          createdAt:     _orders[index].createdAt,
        );
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  // ── helper ───────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}