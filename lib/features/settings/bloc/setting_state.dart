import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingState extends Equatable{
  final int diaryLength;
  final int diaryCreationHour;
  final bool notificationEnabled;
  final bool chatReminderEnabled;
  final ThemeMode themeMode;
  final DateTime? lastBackupDate;
  final bool isLoading;
  final String? errorMessage;

  const SettingState({
    this.diaryLength = 300,
    this.diaryCreationHour = 23,
    this.notificationEnabled = false,
    this.chatReminderEnabled = false,
    required this.themeMode,
    this.lastBackupDate,
    this.isLoading = false,
    this.errorMessage
  });

  factory SettingState.initial() {
    return SettingState(
      themeMode: ThemeMode.light,
      isLoading: true,
    );
  }

  SettingState copyWith({
    int? diaryLength,
    int? diaryCreationHour,
    bool? notificationEnabled,
    bool? chatReminderEnabled,
    ThemeMode? themeMode,
    DateTime? lastBackupDate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingState(
      diaryLength: diaryLength ?? this.diaryLength,
      diaryCreationHour: diaryCreationHour ?? this.diaryCreationHour,
      notificationEnabled:
      notificationEnabled ?? this.notificationEnabled,
      chatReminderEnabled:
      chatReminderEnabled ?? this.chatReminderEnabled,
      themeMode: themeMode ?? this.themeMode,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [  diaryLength,
    diaryCreationHour,
    notificationEnabled,
    chatReminderEnabled,
    themeMode,
    lastBackupDate,
    isLoading,
  ];
}