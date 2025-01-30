import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blueGrey, // 메인 색상
      secondary: Colors.teal, // 보조 색상
      surface: Colors.grey[100]!, // 배경 및 UI 표면 색상
      error: Colors.redAccent, // 오류 색상
      onPrimary: Colors.white, // 주 색상의 텍스트 색상
      onSecondary: Colors.white, // 보조 색상의 텍스트 색상
      onSurface: Colors.black, // UI 표면 위 텍스트
      onError: Colors.white, // 오류 텍스트
    ),
    scaffoldBackgroundColor: Colors.grey[100], // 전체 배경색
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal, // 앱바 색상
      foregroundColor: Colors.white, // 앱바 텍스트 및 아이콘
      elevation: 4,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal, // 플로팅 버튼 색상
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.blueGrey,
      surface: Colors.grey[850]!, // 다크 테마 배경 및 UI 표면 색상
      error: Colors.redAccent,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[900],
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    ),
  );
}
