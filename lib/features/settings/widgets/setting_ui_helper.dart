import 'package:flutter/material.dart';

class SettingUiHelper {

  // 🎨 UI 헬퍼
  static Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B6F47),
        ),
      ),
    );
  }

  static String getDiaryLengthText(int length) {
    switch (length) {
      case 300: return '짧게 (약 200자)';
      case 500: return '보통 (약 300자)';
      case 800: return '길게 (약 500자)';
      default:  return '보통 (약 300자)';
    }
  }

  static String formatHour(int value) {
    if (value == 2330) return '23시 30분';
    return '$value시';
  }

  static String getThemeText(String theme) {
    switch (theme) {
      case 'light':
        return '라이트 모드';
      case 'dark':
        return '다크 모드';
      case 'system':
        return '시스템 설정 따름';
      default:
        return '라이트 모드';
    }
  }
}