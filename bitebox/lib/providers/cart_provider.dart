import 'package:flutter/material.dart';
import 'package:bitebox/models/menu_item_model.dart';

class CartEntry {
  final MenuItem item;
  int quantity;

  CartEntry({required this.item, required this.quantity});

  double get subtotal => item.price * quantity;
}

class CartProvider extends ChangeNotifier {
  //state
  final List<CartEntry> _entries = [];
  String? _restaurantid;

  List<CartEntry> get entries => List.unmodifiable(_entries);
  String? get restaurantId => _restaurantid;
  bool get isEmpty => _entries.isEmpty;
  int get itemCount => _entries.fold(0, (sum, e) => sum + e.quantity);

  double get total => _entries.fold(0.0, (sum, e) => sum + e.subtotal);

  void addItem(MenuItem item) {
    // If adding from a different restaurant, clear the cart first
    if (_restaurantid != null && _restaurantid != item.restaurantId) {
      clear();
    }

    _restaurantid = item.restaurantId;

    final index = _entries.indexWhere((e) => e.item.id == item.id);
    if (index != -1) {
      _entries[index].quantity++;
    } else {
      _entries.add(CartEntry(item: item, quantity: 1));
    }
    notifyListeners();
  }

  void increment(String itemId) {
    final index = _entries.indexWhere((e) => e.item.id == itemId);
    if (index != -1) {
      _entries[index].quantity++;
      notifyListeners();
    }
  }

  void decrement(String itemId) {
    final index = _entries.indexWhere((e) => e.item.id == itemId);
    if (index != -1) {
      removeItem(itemId);
    }
  }

  void removeItem(String itemId) {
    final index = _entries.indexWhere((e) => e.item.id == itemId);
    if (index != -1) {
      if (_entries[index].quantity > 1) {
        _entries[index].quantity--;
      } else {
        _entries.removeAt(index);
      }

      if (_entries.isEmpty) {
        _restaurantid = null;
      }
      notifyListeners();
    }
  }

  void clear() {
    _entries.clear();
    _restaurantid = null;
    notifyListeners();
  }

  // covert entries item to order item for the api call
  List<Map<String, dynamic>> toOrderitem() {
    return _entries
        .map(
          (e) => {
            'menu_item': e.item.id,
            'name': e.item.name,
            'quantity': e.quantity,
            'priceAtpurchase': e.item.price,
          },
        )
        .toList();
  }
}
