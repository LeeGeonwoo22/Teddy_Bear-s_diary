import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import 'package:teddyBear/features/settings/bloc/setting_event.dart';
import 'package:teddyBear/features/settings/bloc/setting_state.dart';
import 'package:teddyBear/features/settings/repository/settingRepository.dart';
import 'package:flutter/material.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository _settingRepository;
  final ChatRepository _chatRepository;

  SettingBloc(
       {
         required SettingRepository settingRepository,
         required ChatRepository chatRepository,
       })
      : _settingRepository = settingRepository,
        _chatRepository = chatRepository, super(SettingState.initial()) {

    on<LoadSettings>(_LoadSettings);
    on<ChangeDiaryLength>(_ChangeDiaryLength);
    on<ChangeDiaryCreationHour>(_ChangeDiaryCreationHour);
    on<ToggleNotification>(_ToggleNotification);
    on<ToggleChatReminder>(_ToggleChatReminder);
    on<ChangeThemeMode>(_ChangeThemeMode);
    on<ExportAllChatsToTxt>(_ExportAllChatsToTxt);
  }

  // ✅ 1. 설정 불러오기
  Future<void> _LoadSettings(
      LoadSettings event,
      Emitter<SettingState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final settings = _settingRepository.loadSettings();

      final themeMode = ThemeMode.values.firstWhere(
            (e) => e.name == settings.theme,
        orElse: () => ThemeMode.system,
      );

      emit(state.copyWith(
        diaryLength: settings.diaryLength,
        diaryCreationHour: settings.diaryCreationHour,
        notificationEnabled: settings.notificationEnabled,
        chatReminderEnabled: settings.chatReminderEnabled,
        themeMode: themeMode,
        lastBackupDate: settings.lastBackupDate,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // ✅ 2. 일기 길이 변경
  Future<void> _ChangeDiaryLength(
      ChangeDiaryLength event,
      Emitter<SettingState> emit,
      ) async {
    await _settingRepository.saveDiaryLength(event.length);

    emit(state.copyWith(
      diaryLength: event.length,
    ));
  }

  // ✅ 3. 일기 생성 시간 변경
  Future<void> _ChangeDiaryCreationHour(
      ChangeDiaryCreationHour event,
      Emitter<SettingState> emit,
      ) async {
    await _settingRepository.saveDiaryCreationHour(event.hour);

    emit(state.copyWith(
      diaryCreationHour: event.hour,
    ));
  }

  // ✅ 4. 알림 토글
  Future<void> _ToggleNotification(
      ToggleNotification event,
      Emitter<SettingState> emit,
      ) async {
    await _settingRepository.saveNotification(event.enabled);

    emit(state.copyWith(
      notificationEnabled: event.enabled,
    ));
  }

  // ✅ 5. 채팅 리마인더 토글
  Future<void> _ToggleChatReminder(
      ToggleChatReminder event,
      Emitter<SettingState> emit,
      ) async {
    await _settingRepository.saveChatReminder(event.enabled);

    emit(state.copyWith(
      chatReminderEnabled: event.enabled,
    ));
  }

  // ✅ 6. 테마 변경
  Future<void> _ChangeThemeMode(
      ChangeThemeMode event,
      Emitter<SettingState> emit,
      ) async {

    emit(state.copyWith(themeMode: event.themeMode));

    final themeString = event.themeMode.name;
    // light / dark / system

    await _settingRepository.saveTheme(themeString);
  }

  // ✅ 7. 전체 채팅 TXT 백업
  Future<void> _ExportAllChatsToTxt(
      ExportAllChatsToTxt event,
      Emitter<SettingState> emit,
      ) async {
    print('채팅 백업 시작...');

    try {
      await _chatRepository.exportAllChatsToTxt();

      emit(state.copyWith(
        lastBackupDate: DateTime.now(),
      ));

      print('채팅 백업 완료');
    } catch (e) {
      print('채팅 백업 실패: $e');
    }
  }
}