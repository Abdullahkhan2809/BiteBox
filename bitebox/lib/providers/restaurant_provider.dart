import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/services/restaurant_service.dart';
import 'package:flutter/material.dart';
class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _restaurantService=RestaurantService();

  //states 
  List<Restaurant> _restaurants=[];
  bool _isloading=false;
  bool _isoffline=false;
  String? _errorMsg;

  //getters 
  List<Restaurant> get restaurant=>_restaurants;
  bool             get isLoading    => _isloading;
  bool             get isOffline    => _isoffline;
  String?          get errorMessage => _errorMsg;

  //loads offline first
    Future<void> loadRestaurants() async {
    _setLoading(true);
    try {
      final list = await _restaurantService.getRestaurant();
      _restaurants  = list;
      _isoffline    = false;
      _errorMsg = null;
    } catch (e) {
      _isoffline    = true;
      _errorMsg = 'Showing cached data';
    }
    _setLoading(false);
  }

  

  //helper
  void _setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }
  
}