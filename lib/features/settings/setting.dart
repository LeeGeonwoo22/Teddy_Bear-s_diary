import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teddyBear/features/settings/widgets/setting_dialog.dart';
import 'package:teddyBear/features/settings/widgets/setting_picker.dart';

import 'package:teddyBear/features/settings/widgets/setting_ui_helper.dart';
import '../../core/common/dateFormatter.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import 'bloc/setting_bloc.dart';
import 'bloc/setting_event.dart';
import 'bloc/setting_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return  Scaffold(
            appBar: AppBar(title: Text('⚙️ 설정')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {

            final isGuest = authState.isGuest;

            return Scaffold(
              appBar: AppBar(title: const Text('⚙️ 설정')),
              body: ListView(
                children: [

                  // 📅 일기 설정
                  SettingUiHelper.buildSectionHeader('📅 일기 설정'),

                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('자동 생성 시간'),
                    subtitle: Text('매일 ${SettingUiHelper.formatHour(state.diaryCreationHour)}에 일기 생성'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      print('클릭');
                      SettingPicker.showHourPicker(context: context);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.text_fields),
                    title: const Text('일기 길이'),
                    subtitle: Text(
                        SettingUiHelper.getDiaryLengthText(state.diaryLength),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      print('클릭');
                      SettingPicker.showLengthPicker(context: context);
                    },
                  ),

                  const Divider(),

                  // 🔔 알림 설정
                  SettingUiHelper.buildSectionHeader('🔔 알림'),

                  SwitchListTile(
                    secondary: const Icon(Icons.notifications),
                    title: const Text('일기 생성 알림'),
                    subtitle: const Text('일기가 완성되면 알려드려요'),
                    value: state.notificationEnabled,
                    onChanged: (value) {
                      context.read<SettingBloc>().add(
                        ToggleNotification(value),
                      );
                    },
                  ),

                  SwitchListTile(
                    secondary: const Icon(Icons.chat_bubble_outline),
                    title: const Text('대화 리마인더'),
                    subtitle: const Text('곰돌이와 대화하지 않은 날 알림'),
                    value: state.chatReminderEnabled,
                    onChanged: (value) {
                      context.read<SettingBloc>().add(
                        ToggleChatReminder(value),
                      );
                    },
                  ),

                  const Divider(),

                  // 🎨 테마 설정
                  SettingUiHelper.buildSectionHeader('🎨 테마'),

                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('테마 모드'),
                    subtitle: Text(
                      SettingUiHelper.getThemeText(state.themeMode.name),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.read<SettingBloc>().add(
                        ChangeThemeMode(state.themeMode),
                      );
                    },
                  ),

                  const Divider(),

                  // 💾 데이터 관리
                  SettingUiHelper.buildSectionHeader('💾 데이터 관리'),

                  ListTile(
                    leading: const Icon(Icons.backup, color: Colors.blue),
                    title: const Text('데이터 백업'),
                    subtitle: state.lastBackupDate != null
                        ? Text(
                        '마지막 백업: ${DateFormatter.formatDate(state.lastBackupDate!)}')
                        : const Text('아직 백업하지 않았어요'),
                    onTap: () {
                      context.read<SettingBloc>().add(
                        ExportAllChatsToTxt(),
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.refresh, color: Colors.orange),
                    title: const Text('대화 내용 리셋'),
                    subtitle: const Text('일기는 유지되고 대화만 삭제돼요'),
                    onTap: () => SettingDialog.showResetChatDialog(context: context),
                  ),

                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('전체 초기화'),
                    subtitle: const Text('대화 + 일기 모두 삭제'),
                    onTap: () => SettingDialog.showResetAllDialog(context: context),
                  ),

                  const Divider(),

                  // 👤 계정
                  SettingUiHelper.buildSectionHeader('👤 계정'),

                  if (isGuest)
                    ListTile(
                      leading: const Icon(Icons.login_rounded, color: Color(0xFF4CAF50)),
                      title: const Text('소셜 로그인 연동'),
                      onTap: () {
                        context.read<AuthBloc>().add(LoginWithGoogle());
                      },
                    ),
                  if (!isGuest) ...[
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.grey),
                      title: const Text('로그아웃'),
                      onTap: () => SettingDialog.showLogoutDialog(context: context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_remove, color: Colors.red),
                      title: const Text('회원 탈퇴'),
                      onTap: () => SettingDialog.showDeleteAccountDialog(context: context),
                    ),
                  ],

                  const SizedBox(height: 24),

                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Teddy Bear Diary',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}