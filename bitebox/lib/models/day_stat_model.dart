class DayStat {
  final String date;
  final String label;
  final int    orderCount;
  final double revenue;

  const DayStat({
    required this.date,
    required this.label,
    required this.orderCount,
    required this.revenue,
  });

  factory DayStat.fromJson(Map<String, dynamic> json) => DayStat(
    date:       json['date']        as String,
    label:      json['label']       as String,
    orderCount: json['order_count'] as int,
    revenue:    (json['revenue']    as num).toDouble(),
  );
}
