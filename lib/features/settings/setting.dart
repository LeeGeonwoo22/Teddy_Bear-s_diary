// screens/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import 'package:teddyBear/features/diary/repository/diaryRepository.dart';
import 'package:teddyBear/features/settings/repository/settingRepository.dart';
import '../../data/model/settings.dart';
import '../../main.dart'; // Repository 접근

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

    final loaded = Settingrepository.getSettings();

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

    return Scaffold(
      appBar: AppBar(
        title: Text('⚙️ 설정'),
      ),
      body: ListView(
        children: [
          // ========================================
          // 📅 일기 설정
          // ========================================
          _buildSectionHeader('📅 일기 설정'),

          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('자동 생성 시간'),
            subtitle: Text('매일 ${_settings?.diaryCreationHour}시에 일기 생성'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showHourPicker(),
          ),

          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('일기 길이'),
            subtitle: Text(_getDiaryLengthText(_settings?.diaryLength ?? 0)),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showLengthPicker(),
          ),

          Divider(),

          // ========================================
          // 🔔 알림 설정
          // ========================================
          _buildSectionHeader('🔔 알림'),

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

          // ========================================
          // 🎨 테마 설정
          // ========================================
          _buildSectionHeader('🎨 테마'),

          ListTile(
            leading: Icon(Icons.palette),
            title: Text('테마 모드'),
            subtitle: Text(_getThemeText(_settings?.theme ?? 'light')),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(),
          ),

          Divider(),

          // ========================================
          // 💾 데이터 관리
          // ========================================
          _buildSectionHeader('💾 데이터 관리'),

          ListTile(
            leading: Icon(Icons.backup, color: Colors.blue),
            title: Text('데이터 백업'),
            subtitle: _settings?.lastBackupDate != null
                ? Text('마지막 백업: ${_formatDate(_settings?.lastBackupDate! ?? DateTime.now())}')
                : Text('아직 백업하지 않았어요'),
            onTap: () => _showBackupDialog(),
          ),

          ListTile(
            leading: Icon(Icons.refresh, color: Colors.orange),
            title: Text('대화 내용 리셋'),
            subtitle: Text('일기는 유지되고 대화만 삭제돼요'),
            onTap: () => _showResetChatDialog(),
          ),

          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text('전체 초기화'),
            subtitle: Text('대화 + 일기 모두 삭제'),
            onTap: () => _showResetAllDialog(),
          ),

          Divider(),

          // ========================================
          // 👤 계정 관리
          // ========================================
          _buildSectionHeader('👤 계정'),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text('로그아웃'),
            onTap: () => _showLogoutDialog(),
          ),

          ListTile(
            leading: Icon(Icons.person_remove, color: Colors.red),
            title: Text('회원 탈퇴'),
            onTap: () => _showDeleteAccountDialog(),
          ),

          SizedBox(height: 24),

          // ========================================
          // ℹ️ 앱 정보
          // ========================================
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

  // ========================================
  // 🎨 UI 헬퍼
  // ========================================

  Widget _buildSectionHeader(String title) {
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

  String _getDiaryLengthText(int length) {
    switch (length) {
      case 0:
        return '짧게 (약 200자)';
      case 1:
        return '보통 (약 300자)';
      case 2:
        return '길게 (약 500자)';
      default:
        return '보통';
    }
  }

  String _getThemeText(String theme) {
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

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month}.${date.day}';
  }

  // ========================================
  // 🎯 다이얼로그
  // ========================================

  Future<void> _showHourPicker() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: ListView.builder(
          itemCount: 24,
          itemBuilder: (context, hour) {
            final isSelected = hour == _settings?.diaryCreationHour;
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
                // _loadSettings();
                // Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showLengthPicker() async {
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
              groupValue: _settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                // _loadSettings();
                // Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: Text('보통 (약 300자)'),
              value: 1,
              groupValue: _settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                // _loadSettings();
                // Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: Text('길게 (약 500자)'),
              value: 2,
              groupValue: _settings?.diaryLength,
              onChanged: (value) async {
                // await SettingsManager.setDiaryLength(value!);
                // _loadSettings();
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showThemePicker() async {
    // TODO: 테마 선택 다이얼로그
  }

  Future<void> _showBackupDialog() async {
    // TODO: 백업 기능
  }

  Future<void> _showResetChatDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ 대화 내용 리셋'),
        content: Text('모든 대화 내용이 삭제됩니다.\n일기는 유지됩니다.\n\n정말 진행하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    // if (confirmed == true) {
    //   await chatRepository.clearAllMessages();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('✅ 대화 내용이 삭제되었어요')),
    //   );
    // }
  }

  Future<void> _showResetAllDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ 전체 초기화'),
        content: Text('대화 + 일기가 모두 삭제됩니다.\n이 작업은 되돌릴 수 없어요!\n\n정말 진행하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('전체 삭제'),
          ),
        ],
      ),
    );

    // if (confirmed == true) {
    //   await chatRepository.clearAllMessages();
    //   await diaryRepository.clearAllDiaries();
    //   await SettingsManager.resetSettings();
    //
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('✅ 모든 데이터가 삭제되었어요')),
    //   );
    // }
  }

  Future<void> _showLogoutDialog() async {
    // TODO: 로그아웃 기능
  }

  Future<void> _showDeleteAccountDialog() async {
    // TODO: 회원 탈퇴 기능
  }
}