import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../chat/bloc/chat_bloc.dart';
import '../../chat/bloc/chat_event.dart';
import '../../diary/bloc/diary_bloc.dart';
import '../../diary/bloc/diary_event.dart';

class SettingDialog {
  // ✅ bool 반환하도록 수정
  static Future<void> showResetChatDialog({
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
            onPressed: () => Navigator.pop(context, true),  // ✅ 확인만
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ChatBloc>().add(DeleteAllMessages());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('대화 내용이 삭제되었어요'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }


  static Future<void> showResetAllDialog({
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
            onPressed: () => Navigator.pop(context, true),  // ✅ 확인만
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('전체 삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ChatBloc>().add(DeleteAllMessages());
      context.read<DiaryBloc>().add(DeleteAllDiaries());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('모든 데이터가 초기화되었어요'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> showLogoutDialog({
    required BuildContext context,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃 하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 되었어요')),
      );
      context.read<AuthBloc>().add(LogoutRequested());
      context.go('/login');
    }
  }

  static Future<void> showDeleteAccountDialog({
    required BuildContext context,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ 회원 탈퇴'),
        content: Text('탈퇴 시 모든 데이터가 영구 삭제됩니다.\n정말 탈퇴하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('탈퇴'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(DeleteAccount());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('탈퇴가 완료되었어요'),
          backgroundColor: Colors.red,
        ),
      );
      context.go('/login');
    }
  }
}