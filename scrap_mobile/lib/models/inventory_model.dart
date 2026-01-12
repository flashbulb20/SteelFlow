/// 재고 정보를 표현하는 데이터 모델
class InventoryModel {
  final int id;
  final String scrapType;
  final double weight;
  final String qualityGrade;
  final String location;
  final DateTime timestamp;

  InventoryModel({
    required this.id,
    required this.scrapType,
    required this.weight,
    required this.qualityGrade,
    required this.location,
    required this.timestamp,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      scrapType: json['scrap_type'],
      weight: (json['weight'] as num).toDouble(),
      qualityGrade: json['quality_grade'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
