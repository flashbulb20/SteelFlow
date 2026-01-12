import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart'; // ✅ 유지됨

/// 사용자 프로필 화면 (아이디, 이메일, 전화번호, 비밀번호, 역할 수정 및 계정 삭제 가능)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ✨ 추가된 컨트롤러들
  late TextEditingController _usernameController; // ✅ 아이디 수정용
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController; // ✅ 비밀번호 수정용
  late TextEditingController _roleController; // ✅ 역할 수정용

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    // ✅ 기존 필드 + 새 필드 초기화
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _roleController = TextEditingController(text: user?.role ?? '');
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( // ✅ 스크롤 가능하게 변경
          child: Column(
            children: [
              // ✨ 추가된 입력 필드들
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '아이디'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '전화번호'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: '역할'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '새 비밀번호 (변경 시만 입력)'),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final success = await auth.updateProfile(
                    username: _usernameController.text, // ✅ 추가됨
                    email: _emailController.text,
                    phone: _phoneController.text,
                    role: _roleController.text, // ✅ 추가됨
                    password: _passwordController.text.isNotEmpty
                        ? _passwordController.text
                        : "", // ✅ 수정됨: null 대신 빈 문자열 전달
                  );

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("프로필이 수정되었습니다.")),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("프로필 수정 실패")),
                    );
                  }
                },
                child: const Text("프로필 수정"),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final success = await auth.deleteAccount();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("계정이 삭제되었습니다.")),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  }
                },
                child: const Text("계정 삭제"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
