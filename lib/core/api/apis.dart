import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../common/global.dart';

class APIs {
  static Future<String> getAnswer(String question) async {
    try {
      // 1️⃣ 곰돌이 프롬프트 파일 목록 읽기
      final jsonString = await rootBundle.loadString('assets/prompts/files.json');
      final fileList = jsonDecode(jsonString)['files'];

      // 2️⃣ 모든 파일 내용 합치기
      String systemPrompt = '';
      for (final filename in fileList) {
        final content = await rootBundle.loadString('assets/prompts/$filename');
        systemPrompt += '\n\n$content';
      }

      // 3️⃣ GPT API 요청
      final res = await post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $OPENAI_APIKEY"
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "max_tokens": 2000,
          "temperature": 0.8,
          "messages": [
            {
              "role": "system",
              "content": systemPrompt, // 🧸 곰돌이의 영혼
            },
            {
              "role": "user",
              "content": question, // 사용자의 입력
            }
          ]
        }),
      );

      // 4️⃣ 응답 처리
      final data = jsonDecode(res.body);
      final answer = data['choices'][0]['message']['content'];
      log('res : $answer');
      return answer;
    } catch (e) {
      log('getAnswerE : $e');
      return '곰돌이가 잠시 쉬고 있어요... 🧸 잠시 후 다시 시도해주세요.';
    }
  }
}