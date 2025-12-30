import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class AskQuestion extends ChatEvent {
  final String question;
  const AskQuestion(this.question);

  @override
  List<Object?> get props => [question];
}

class SearchMessages extends ChatEvent {
  final String query;
  const SearchMessages(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends ChatEvent {
  const ClearSearch();
}