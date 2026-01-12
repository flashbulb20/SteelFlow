import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import 'signup_screen.dart'; // ✅ 회원가입 화면 import 추가
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAutoLogin = false; // ✅ 자동로그인 체크박스 상태
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: '아이디'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // ✅ 자동 로그인 체크박스
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isAutoLogin,
                  onChanged: (value) {
                    setState(() {
                      _isAutoLogin = value ?? false;
                    });
                  },
                ),
                const Text('자동 로그인'),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                setState(() => _isLoading = true);
                final success = await authProvider.login(
                  _usernameController.text,
                  _passwordController.text,
                );

                setState(() => _isLoading = false);

                if (success && context.mounted) {
                  // ✅ 자동 로그인 상태 저장
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('auto_login', _isAutoLogin);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DashboardScreen()),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인 실패')),
                  );
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('로그인'),
            ),

            const SizedBox(height: 15),

            // ✅ 회원가입 버튼 추가
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text(
                "회원가입",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
