// diary_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/core/common/dateFormatter.dart';
import 'package:teddyBear/features/diary/bloc/diary_event.dart';
import 'package:teddyBear/features/diary/bloc/diary_state.dart';
import '../../../data/model/diary.dart';
import '../repository/diaryRepository.dart';


class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryRepository _repository;

  DiaryBloc(this._repository) : super(DiaryState.initial()) {
    on<GenerateDiary>(_onGenerateTodayDiary);
    on<SelectDiary>(_onSelectDiary);
    on<LoadDiaries>(_onLoadDiaries);
    on<DeleteAllDiaries>(_onDeleteAllDiaries);
    on<UpdateEmotion>(_onUpdateEmotion);
  }


  /// 1️⃣ 앱 / 탭 진입 시 전체 일기 로드
  Future<void> _onLoadDiaries(
      LoadDiaries event,
      Emitter<DiaryState> emit,
      )
  async {
    emit(state.copyWith(isLoading: true));

    try {
      final diaries = await _repository.loadDiaries();
      // Map<DateTime, Diary>

      emit(state.copyWith(
        diaries: diaries,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '일기를 불러올 수 없습니다',
      ));
    }
  }
  Future<void> _onGenerateTodayDiary(
      GenerateDiary event,
      Emitter<DiaryState> emit,
      )
    async {
    print('📝 일기 생성 시작...');
    emit(state.copyWith(isGenerating: true));

    try {
      final diary = await _repository.createTodayDiary(
        diaryLength: event.diaryLength,
        diaryCreationHour: event.diaryCreationHour,
      );

      if (diary == null) {
        emit(state.copyWith(
          isGenerating: false,
          errorMessage: '오늘 대화 내용이 없어요',
        ));
        return;
      }

      // 성공!
      emit(state.copyWith(
        isGenerating: false,
      ));

      print('✅ 일기 생성 완료!');

    } catch (e) {
      print('❌ 일기 생성 실패: $e');
      emit(state.copyWith(
        isGenerating: false,
        errorMessage: '일기 생성 실패: $e',
      ));
    }
  }

  Future<void> _onSelectDiary(
      SelectDiary event,
      Emitter<DiaryState> emit,
      )
  async {
    final normalizedDate = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );

    final diary = state.diaries[normalizedDate];

    emit(state.copyWith(
      selectedDate: normalizedDate,

    ));

    if (diary != null) {
      print('✅ ${event.date.month}/${event.date.day} 일기 선택');
    } else {
      print('⚠️ ${event.date.month}/${event.date.day} 일기 없음');
    }
  }

  Future<void> _onDeleteAllDiaries(
      DeleteAllDiaries event,
      Emitter<DiaryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.deleteAllDiaries();
      emit(state.copyWith(
        isLoading: false,
        diaries: {},  // ✅ 상태도 비우기
      ));
      print('🗑️ 일기 전체 삭제 완료');
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '일기 삭제 실패: $e',
      ));
    }
  }
  Future<void> _onUpdateEmotion(
      UpdateEmotion event,
      Emitter<DiaryState> emit,
      ) async {
          try{
            await _repository.updateEmotion(event.date, event.emotion);

            final updatedDiaries = Map<DateTime, Diary>.from(state.diaries);
            final normalizedDate = DateFormatter.normalizeDate(event.date);

            if(updatedDiaries.containsKey(normalizedDate)) {
              updatedDiaries[normalizedDate] = updatedDiaries[normalizedDate]!.copyWith(emotion: event.emotion);
              print('✅ State 업데이트 완료: ${updatedDiaries[normalizedDate]?.emotion}');
              emit(state.copyWith(diaries: updatedDiaries));
            }

            print('✅ 감정 업데이트 완료: ${event.emotion}');
        }
          catch(e) {
            print('❌ 감정 업데이트 실패: $e');
        }
  }

}