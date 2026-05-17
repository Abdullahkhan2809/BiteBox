import 'dart:convert';

import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:hive/hive.dart';

class StorageService {
  //get hive reference
  Box get _userData => Hive.box('userdata');
  Box<MenuItem> get _menuData => Hive.box<MenuItem>('menu_items_box');
  Box<Restaurant> get _restaurantData =>
      Hive.box<Restaurant>('restaurants_box');

  // authentication for the students Side
  //called right  after login api returns a token
  Future<void> saveToken(String token) async {
    await _userData.put('jwt', token);
  }

  //called by every service file when before making any api request
  String? getTokens() {
    return _userData.get('jwt') as String?;
  }

  // check if stored JWT is expired before using it
  bool get isTokenExpired {
    final token = getTokens();
    if (token == null) return true;

    try {
      // JWT is 3 base64 parts: header.payload.signature
      final parts = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'] as int;
      return DateTime.now().millisecondsSinceEpoch / 1000 > exp;
    } catch (_) {
      return true; // if decode fails, treat as expired
    }
  }

  //called after student enters name+phoneNumber+cmsid in add UserDetails
  Future<void> saveStudent({
    required String cmsId,
    required String name,
    required String phone,
    required String category,
    required String paymentMethod,
  }) async {
    await _userData.put('cms_id', cmsId);
    await _userData.put('name', name);
    await _userData.put('phone', phone);
    await _userData.put('category', category);
    await _userData.put('payment_method', paymentMethod);
  }

  String? getStudentCMSID() => _userData.get('cms_id') as String?;
  String? getStudentName() => _userData.get('name') as String?;
  String? getStudentPhone() => _userData.get('phone') as String?;
  String? getStudentPaymentMethod() =>
      _userData.get('payment_method') as String?;

  // called on logout — wipes token and student session
  Future<void> clearAll() async {
    await _userData.clear();
  }

  //check does token exist
  bool get islogged => getTokens() != null;

  //restaurant side offline cache optimizer
  Future<void> savesRestaurant(List<Restaurant> list) async {
    await _restaurantData.clear();
    for (final r in list) {
      await _restaurantData.put(r.id, r);
    }
  }

  //called on home screen no load no internet needed
  List<Restaurant> getRestaurnat() {
    return _restaurantData.values.toList();
  }

  // is there anything cached at all?
  bool get hasRestaurants => _restaurantData.isNotEmpty;

  //menu items offline cache per restaurant

  Future<void> saveMenuItems(String restaurantId, List<MenuItem> items) async {
    // remove old items for THIS restaurant only
    final oldKeys = _menuData.keys.where((k) {
      return _menuData.get(k)?.restaurantId == restaurantId;
    }).toList();
    await _menuData.deleteAll(oldKeys);

    // save new items
    for (final item in items) {
      await _menuData.put(item.id, item);
    }
  }

  // called by restaurent_menu_screen on load
  List<MenuItem> getMenuItems(String restaurantId) {
    return _menuData.values
        .where((item) => item.restaurantId == restaurantId)
        .toList();
  }

  // called when manager edits/deletes an item — forces fresh fetch next time
  Future<void> clearMenuItems(String restaurantId) async {
    final keys = _menuData.keys.where((k) {
      return _menuData.get(k)?.restaurantId == restaurantId;
    }).toList();
    await _menuData.deleteAll(keys);
  }

  // is there cached menu data for this restaurant?
  bool hasMenuItems(String restaurantId) {
    return _menuData.values.any((item) => item.restaurantId == restaurantId);
  }

  Future<void> updateUser({
    required String name,
    required String phone,
    required String email,
    required String location,
    required String restaurantName,
    required String bio,
  }) async {
    await _userData.put('name', name);
    await _userData.put('phone', phone);
    await _userData.put('email', email);
    await _userData.put('location', location);
    await _userData.put('restaurant_name', restaurantName);
    await _userData.put('bio', bio);
  }
}
