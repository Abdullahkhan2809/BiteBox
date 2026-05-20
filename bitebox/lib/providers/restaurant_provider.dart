import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/services/restaurant_service.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  // ── State 
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;

  // ── Getters 
  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  // LOAD RESTAURANTS — offline first
  

  Future<void> loadRestaurants() async {
    _setLoading(true);
    try {
      final list = await _service.refreshrestaurant();
      _restaurants = list;
      _isOffline = false;
      _errorMessage = null;
    } catch (e) {
      _isOffline = true;
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }
 
  // REFRESH — pull to refresh
  

  Future<void> refresh() async {
    _setLoading(true);
    try {
      final list = await _service.refreshrestaurant();
      _restaurants = list;
      _isOffline = false;
      _errorMessage = null;
    } catch (e) {
      _isOffline = true;
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  // TOGGLE OPEN/CLOSED — manager only
  

  Future<bool> toggleRestaurant({
    required String restaurantId,
    required bool isOpen,
  }) async {
    final result = await _service.toggleRestaurant(
      restaurantId: restaurantId,
      isopen: isOpen,
    );
    if (result['success']) {
      // update local state instantly without waiting for a reload
      final index = _restaurants.indexWhere((r) => r.id == restaurantId);
      if (index != -1) {
        _restaurants[index] = Restaurant(
          id: _restaurants[index].id,
          name: _restaurants[index].name,
          cuisine: _restaurants[index].cuisine,
          imageUrl: _restaurants[index].imageUrl,
          rating: _restaurants[index].rating,
          reviewCount: _restaurants[index].reviewCount,
          menu: _restaurants[index].menu,
        );
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  // ── helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
