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



  // 문장 대답
  Future<String> fetchAnswer(String question) async {
    try {
      // 1️⃣ 곰돌이 프롬프트 파일 목록 읽기
      final jsonString = await rootBundle.loadString('assets/prompts/chat.json');
      final fileList = jsonDecode(jsonString)['files'];

      // 2️⃣ 시스템 프롬프트 병합 (모든 파일 내용 합치기)
      String systemPrompt = '';
      for (final filename in fileList) {
        final content = await rootBundle.loadString('assets/prompts/$filename');
        systemPrompt += '\n\n$content';
      }

      // 3️⃣ API 요청
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $OPENAI_APIKEY"
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "max_tokens": 300,
          "temperature": 0.8,
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

  Future<String> generateDiary(List<Message> todayChats) async {
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
          "max_tokens": 500,
          "temperature": 0.8,
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



