// lib/services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import 'api_service.dart';

/// 거래 관련 API 호출 담당 (서버 호출은 그대로 두고, 필터는 프론트에서만 처리)
class TransactionService extends ApiService {
  /// ✅ 거래 목록 가져오기 (백엔드 비수정)
  static Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final url = Uri.parse(ApiService.endpoint('/transactions'));
      final headers = await ApiService.authHeader(); // ✅ JWT 헤더 포함

      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(res.body);
        return raw.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception('거래 내역 조회 실패: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('거래 내역 조회 중 오류 발생: $e');
    }
  }
}
