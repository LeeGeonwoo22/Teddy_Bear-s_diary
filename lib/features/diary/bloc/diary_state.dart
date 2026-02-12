import 'package:equatable/equatable.dart';
import '../../../data/model/diary.dart';

class DiaryState extends Equatable {
  // 📚 일기 데이터
  final Map<DateTime, Diary> diaries;
  final DateTime? selectedDate;

  // ⏳ 로딩
  final bool isLoading;
  final bool isGenerating;
  final String? errorMessage;

  const DiaryState({
    this.diaries = const {},

    this.selectedDate,
    this.isLoading = false,
    this.isGenerating = false,
    this.errorMessage,
  });

  // 🏭 초기 상태
  factory DiaryState.initial() {
    return const DiaryState();
  }

  // 📝 copyWith (불변성 유지)
  DiaryState copyWith({
    Map<DateTime, Diary>? diaries,
    DateTime? selectedDate,
    bool? isLoading,
    bool? isGenerating,
    String? errorMessage,
  }) {
    return DiaryState(
      diaries: diaries ?? this.diaries,

      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // ✅ Equatable props
  @override
  List<Object?> get props => [
    diaries,
    selectedDate,
    isLoading,
    isGenerating,
    errorMessage,
  ];
}