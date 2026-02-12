import 'package:flutter/material.dart';

import '../../../data/model/settings.dart';

class SettingPicker {
  // 시간 선택 다이얼로그
  static Future<void> showHourPicker({
    required BuildContext context,
    required Settings? settings,
    required VoidCallback onSettingsChanged,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: ListView.builder(
          itemCount: 24,
          itemBuilder: (context, hour) {
            final isSelected = hour == settings?.diaryCreationHour;
            return ListTile(
              leading: Icon(
                Icons.access_time,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              title: Text(
                '${hour}시',
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
              onTap: () async {
                // await SettingsManager.setDiaryCreationHour(hour);
                onSettingsChanged(); // 설정 변경 후 콜백 호출
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  // 일기 길이 선택 다이얼로그
  static Future<void> showLengthPicker({
    required BuildContext context,
    required Settings? settings,
    required VoidCallback onSettingsChanged,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('일기 길이 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: Text('짧게 (약 200자)'),
              value: 0,
              groupValue: settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                onSettingsChanged();
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: Text('보통 (약 300자)'),
              value: 1,
              groupValue: settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                onSettingsChanged();
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: Text('길게 (약 500자)'),
              value: 2,
              groupValue: settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                onSettingsChanged();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 테마 선택 다이얼로그
  static Future<void> showThemePicker({
    required BuildContext context,
    required Settings? settings,
    required VoidCallback onSettingsChanged,
  }) async {
    // TODO: 테마 선택 다이얼로그 구현
  }
}