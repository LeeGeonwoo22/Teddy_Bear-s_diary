import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import '../../../core/common/aIService.dart';
import '../../../core/common/encryption_service.dart';
import '../../../data/local/diaryDataSource.dart';
import '../../../data/model/diary.dart';



class DiaryRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final DiaryLocalSource local;
  final AIService remote;
  final ChatRepository chatRepository;
  final EncryptionService _encryption = EncryptionService();

  DiaryRepository({
    required this.remote,
    required this.local,
    required this.chatRepository
});
  // 일기 생성
  Future<Diary?> createTodayDiary() async {
    // 1️⃣ 오늘 채팅 내역 불러오기
    final todayChats = await chatRepository.getTodayMessages();

    if (todayChats.isEmpty) {
      print('⚠️ 오늘 대화가 없음');
      return null;
    }

    print('✅ 오늘 대화 ${todayChats.length}개 불러옴');

    return null; // 🔑 반드시 반환
  }
}
