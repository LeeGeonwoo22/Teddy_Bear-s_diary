import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'appString.dart';
import 'global.dart';
import '../../data/model/message.dart';

class AIService {
  final http.Client _client;
  AIService(this._client);

  Future<String> _buildSystemPrompt(String configPath) async {
    final jsonString = await rootBundle.loadString(configPath);
    final fileList = jsonDecode(jsonString)['files'];

    StringBuffer promptBuffer = StringBuffer();
    promptBuffer.writeln("### [SYSTEM RULE: Your Core Identity] ###");

    for (final filename in fileList) {
      final content = await rootBundle.loadString('assets/prompts/$filename');
      if (filename.contains('core')) {
        promptBuffer.writeln("\n[CORE IDENTITY - Never forget this]\n$content");
      } else {
        promptBuffer.writeln("\n[CONTEXTUAL RULE]\n$content");
      }
    }

    promptBuffer.writeln("\n### [FINAL INSTRUCTION] ###");
    promptBuffer.writeln("Maintain all the identity above, but always match the 'temperature' and 'pace' of the user's last message.");
    promptBuffer.writeln("Always respond in the same language the user is currently using.");

    return promptBuffer.toString();
  }

  // 문장 대답
  Future<String> fetchAnswer(List<Message> history) async {
    try {
      final systemPrompt = await _buildSystemPrompt('assets/prompts/chat.json');

      // 최근 20개만 사용 (10번 대화 왕복)
      final recentHistory = history.length > 25
          ? history.sublist(history.length - 25)
          : history;

      // 히스토리 → GPT 형식 변환
      final historyMessages = recentHistory.map((m) => {
        "role": m.msgType == MessageType.user ? "user" : "assistant",
        "content": m.msg,
      }).toList();

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $OPENAI_APIKEY"
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "max_tokens": 300,
          "temperature": 0.7,
          "presence_penalty": 0.0,
          "frequency_penalty": 0.3,
          "messages": [
            {"role": "system", "content": systemPrompt},
            ...historyMessages,  // 마지막이 user 메시지이므로 따로 붙일 필요 없음
          ]
        }),
      );

      if (response.statusCode != 200) throw Exception(response.body);
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];

    } catch (e, st) {
      log('fetchAnswer error: $e\n$st');
      return AppStrings.tr('error_api');
    }
  }

  Future<String> generateDiary(List<Message> todayChats, {
    int diaryLength = 500,
  }) async {
    try {
      final systemPrompt = await _buildSystemPrompt('assets/prompts/diary.json');
      final conversationHistory = _formatChatsForGPT(todayChats);

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $OPENAI_APIKEY"
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "max_tokens": diaryLength,
          "temperature": 0.85,
          "top_p": 0.95,
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": conversationHistory}
          ]
        }),
      );

      if (response.statusCode != 200) throw Exception(response.body);
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];

    } catch (e, st) {
      log('generateDiary error: $e\n$st');
      return AppStrings.tr('error_diary_generation');
    }
  }

  String _formatChatsForGPT(List<Message> chats) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("Conversation between the user and Brownie today:");
    buffer.writeln("---");

    for (final chat in chats) {
      if (chat.msgType == MessageType.user) {
        buffer.writeln("User: ${chat.msg}");
      } else {
        buffer.writeln("Brownie: ${chat.msg}");
      }
    }

    buffer.writeln("---");
    buffer.writeln("Based on the conversation above, write a warm diary entry as instructed.");

    return buffer.toString();
  }
}