
class RevenueDTO {
  final DateTime date;
  final double revenue;

  RevenueDTO({required this.date, required this.revenue});

  factory RevenueDTO.fromJson(Map<String, dynamic> json) {
    return RevenueDTO(
      date: DateTime.parse(json['date']),
      revenue: json['revenue'].toDouble(),
    );
  }
}