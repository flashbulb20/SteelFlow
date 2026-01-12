// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// dotenv 를 테스트에서 미리 로드해야 AuthService 등에서 dotenv.env[...] 사용 시 에러가 나지 않습니다.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <<< 수정됨: dotenv import 추가

import 'package:scrap_mobile/main.dart'; // ScrapMobileApp 클래스가 정의된 파일 import

void main() {
  testWidgets('로그인 화면 렌더링 테스트', (WidgetTester tester) async {
    // .env 파일을 미리 로드합니다. (AuthService / ApiService가 dotenv를 참조하기 때문)
    // 프로젝트 루트에 .env 파일이 있어야 합니다.
    await dotenv.load(fileName: ".env"); // <<< 수정됨: dotenv 로드 추가

    // Build our app and trigger a frame.
    // 기존: await tester.pumpWidget(const MyApp());
    // 수정: main.dart의 앱 클래스 이름에 맞춰 ScrapMobileApp을 사용합니다.
    await tester.pumpWidget(const ScrapMobileApp()); // <<< 수정됨: MyApp -> ScrapMobileApp

    // 애니메이션/프레임 안정화를 위해 추가로 대기
    await tester.pumpAndSettle(); // <<< 수정됨: 안정화 호출 추가

    // 원래 템플릿은 카운터를 검사했지만, 우리 앱 구조에 맞춰 로그인 화면 요소를 검사합니다.
    // AppBar의 제목 '로그인' 이 보이는지 확인
    expect(find.text('로그인'), findsOneWidget); // <<< 수정됨: 검사 내용 변경
    // 로그인 화면의 입력 라벨들이 존재하는지 확인 (아이디, 비밀번호)
    expect(find.text('아이디'), findsOneWidget); // <<< 추가된 검사
    expect(find.text('비밀번호'), findsOneWidget); // <<< 추가된 검사
  });
}

