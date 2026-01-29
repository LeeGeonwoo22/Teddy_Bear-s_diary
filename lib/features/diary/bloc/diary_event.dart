import 'package:equatable/equatable.dart';


abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
  @override
  List<Object?> get props => [];
}

class LoadDiaries extends DiaryEvent {
  const LoadDiaries();
}

class SelectDiary extends DiaryEvent {

  final DateTime date;

  const SelectDiary(this.date);

  @override
  List<Object?> get props => [date];
}

class GenerateDiary extends DiaryEvent {
  final DateTime date;   // 선택된 날짜
  // final String journal;  // AI + 사용자 대화 결과

  const GenerateDiary({
    required this.date,

  });

  @override
  List<Object> get props => [date];
}

class ClearError extends DiaryEvent {
  const ClearError();
}

class RefreshDiaries extends DiaryEvent {
  const RefreshDiaries();
}