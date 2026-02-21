// diary_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/diary/bloc/diary_event.dart';
import 'package:teddyBear/features/diary/bloc/diary_state.dart';
import '../repository/diaryRepository.dart';


class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryRepository _repository;

  DiaryBloc(this._repository) : super(DiaryState.initial()) {
    on<GenerateDiary>(_onGenerateTodayDiary);
    on<SelectDiary>(_onSelectDiary);
    on<LoadDiaries>(_onLoadDiaries);
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

  // void _onSelectDiary(
  //     SelectDiary event,
  //     Emitter<DiaryState> emit,
  //     ) {
  //   final normalizedDate = DateTime(
  //     event.date.year,
  //     event.date.month,
  //     event.date.day,
  //   );
  //
  //   emit(state.copyWith(
  //     selectedDate: normalizedDate,
  //   ));
  // }
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
}