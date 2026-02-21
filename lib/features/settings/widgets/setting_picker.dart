import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/settings.dart';
import '../bloc/setting_bloc.dart';
import '../bloc/setting_event.dart';

class SettingPicker {

  // 시간 선택 - 22시, 23시, 23시30분 옵션
  static Future<void> showHourPicker({
    required BuildContext context,
  }) async {
    final options = [
      {'label': '22시', 'value': 22},
      {'label': '23시', 'value': 23},
      {'label': '23시 30분', 'value': 2330},  // 30분은 별도 값으로 구분
    ];

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentHour = context.read<SettingBloc>().state.diaryCreationHour;
        return Container(
          height: 200,
          child: ListView(
            children: options.map((option) {
              final isSelected = currentHour == option['value'];
              return ListTile(
                leading: Icon(Icons.access_time,
                    color: isSelected ? Colors.blue : Colors.grey),
                title: Text(option['label'] as String,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    )),
                trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  context.read<SettingBloc>().add(
                    ChangeDiaryCreationHour(option['value'] as int),
                  );
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // 일기 길이 선택
  static Future<void> showLengthPicker({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        final currentLength = context.read<SettingBloc>().state.diaryLength;
        return AlertDialog(
          title: Text('일기 길이 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                title: Text('짧게 (약 300자)'),
                value: 300,
                groupValue: currentLength,
                onChanged: (value) {
                  context.read<SettingBloc>().add(ChangeDiaryLength(value!));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<int>(
                title: Text('보통 (약 500자)'),
                value: 500,
                groupValue: currentLength,
                onChanged: (value) {
                  context.read<SettingBloc>().add(ChangeDiaryLength(value!));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<int>(
                title: Text('길게 (약 800자)'),
                value: 800,
                groupValue: currentLength,
                onChanged: (value) {
                  context.read<SettingBloc>().add(ChangeDiaryLength(value!));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}