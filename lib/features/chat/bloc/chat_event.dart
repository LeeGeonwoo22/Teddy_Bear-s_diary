
abstract class ChatEvent {}

class AskQuestion extends ChatEvent {
  final String question;

  AskQuestion(this.question);

}
class ScrollDown extends ChatEvent {}