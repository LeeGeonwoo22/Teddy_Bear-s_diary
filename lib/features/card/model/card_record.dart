import 'package:teddyBear/features/card/model/tarot_class.dart';

class CardRecord {
  final DateTime date;
  final String category;
  final String question;
  final TarotCard card;
  CardRecord({
    required this.date,
    required this.category,
    required this.question,
    required this.card,
  });
}