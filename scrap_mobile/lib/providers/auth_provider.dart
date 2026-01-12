import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// ✅ 기존 user -> currentUser 호환성 유지
  UserModel? get user => _currentUser; // ✅ ProfileScreen, DashboardScreen에서 사용 가능
  UserModel? get currentUser => _currentUser;

  /// ✅ 로그인
  Future<bool> login(String username, String password) async {
    try {
      final user = await _authService.login(username, password);
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ 로그인 중 오류: $e');
      return false;
    }
  }

  /// ✅ 로그아웃
  Future<void> logout() async {
    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ 로그아웃 중 오류: $e');
    }
  }

  /// ✅ 자동 로그인
  Future<bool> tryAutoLogin() async {
    try {
      final token = await _authService.getSavedToken();
      if (token == null || token.isEmpty) return false;

      final savedUser = await _authService.getSavedUser();
      if (savedUser == null) return false;

      _currentUser = savedUser;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ 자동 로그인 실패: $e');
      return false;
    }
  }

  /// ✅ 프로필 수정 (AuthService 호출)
  Future<bool> updateProfile({
    required String username,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    final success = await _authService.updateProfile(
      username: username,
      email: email,
      phone: phone,
      role: role,
      password: password,
    );

    if (success) {
      await refreshUser(); // ✅ 수정 후 로컬 정보 갱신
    }
    return success;
  }

  /// ✅ 계정 삭제
  Future<bool> deleteAccount() async {
    final success = await _authService.deleteAccount();
    if (success) {
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    }
    return success;
  }

  /// ✅ 사용자 정보 새로고침
  Future<void> refreshUser() async {
    final savedUser = await _authService.getSavedUser();
    _currentUser = savedUser;
    notifyListeners();
  }
}
