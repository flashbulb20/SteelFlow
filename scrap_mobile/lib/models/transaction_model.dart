// lib/models/transaction_model.dart
import 'dart:convert';

class TransactionModel {
  final int id;
  final String buyerName;
  final String scrapType;
  final double quantity;
  final double price;
  final String? contractStatus;
  final DateTime? contractDate;
  final String? deliveryStatus;
  final int? sellerId;

  /// ✅ 계산용 필드: 입고/출고 구분
  String get tradeType {
    final s = (contractStatus ?? '').toLowerCase();
    if (s.contains('입고')) return '입고';
    if (s.contains('출고')) return '출고';
    return '기타';
  }

  /// ✅ 총 금액 계산
  double get totalAmount => (quantity * price);

  TransactionModel({
    required this.id,
    required this.buyerName,
    required this.scrapType,
    required this.quantity,
    required this.price,
    this.contractStatus,
    this.contractDate,
    this.deliveryStatus,
    this.sellerId,
  });

  /// ✅ JSON → Model 변환
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;

    // 서버에서 날짜가 문자열로 올 경우 안전하게 변환
    if (json['contract_date'] != null) {
      try {
        parsedDate = DateTime.parse(json['contract_date']);
      } catch (_) {
        parsedDate = null;
      }
    }

    return TransactionModel(
      id: json['id'] ?? 0,
      buyerName: json['buyer_name'] ?? '',
      scrapType: json['scrap_type'] ?? '',
      quantity: (json['quantity'] is int)
          ? (json['quantity'] as int).toDouble()
          : (json['quantity'] ?? 0.0).toDouble(),
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      contractStatus: json['contract_status'] ?? '',
      contractDate: parsedDate,
      deliveryStatus: json['delivery_status'],
      sellerId: json['seller_id'],
    );
  }

  /// ✅ Model → JSON 변환
  Map<String, dynamic> toJson() => {
    'id': id,
    'buyer_name': buyerName,
    'scrap_type': scrapType,
    'quantity': quantity,
    'price': price,
    'contract_status': contractStatus,
    'contract_date': contractDate?.toIso8601String(),
    'delivery_status': deliveryStatus,
    'seller_id': sellerId,
  };

  /// ✅ 디버깅용 문자열
  @override
  String toString() => jsonEncode(toJson());
}
