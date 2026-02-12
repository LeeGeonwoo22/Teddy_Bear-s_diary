import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teddyBear/features/settings/repository/settingRepository.dart';
import 'package:teddyBear/features/settings/widgets/setting_dialog.dart';
import 'package:teddyBear/features/settings/widgets/setting_picker.dart';
import 'package:teddyBear/features/settings/widgets/setting_ui_helper.dart';
import '../../core/common/dateFormatter.dart';
import '../../data/model/settings.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings? _settings; // ← late 제거, nullable로
  bool _isLoading = true; // ← 로딩 상태 추가

  // final chatRepository = ChatRepository(remote: remote, local: local, authRepository: authRepository)
  // final diaryRepository = DiaryRepository(remote: remote, local: local, chatRepository: chatRepository);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isLoading = true;
    });

    final loaded = SettingRepository.getSettings();

    setState(() {
      _settings = loaded ?? Settings(); // ← null이면 기본값 생성
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 로딩 중이면 스피너 표시
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('⚙️ 설정')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final isGuest = authState.isGuest;

        return Scaffold(
          appBar: AppBar(
            title: Text('⚙️ 설정'),
          ),
          body: ListView(
            children: [
        // 일기 설정
              SettingUiHelper.buildSectionHeader('📅 일기 설정'),

              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('자동 생성 시간'),
                subtitle: Text('매일 ${_settings?.diaryCreationHour}시에 일기 생성'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => SettingPicker.showHourPicker(context: context, settings: _settings, onSettingsChanged: _loadSettings),
              ),

              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('일기 길이'),
                subtitle: Text(SettingUiHelper.getDiaryLengthText(_settings?.diaryLength ?? 0)),
                trailing: Icon(Icons.chevron_right),
                onTap: () => SettingPicker.showLengthPicker(context: context, settings: _settings, onSettingsChanged: _loadSettings),
              ),

              Divider(),

         // 알림 설정
              SettingUiHelper.buildSectionHeader('🔔 알림'),

              SwitchListTile(
                secondary: Icon(Icons.notifications),
                title: Text('일기 생성 알림'),
                subtitle: Text('일기가 완성되면 알려드려요'),
                value: _settings?.notificationEnabled ?? false,
                onChanged: (value) async {
                  // await SettingsManager.setNotificationEnabled(value);
                  // _loadSettings();
                },
              ),

              SwitchListTile(
                secondary: Icon(Icons.chat_bubble_outline),
                title: Text('대화 리마인더'),
                subtitle: Text('곰돌이와 대화하지 않은 날 알림'),
                value: _settings?.chatReminderEnabled ?? false,
                onChanged: (value) async {
                  // await SettingsManager.setNotificationEnabled(value);
                  // _loadSettings();
                },
              ),

              Divider(),

              // 🎨 테마 설정
              SettingUiHelper.buildSectionHeader('🎨 테마'),

              ListTile(
                leading: Icon(Icons.palette),
                title: Text('테마 모드'),
                subtitle: Text(SettingUiHelper.getThemeText(_settings?.theme ?? 'light')),
                trailing: Icon(Icons.chevron_right),
                onTap: () => SettingPicker.showThemePicker(context: context, settings: _settings, onSettingsChanged: _loadSettings),
              ),

              Divider(),

              // 💾 데이터 관리
              SettingUiHelper.buildSectionHeader('💾 데이터 관리'),

              ListTile(
                leading: Icon(Icons.backup, color: Colors.blue),
                title: Text('데이터 백업'),
                subtitle: _settings?.lastBackupDate != null
                    ? Text('마지막 백업: ${DateFormatter.formatDate(_settings?.lastBackupDate! ?? DateTime.now())}')
                    : Text('아직 백업하지 않았어요'),
                onTap: () => SettingDialog.showBackupDialog(context: context),
              ),

              ListTile(
                leading: Icon(Icons.refresh, color: Colors.orange),
                title: Text('대화 내용 리셋'),
                subtitle: Text('일기는 유지되고 대화만 삭제돼요'),
                onTap: () => SettingDialog.showResetChatDialog(context: context),
              ),

              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('전체 초기화'),
                subtitle: Text('대화 + 일기 모두 삭제'),
                onTap: () => SettingDialog.showResetAllDialog(context: context),
              ),

              Divider(),

              // 👤 계정 관리

              SettingUiHelper.buildSectionHeader('👤 계정'),

              if (isGuest)
                ListTile(
                  leading: const Icon(
                    Icons.login_rounded,
                    color: Color(0xFF4CAF50),
                  ),
                  title: const Text('소셜 로그인 연동'),
                  onTap: () {
                    context.read<AuthBloc>().add(LoginWithGoogle());
                  },
                ),

              ListTile(
                leading: Icon(Icons.logout, color: Colors.grey),
                title: Text('로그아웃'),
                onTap: () => SettingDialog.showLogoutDialog(context: context),
              ),

              ListTile(
                leading: Icon(Icons.person_remove, color: Colors.red),
                title: Text('회원 탈퇴'),
                onTap: () => SettingDialog.showDeleteAccountDialog(context: context),
              ),

              SizedBox(height: 24),

              // ℹ️ 앱 정보
              Center(
                child: Column(
                  children: [
                    Text(
                      'Teddy Bear Diary',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        );
      }
    );
  }
}