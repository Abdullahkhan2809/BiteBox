import 'dart:convert';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class RestaurantService {
  static const String _baseUrl = 'http://192.168.1.1:3000';

  final StorageService _service = StorageService();

  //JWT to every request
  Map<String, String> get _authHeader => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_service.getTokens() ?? ''}',
  };

  // GET RESTAURANTS
  // offline-first: show cache instantly, refresh from network in background

  Future<List<Restaurant>> getRestaurant() async {
    final cached = _service.getRestaurnat();
    if (cached.isNotEmpty) {
      return cached;
    }
    //if nothing in cache fetch it from the network
    return await refreshrestaurant();
  }

  //network fetching
  Future<List<Restaurant>> refreshrestaurant() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Restaurant'),
        headers: _authHeader,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonlist = jsonDecode(response.body);
        final list = jsonlist
            .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
            .toList();

        //  save to hive cache 
        await _service.savesRestaurant(list);
        return list;
      }
      return _service.getRestaurnat();

    } catch (e) {
      return _service.getRestaurnat();
    }
  }

  //toggle the restaurant that is it open or closed

  Future<Map<String,dynamic>> toggleRestaurant({
    required String restaurantId,
    required bool isopen,
  }) async{
    try{
      final response= await http.patch(
        Uri.parse('$_baseUrl/restaurant/$restaurantId'),
        headers: _authHeader,
        body:jsonEncode({'isopen': isopen}),
      );

      final data=jsonDecode(response.body);

      if(response.statusCode==200 || response.statusCode==201){
        await _service.savesRestaurant([]);
        return {'success':true};
      }
        return{'success':false, 'message':data['message'] ?? 'failed'};
      }catch(e){
        return{'success':false, 'message':e.toString()};
    }
  }
}
