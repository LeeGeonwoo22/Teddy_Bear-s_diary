import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../core/common/appString.dart';
import '../../../core/common/global.dart';


class ChatRemoteDataSource {
  final http.Client _client;
  ChatRemoteDataSource(this._client);

  Future<String> fetchAnswer(String question) async {
    try {
      // 1️⃣ 곰돌이 프롬프트 파일 목록 읽기
      final jsonString = await rootBundle.loadString('assets/prompts/files.json');
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
          "max_tokens": 2000,
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
}
