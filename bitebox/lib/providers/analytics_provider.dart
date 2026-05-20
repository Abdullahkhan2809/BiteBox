import 'dart:math';
import 'package:bitebox/models/day_stat_model.dart';
import 'package:bitebox/services/analytics_service.dart';
import 'package:flutter/material.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsService _service = AnalyticsService();

  List<DayStat> _stats   = [];
  bool          _loading = false;

  List<DayStat> get stats     => _stats;
  bool          get isLoading => _loading;

  double get totalRevenue => _stats.fold(0.0, (s, d) => s + d.revenue);
  int    get totalOrders  => _stats.fold(0,   (s, d) => s + d.orderCount);
  double get maxRevenue   => _stats.isEmpty ? 1 : _stats.map((d) => d.revenue).reduce(max);
  int    get maxOrders    => _stats.isEmpty ? 1 : _stats.map((d) => d.orderCount).reduce(max);

  List<double> get normalizedRevenue => _stats
      .map((d) => maxRevenue > 0 ? d.revenue / maxRevenue : 0.0)
      .toList();

  List<double> get normalizedOrders => _stats
      .map((d) => maxOrders > 0 ? d.orderCount / maxOrders : 0.0)
      .toList();

  List<String> get xLabels => _stats.map((d) => d.label).toList();

  List<String> get yLabels {
    if (_stats.isEmpty) return ['0', '500', '1k', '1.5k', '2k'];
    return List.generate(5, (i) {
      final val = maxRevenue * i / 4;
      return val >= 1000
          ? '${(val / 1000).toStringAsFixed(1)}k'
          : val.toStringAsFixed(0);
    });
  }

  Future<void> fetchStats(String restaurantId) async {
    _loading = true;
    notifyListeners();
    _stats   = await _service.fetchDailyStats(restaurantId);
    _loading = false;
    notifyListeners();
  }
}
