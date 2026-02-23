import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingEvent extends Equatable{
  const SettingEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingEvent {}

// 일기 글자
class ChangeDiaryLength extends SettingEvent {
  final int length;
  const ChangeDiaryLength(this.length);
}
// 일기 시간
class ChangeDiaryCreationHour extends SettingEvent {
  final int hour;
  const ChangeDiaryCreationHour(this.hour);
}
// 알림 토글
class ToggleNotification extends SettingEvent {
  final bool enabled;
  const ToggleNotification(this.enabled);
}
// 알림 리마인도 토글
class ToggleChatReminder extends SettingEvent {
  final bool enabled;
  const ToggleChatReminder(this.enabled);
}
// 테마 토글
class ChangeThemeMode extends SettingEvent {
  final ThemeMode themeMode;
  const ChangeThemeMode(this.themeMode);
}

class ExportAllChatsToTxt extends SettingEvent {}


