// lib/services/api_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// ✅ 기본 API 서버 주소
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? "http://210.119.84.112:8000/api/mobile";

  /// ✅ 엔드포인트 URL 생성
  static String endpoint(String path) {
    if (path.startsWith("/")) {
      return "$baseUrl$path";
    } else {
      return "$baseUrl/$path";
    }
  }

  /// ✅ 인증 헤더 생성
  static Future<Map<String, String>> authHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      return {'Content-Type': 'application/json'};
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// ✅ 공통 에러 핸들러
  static String handleError(dynamic error) {
    return error.toString().replaceAll("Exception:", "").trim();
  }
}
