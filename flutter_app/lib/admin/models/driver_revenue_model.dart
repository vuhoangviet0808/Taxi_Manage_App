class RevenueData {
  final String period;
  final double revenue;

  RevenueData({required this.period, required this.revenue});

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      period: json['period'],
      revenue: json['revenue'].toDouble(),
    );
  }
}
