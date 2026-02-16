import 'package:flutter/material.dart';

class SettingDialog {
  // ✅ bool 반환하도록 수정
  static Future<bool> showResetChatDialog({
    required BuildContext context,
  }) async {
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
                                      
    return confirmed ?? false; // ✅ 결과 반환
  }

  static Future<bool> showResetAllDialog({
    required BuildContext context,
  }) async {
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

    return confirmed ?? false; // ✅ 결과 반환
  }

  // ✅ context 추가
  static Future<bool> showLogoutDialog({
    required BuildContext context,
  }) async {
    // TODO: 로그아웃 기능
    return false;
  }

  static Future<bool> showDeleteAccountDialog({
    required BuildContext context,
  }) async {
    // TODO: 회원 탈퇴 기능
    return false;
  }

  static Future<void> showBackupDialog({
    required BuildContext context,
  }) async {
    // TODO: 백업 기능 (확인 필요 없으면 void 가능)
  }
}