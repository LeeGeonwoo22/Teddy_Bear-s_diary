import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import '../../../core/common/aIService.dart';
import '../../../core/common/date_utils.dart';
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
  Future<Diary?> createTodayDiary() async {
    try {
      final uid = _uid;
      final today = DateUtils.normalizeDate(DateTime.now());
      final dateKey = DateUtils.formatDate(DateTime.now());

      // 중복 체크
      final snapshot = await db
          .collection('users')
          .doc(uid)
          .collection('diaries')  // ✅ 통일
          .doc(dateKey)
          .get();

      if (snapshot.exists) {
        throw Exception('오늘 일기는 이미 존재합니다');
      }

      // 오늘 대화 가져오기
      final todayMessages = await chatRepository.getTodayMessages();
      if (todayMessages.isEmpty) {
        print('⚠️ 오늘 대화 없음');
        return null;
      }

      print('✅ 오늘 대화 ${todayMessages.length}개 불러옴');

      // AI로 일기 생성
      final content = await remote.generateDiary(todayMessages);

      // Diary 객체 생성
      final diary = Diary(
        date: today,
        title: '오늘의 일기',  // ✅ 임시 제목 (나중에 AI 응답 파싱)
        content: content,
        emotion: '',  // ✅ 초기값
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

  Future<Map<DateTime, Diary>?> loadDiaries() async {
    try{
      final uid = _uid;
      final snapshot = await db
          .collection('users')
          .doc(uid)
          .collection('diaries')
          .get();

      print('📦 Firestore에서 ${snapshot.docs.length}개 문서 조회');

      final diariesMap = <DateTime, Diary>{};

      // 복호화를 풀어야 하기 때문에 모든 문서를 불러줘야함 일단.
      for (var doc in snapshot.docs) {
        try{
          final data = doc.data();

          if (data['title'] == null || data['content'] == null) {
            print('⚠️ 필수 필드 없음: ${doc.id}');
            continue;
          }

          // 📌 2. 복호화
          final encryptedTitle = data['title'] as String;
          final encryptedContent = data['content'] as String;

          final decryptedTitle = _encryption.decrypt(encryptedTitle);
          final decryptedContent = _encryption.decrypt(encryptedContent);

          if (decryptedTitle.isEmpty || decryptedContent.isEmpty) {
            print('⚠️ 복호화 실패: ${doc.id}');
            continue;
          }

          // 정규화된 날짜 부르기
          // 무슨날짜를 넣지 ??
          // final normalizeDate = DateUtils.normalizeDate(date);
          // diary 객체 생성
          // final diary = Diary(
          //     date: ,
          //     title: '',
          //     content: ''
          // );
          // 📌 3. 날짜 파싱 및 정규화
          final timestamp = data['date'] as Timestamp;
          final dateTime = timestamp.toDate();
          final normalizedDate = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
          );

          // 📌 4. Diary 객체 생성
          final diary = Diary(
            date: normalizedDate,
            title: decryptedTitle,
            content: decryptedContent,
            emotion: data['emotion'] as String? ?? '',
          );

          // 📌 5. Map에 추가
          diariesMap[normalizedDate] = diary;

        }catch(e){
          print('⚠️ 일기 파싱 실패 (${doc.id}): $e');
          continue;
        }
      }
      print('✅ ${diariesMap.length}개 일기 불러옴 (복호화 완료)');

      // 📌 6. Local 캐시 업데이트 (선택사항)
      await _updateLocalCache(diariesMap.values.toList());

      return diariesMap;

    }catch(e){
      print('❌ Firestore 조회 실패: $e');
      return await _loadFromLocalCache();
    }
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
