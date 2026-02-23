import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import '../../../core/common/aIService.dart';
import '../../../core/common/dateFormatter.dart';
import '../../../core/common/encryption_service.dart';
import '../../../data/local/diaryDataSource.dart';
import '../../../data/model/diary.dart';
import '../../auth/repository/AuthRepository.dart';

class DiaryRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final DiaryLocalSource local;
  final AIService remote;
  final ChatRepository chatRepository;
  final AuthRepository authRepository;
  final EncryptionService _encryption = EncryptionService();


  DiaryRepository({
    required this.remote,
    required this.local,
    required this.chatRepository,
    required this.authRepository
});

  String get _uid {
    final user = authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Not authenticated');
    }
    return user.uid;
  }

  // 일기 생성
  Future<Diary?> createTodayDiary( {required int diaryLength, required int diaryCreationHour})
    async {

    try {
      final uid = _uid;
      final today = DateFormatter.normalizeDate(DateTime.now());
      final dateKey = DateFormatter.formatDate(DateTime.now());

      // 중복 체크
      final snapshot = await db
          .collection('users')
          .doc(uid)
          .collection('diaries')  // ✅ 통일
          .doc(dateKey)
          .get();
          // .where('date', isGreaterThanOrEqualTo: startOfMonth)

      if (snapshot.exists) {
        throw Exception('오늘 일기는 이미 존재합니다');
      }

      // 오늘 대화 가져오기
// 오늘 대화 가져오기
      final todayMessages = await chatRepository.getTodayMessages();

// ✅ 체크 먼저
      if (todayMessages.length < 20) {
        print('⚠️ 곰돌이에게 오늘 이야기를 더 해주세요');
        return null;
      }

      print('✅ 오늘 대화 ${todayMessages.length}개 불러옴');

      // AI로 일기 생성
      final content = await remote.generateDiary(
        todayMessages,
        diaryLength: diaryLength,
      );
      print('✅ 오늘 대화 ${todayMessages.length}개 불러옴');



      // Diary 객체 생성
      final diary = Diary(
        date: today,
        title: '오늘의 일기',
        content: content,
        emotion: '',
      );

      // 암호화
      final encryptedTitle = _encryption.encrypt(diary.title);
      final encryptedContent = _encryption.encrypt(diary.content);

      // Firestore 저장
      await db
          .collection('users')
          .doc(uid)
          .collection('diaries')
          .doc(dateKey)
          .set({
        'date': Timestamp.fromDate(today),
        'title': encryptedTitle,
        'content': encryptedContent,
        'emotion': diary.emotion,
      });

      print('📥 일기 Firestore 저장 완료');

      // Local 저장
      await local.saveDiary(diary);

      print('✅ 일기 생성 완료!');
      return diary;

    } catch (e) {  // ✅ 공백 추가
      print('❌ createTodayDiary 실패: $e');
      rethrow;
    }
    // ✅ 여기서 함수 끝! 아래 주석 코드들 전부 삭제
  }

  // 일기 불러오기
  Future<Map<DateTime, Diary>> loadDiaries() async {
    try {
      final uid = _uid;
      final snapshot = await db
          .collection('users')
          .doc(uid)
          .collection('diaries')
          .get();

      print('📦 Firestore에서 ${snapshot.docs.length}개 문서 조회');

      final diariesMap = <DateTime, Diary>{};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();

          print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('🔍 문서 ID: ${doc.id}');
          print('🔍 title 타입: ${data['title'].runtimeType}');
          print('🔍 title 값: ${data['title']}');
          print('🔍 content 타입: ${data['content'].runtimeType}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

          if (data['title'] == null || data['content'] == null) {
            print('⚠️ 필수 필드 없음: ${doc.id}');
            continue;
          }

          // ✅ Map으로 캐스팅
          final titleMap = data['title'] as Map<String, dynamic>;
          final contentMap = data['content'] as Map<String, dynamic>;

          String decryptedTitle;
          String decryptedContent;

          try {
            // ✅ Map에서 cipher와 iv를 추출하여 전달
            decryptedTitle = _encryption.decrypt(
              cipherText: titleMap['cipher'] as String,
              ivBase64: titleMap['iv'] as String,
            );

            decryptedContent = _encryption.decrypt(
              cipherText: contentMap['cipher'] as String,
              ivBase64: contentMap['iv'] as String,
            );

            print('✅ 복호화 성공!');
            print('   제목: $decryptedTitle');
            print('   내용 (앞 100자): ${decryptedContent.substring(0, decryptedContent.length > 100 ? 100 : decryptedContent.length)}');

          } catch (e) {
            print('❌ 복호화 실패: ${doc.id}');
            print('   에러: $e');
            continue;  // ✅ 복호화 실패하면 이 일기는 건너뛰기
          }

          if (decryptedTitle.isEmpty || decryptedContent.isEmpty) {
            print('⚠️ 복호화 후 빈 문자열: ${doc.id}');
            continue;
          }

          // 날짜 파싱 및 정규화
          final timestamp = data['date'] as Timestamp;
          final dateTime = timestamp.toDate();
          final normalizedDate = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
          );

          print('📅 정규화된 날짜: ${normalizedDate.year}-${normalizedDate.month}-${normalizedDate.day}');

          // Diary 객체 생성
          final diary = Diary(
            date: normalizedDate,
            title: decryptedTitle,
            content: decryptedContent,
            emotion: data['emotion'] as String? ?? '',
          );

          // Map에 추가
          diariesMap[normalizedDate] = diary;
          print('✅ 일기 추가 완료 (총 ${diariesMap.length}개)\n');

        } catch (e, stackTrace) {
          print('⚠️ 일기 파싱 실패 (${doc.id}): $e');
          print('스택 트레이스: $stackTrace');
          continue;
        }
      }

      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ 최종 결과: ${diariesMap.length}개 일기 불러옴');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      await _updateLocalCache(diariesMap.values.toList());

      return diariesMap;

    } catch (e, stackTrace) {
      print('❌ Firestore 조회 실패: $e');
      print('스택 트레이스: $stackTrace');
      return await _loadFromLocalCache();
    }
  }

  // 일기 지우기
  Future<void> deleteAllDiaries() async {
    try {
      final uid = _uid;
      final batch = db.batch();

      final diaryDocs = await db
          .collection('users')
          .doc(uid)
          .collection('diaries')
          .get();

      for (var doc in diaryDocs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      await local.clearAll();  // 로컬도 삭제

      print('🗑️ 모든 일기 삭제 완료');
    } catch (e) {
      print('❌ 일기 삭제 실패: $e');
      rethrow;
    }
  }
  // 감정 업데이트
  Future<void> updateEmotion(DateTime date, String emotion) async {
    final dateKey = DateFormatter.formatDate(date);
    final uid = _uid;
    await db.collection('users').doc(uid)
        .collection('diaries').doc(dateKey)
        .update({'emotion': emotion});

  }
  // 📌 헬퍼 메서드: Local 캐시 업데이트
  Future<void> _updateLocalCache(List<Diary> diaries) async {
    try {
      // 전체 삭제 후 새로 저장
      // await local.clearAllDiaries();
      for (var diary in diaries) {
        await local.saveDiary(diary);
      }

      print('💾 Local 캐시 업데이트 완료');
    } catch (e) {
      print('⚠️ Local 캐시 업데이트 실패: $e');
    }
  }

// 📌 헬퍼 메서드: Local에서 불러오기
  Future<Map<DateTime, Diary>> _loadFromLocalCache() async {
    try {
      final localDiaries = await local.getAllDiaries();

      final diariesMap = <DateTime, Diary>{};
      for (var diary in localDiaries.values) {
        final normalizedDate = DateTime(
          diary.date.year,
          diary.date.month,
          diary.date.day,
        );
        diariesMap[normalizedDate] = diary;
      }

      print('⚠️ Local 캐시에서 ${diariesMap.length}개 불러옴');
      return diariesMap;

    } catch (e2) {
      print('❌ Local 캐시도 실패: $e2');
      return {};
    }
  }


}


