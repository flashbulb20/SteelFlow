import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import 'login_screen.dart';

/// 회원가입 화면
/// 사용자가 아이디, 비밀번호, 이메일, 전화번호, 역할(role)을 입력하여 회원가입을 수행함
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ✅ 입력 필드 컨트롤러
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _role = TextEditingController();

  bool _loading = false; // 로딩 상태 표시용

  /// ✅ 회원가입 처리 함수
  Future<void> _handleSignup() async {
    setState(() => _loading = true);

    final authService = AuthService(); // AuthService 직접 사용
    final user = await authService.signup(
      _username.text.trim(),
      _password.text.trim(),
      _email.text.trim(),
      _phone.text.trim(),
      _role.text.trim().isEmpty ? "user" : _role.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (user != null) {
      // ✅ 회원가입 성공 시 로그인 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 성공! 로그인 해주세요.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // ❌ 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 실패. 입력 정보를 확인하세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // ✅ 아이디 입력
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                labelText: "아이디",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ 비밀번호 입력
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ 이메일 입력
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ 전화번호 입력
            TextField(
              controller: _phone,
              decoration: const InputDecoration(
                labelText: "전화번호",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ 역할 입력
            TextField(
              controller: _role,
              decoration: const InputDecoration(
                labelText: "역할 (예: user, admin)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ 회원가입 버튼
            _loading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
              text: "회원가입",
              onPressed: _handleSignup,
            ),
            const SizedBox(height: 20),

            // ✅ 이미 계정이 있을 경우 로그인 화면으로 돌아가기
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("이미 계정이 있으신가요? 로그인하기"),
            ),
          ],
        ),
      ),
    );
  }
}
