
class CardCategory {
  final String name;
  final String emoji;
  final List<String> questions;

   CardCategory({
    required this.name,
    required this.emoji,
    required this.questions,
  });

  bool get isEtc => questions.isEmpty;
}

// data도 여기 같이 두거나, data/category_data.dart로 분리 가능
 List<CardCategory> QCategories = [
  CardCategory(name: '연애', emoji: '💕', questions: [
    '언제 이성친구가 생길까?',
    '썸으로만 끝날까? 연애로 발전할 수 있을까?',
    '그 사람은 나를 어떻게 생각할까?',
    '지금 너무 힘든데.. 관계 유지하는 게 좋을까?',
  ]),
  CardCategory(name: '금전 / 커리어', emoji: '💰', questions: [
    '올해 내가 돈을 얼마나 벌까?',
    '어떤 일을 해야 나에게 맞을까?',
    '이것을 투자하는 게 맞을까?',
  ]),
  CardCategory(name: '학업 / 성적', emoji: '📚', questions: [
    '이번 시험은 잘 볼 수 있을까?',
    '지금 공부 방향이 맞을까?',
    '목표한 학교에 갈 수 있을까?',
  ]),
  CardCategory(name: '인간관계', emoji: '🤝', questions: [
    '나는 사람들에게 어떤 이미지일까?',
    '그 사람은 왜 나에게 그런 행동을 하였을까?',
    '우리는 좋은 친구로 발전할 수 있을까?',
    '내가 조심해야 할 점은 무엇일까?',
  ]),
  CardCategory(name: '건강', emoji: '🌿', questions: [
    '몸이 안 좋아.. 나 괜찮을까?',
    '부모님의 건강운은 어떨까?',
    '친구 / 지인의 건강운은 어떨까?',
  ]),
  CardCategory(name: '기타', emoji: '🌀', questions: []),
];