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
  final DateTime date;
  final int diaryLength;
  final int diaryCreationHour;

  const GenerateDiary({
    required this.date,
    required this.diaryLength,
    required this.diaryCreationHour,
  });

  @override
  List<Object> get props => [date, diaryLength, diaryCreationHour];
}


class ClearError extends DiaryEvent {
  const ClearError();
}

class RefreshDiaries extends DiaryEvent {
  const RefreshDiaries();
}