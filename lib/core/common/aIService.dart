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
    promptBuffer.writeln("### [SYSTEM RULE: 당신의 본질] ###");

    for (final filename in fileList) {
      final content = await rootBundle.loadString('assets/prompts/$filename');
      // 파일명에 'like'가 포함되면 가장 강조
      if (filename.contains('like')) {
        promptBuffer.writeln("\n[CORE IDENTITY - 절대 잊지 말 것]\n$content");
      } else {
        promptBuffer.writeln("\n[CONTEXTUAL RULE]\n$content");
      }
    }
    // 마지막에 강력한 행동 지침 추가 (Recency Effect 활용)
    promptBuffer.writeln("\n### [최종 지시] ###");
    promptBuffer.writeln("위의 모든 정체성을 유지하되, 사용자의 마지막 문장의 '온도'와 '속도'에 반드시 맞추어 응답하세요.");

    return promptBuffer.toString();
  }


  // 문장 대답
  Future<String> fetchAnswer(String question) async {
    try {
      // // 1️⃣ 곰돌이 프롬프트 파일 목록 읽기
      // final jsonString = await rootBundle.loadString('assets/prompts/chat.json');
      // final fileList = jsonDecode(jsonString)['files'];
      //
      // // 2️⃣ 시스템 프롬프트 병합 (모든 파일 내용 합치기)
      // String systemPrompt = '';
      // for (final filename in fileList) {
      //   final content = await rootBundle.loadString('assets/prompts/$filename');
      //   systemPrompt += '\n\n$content';
      // }

      // 3️⃣ API 요청
      final systemPrompt = await _buildSystemPrompt('assets/prompts/chat.json');

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
          "presence_penalty": 0.6, // 새로운 화제를 갑자기 꺼내지 않도록 유도
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": question}
          ]
        }),
      );

      if (response.statusCode != 200) throw Exception(response.body);
      final data = jsonDecode(response.body);
      final answer = data['choices'][0]['message']['content'];
      return answer;
    } catch (e, st) {
      log('ChatRemoteDataSource.fetchAnswer error: $e\n$st');
      // rethrow;
      return AppStrings.tr('error_api');
    }
  }

  Future<String> generateDiary(List<Message> todayChats, {
    int diaryLength = 500,  // 기본값 설정
  }) async {
    try{
      // 일기작성용 프롬프트 로드
      final diaryPrompt = await rootBundle.loadString('assets/prompts/diary.json');
      final fileList = jsonDecode(diaryPrompt)['files'];
      //
      String systemPrompt = '';
      for (final filename in fileList) {
        final content = await rootBundle.loadString('assets/prompts/$filename');
        systemPrompt += '\n\n$content';
      }

      // 2️⃣ 오늘 대화 내용 포맷팅
      String conversationHistory = _formatChatsForGPT(todayChats);
      // 4️⃣ API 요청 (여기부터 추가!)
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
          "top_p": 0.95, // 문장의 창의성을 살리면서 일관성을 유지
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": conversationHistory}
          ]
        }),
      );

      if (response.statusCode != 200) throw Exception(response.body);

      final data = jsonDecode(response.body);
      final diary = data['choices'][0]['message']['content'];

      return diary;

    }catch(e, st){
      log('ChatRemoteDataSource.generateDiary error: $e\n$st');
      return AppStrings.tr('error_diary_generation');
    }
  }

  // 헬퍼 함수
  String _formatChatsForGPT(List<Message> chats) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("오늘 사용자와 나눈 대화:");
    buffer.writeln("---");

    for (final chat in chats) {
      if (chat.msgType == MessageType.user) {
        buffer.writeln("사용자: ${chat.msg}");
      } else {
        buffer.writeln("곰돌이: ${chat.msg}");
      }
    }

    buffer.writeln("---");
    buffer.writeln("위 대화를 바탕으로 따뜻한 일기를 작성해줘.");

    return buffer.toString();
  }
}



