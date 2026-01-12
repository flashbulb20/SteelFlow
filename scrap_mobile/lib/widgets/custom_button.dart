import 'package:flutter/material.dart';

/// 앱 전역에서 사용할 공통 버튼 위젯
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
      ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
