import 'package:flutter/material.dart';
import '../../../data/model/message.dart';
import 'DateHeaders.dart';
import 'messageCard.dart';

/// 날짜별로 헤더를 붙이고, 메시지를 하이라이트 처리하여 반환
class ChatHelpers {
  static List<Widget> buildMessagesWithDateHeaders({
    required List<Message> messages,
    required String searchQuery,
  }) {
    final widgets = <Widget>[];
    String? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = _formatDate(message.timestamp);

      // 날짜가 바뀌면 DateHeaders 추가
      if (lastDate != messageDate) {
        widgets.add(DateHeaders(dateText: messageDate));  // ✅ 여기서 사용!
        lastDate = messageDate;
      }

      // 메시지 추가 (검색어 하이라이트)
      widgets.add(_buildMessageWithHighlight(message, searchQuery));
    }
    return widgets;
  }

  /// 검색어가 포함된 메시지에 배경 하이라이트 처리
  static Widget _buildMessageWithHighlight(Message message, dynamic searchQuery) {
    if (searchQuery.isEmpty) {
      return MessageCard(message: message);
    }

    return Container(
      decoration: message.msg.toLowerCase().contains(searchQuery)
          ? BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      )
          : null,
      child: MessageCard(message: message),
    );
  }

// 날짜 포맷
  static String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDay == today) {
      return '오늘';
    } else if (messageDay == yesterday) {
      return '어제';
    } else if (now.year == dateTime.year) {
      return '${dateTime.month}월 ${dateTime.day}일';
    } else {
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    }
  }
}

