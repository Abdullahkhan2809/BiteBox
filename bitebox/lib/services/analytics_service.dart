import 'dart:convert';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/models/day_stat_model.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  static const String _baseUrl = AppConstants.baseUrl;
  final StorageService _storage = StorageService();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${_storage.getTokens() ?? ''}',
  };

  Future<List<DayStat>> fetchDailyStats(String restaurantId) async {
    try {
      final uri = Uri.parse('$_baseUrl/analytics/daily')
          .replace(queryParameters: {'restaurant_id': restaurantId});
      final response = await http
          .get(uri, headers: _headers)
          .timeout(AppConstants.requestTimeout);
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list
            .map((e) => DayStat.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
