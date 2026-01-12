import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

/// 인증 관련 API 호출 담당 (로그인, 회원가입, 프로필 등)
class AuthService extends ApiService {
  /// ✅ 로그인 요청
  Future<UserModel?> login(String username, String password) async {
    try {
      // ✅ FastAPI는 /auth/login/ 로 끝나므로 반드시 슬래시 포함
      final url = Uri.parse(ApiService.endpoint('/auth/login/'));
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('user')) {
          final user = UserModel.fromJson(data['user']);

          // ✅ 로그인 성공 시 토큰 및 사용자 정보 저장
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', data['access_token']);
          await prefs.setString('username', user.username);
          await prefs.setString('email', user.email ?? '');
          await prefs.setString('phone', user.phone ?? '');
          await prefs.setString('role', user.role ?? '');

          print("✅ 로그인 성공: ${user.username}");
          return user;
        } else {
          print("❌ 로그인 응답에 user 필드 없음: ${response.body}");
        }
      } else {
        print("❌ 로그인 실패: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("❌ 로그인 중 오류 발생: $e");
    }
    return null;
  }

  /// ✅ 회원가입
  Future<UserModel?> signup(
      String username,
      String password,
      String email,
      String phone,
      String role,
      ) async {
    try {
      // ✅ FastAPI는 /auth/signup/ 로 끝나므로 반드시 슬래시 포함
      final url = Uri.parse(ApiService.endpoint('/auth/signup/'));

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
          "phone": phone,
          "role": role,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("✅ 회원가입 성공: $data");
        return UserModel.fromJson(data);
      } else {
        print("❌ 회원가입 실패: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("❌ 회원가입 중 오류 발생: $e");
    }
    return null;
  }

  /// ✅ 로그아웃 (토큰 삭제)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ✨ 전체 초기화
    print("👋 로그아웃 완료 (로컬 데이터 초기화)");
  }

  /// ✅ 자동 로그인 시 토큰 불러오기
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// ✅ 저장된 사용자 정보 불러오기 (자동 로그인용)
  Future<UserModel?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      if (username == null) return null;

      return UserModel(
        id: 0, // 로컬 저장용
        username: username,
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? '',
        role: prefs.getString('role') ?? '',
      );
    } catch (e) {
      print("❌ 로컬 사용자 불러오기 실패: $e");
      return null;
    }
  }

  /// ✅ 프로필 수정 (아이디, 이메일, 전화번호, 비밀번호, 역할 변경 가능)
  Future<bool> updateProfile({
    required String username,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        print("⚠️ 수정 실패: 토큰이 없습니다.");
        return false;
      }

      // ✅ FastAPI는 /auth/me/ 로 끝나므로 반드시 슬래시 포함
      final url = Uri.parse(ApiService.endpoint('/auth/me/'));

      final body = jsonEncode({
        "username": username,
        "email": email,
        "phone": phone,
        "role": role,
        "password": password.isEmpty ? null : password,
      });

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
        await prefs.setString('role', role);

        print("✅ 프로필 수정 성공 및 로컬 반영");
        return true;
      } else {
        print("❌ 프로필 수정 실패: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ 프로필 수정 중 오류: $e");
      return false;
    }
  }

  /// ✅ 계정 삭제
  Future<bool> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        print("⚠️ 계정 삭제 실패: 토큰이 없습니다.");
        return false;
      }

      // ✅ FastAPI는 /auth/me/ 로 끝나므로 반드시 슬래시 포함
      final url = Uri.parse(ApiService.endpoint('/auth/me/'));
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        print("✅ 계정 삭제 성공 및 로컬 데이터 초기화");
        return true;
      } else {
        print("❌ 계정 삭제 실패: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ 계정 삭제 중 오류: $e");
      return false;
    }
  }
}
