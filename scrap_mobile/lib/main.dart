// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ 환경 변수 로드용
import 'providers/auth_provider.dart';
import 'providers/volume_provider.dart';
import 'providers/transaction_provider.dart'; // ✅ 거래내역 Provider 추가
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


Future<void> main() async {
  /// ✅ 필수 초기화
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  /// ✅ .env 환경변수 로드
  await dotenv.load(fileName: ".env");

  /// ✅ 상단 상태바 투명화
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VolumeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()), // ✅ 추가
      ],
      child: const ScrapMobileApp(),
    ),
  );

  // ✅ 2초간 스플래시 유지 후 제거
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
}

/// 앱 전체 루트 위젯
class ScrapMobileApp extends StatefulWidget {
  const ScrapMobileApp({super.key});

  @override
  State<ScrapMobileApp> createState() => _ScrapMobileAppState();
}

class _ScrapMobileAppState extends State<ScrapMobileApp> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  /// ✅ SharedPreferences 기반 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final result = await authProvider.tryAutoLogin();
      setState(() {
        _isAuthenticated = result;
        _isLoading = false;
      });
    } catch (e) {
      // 무해한 로그만 출력 (기존 기능 영향 X)
      debugPrint("❌ 자동 로그인 중 오류: $e");
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrap Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: _isLoading
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : _isAuthenticated
          ? const DashboardScreen() // ✅ 로그인 성공 → 대시보드
          : const LoginScreen(), // ❌ 로그인 실패 → 로그인 화면
    );
  }
}
