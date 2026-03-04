import '../model/tarot_class.dart';
import 'package:flutter/material.dart';

class CardDeck {
// ============================================================
// 곰돌이 타로 완전한 덱 (78장)
// Major Arcana 22장 + Minor Arcana 56장
// ============================================================

  static List<TarotCard> deck = [

    // ═══════════════════════════════════════════
    // MAJOR ARCANA (0 ~ 21)
    // ═══════════════════════════════════════════

    TarotCard(
      name: '바보',
      emoji: '🌬️',
      keyword: '새로운 시작 · 순수한 자유',
      message: '절벽 끝에 선 것이 두려움이 아니라 설렘이라는 걸, 발을 내딛어본 사람만 알아. '
          '지금 네가 떠나려는 그 길, 아무도 걸어보지 않은 길이어도 괜찮아.',
      teddyComment: '바보라는 말은 가장 먼저 길을 떠나는 자에게만 붙는 이름이야 🧸',
      color: Color(0xFFFFD54F),
    ),

    TarotCard(
      name: '마법사',
      emoji: '🪄',
      keyword: '창조 · 집중 · 마법적 시작',
      message: '도구는 이미 네 손 안에 있어. 검도, 잔도, 나뭇가지도, 꿀단지도 모두. '
          '필요한 건 딱 한 가지—마음을 고요히 하고 첫 번째 선을 긋는 용기야.',
      teddyComment: '영감은 찾는 게 아니라 알아채는 거야. 오늘 한 가지만 시작해봐 ✨',
      color: Color(0xFFBA68C8),
    ),

    TarotCard(
      name: '여사제',
      emoji: '🌙',
      keyword: '직관 · 비밀 · 기다림',
      message: '보이지 않는 진실이 네 안에서 천천히 자라고 있어. '
          '지금은 답을 서두르는 게 아니라, 달빛처럼 가만히 기다릴 때야.',
      teddyComment: '진짜 지혜는 고요한 기다림 속에서 태어나더라 🌙',
      color: Color(0xFF64B5F6),
    ),

    TarotCard(
      name: '여황제',
      emoji: '🌸',
      keyword: '풍요 · 돌봄 · 숨겨진 창조',
      message: '네가 돌보는 이들 중 가장 소중한 존재는 바로 너 자신이야. '
          '꽃밭에 물을 주기 전에, 먼저 네 뿌리에 물을 줘봐.',
      teddyComment: '오늘은 나를 위한 작은 선물 하나, 어때? 🌸',
      color: Color(0xFFEC407A),
    ),

    TarotCard(
      name: '황제',
      emoji: '🏔️',
      keyword: '안정 · 질서 · 책임',
      message: '흔들리지 않는 기반이 필요한 때야. 바위처럼 단단히 중심을 잡되, '
          '그 무게가 너를 짓누르지 않게 해. 질서는 등받이가 되기도 하지만, 벽이 될 수도 있으니까.',
      teddyComment: '규칙은 나를 지탱하는 것이지, 나를 가두는 게 아니야 ⚓',
      color: Color(0xFFFFB74D),
    ),

    TarotCard(
      name: '교황',
      emoji: '📖',
      keyword: '지혜 · 전통 · 비판적 사고',
      message: '오래된 가르침이 길잡이가 될 때도 있어. '
          '하지만 그 말이 진짜 네 것이 되려면 한 번은 스스로 물어봐야 해—"이게 정말 내 진실이야?"',
      teddyComment: '모든 말이 진실은 아니야. 누가 말했든 한 번 더 생각해봐 🤔',
      color: Color(0xFF7986CB),
    ),

    TarotCard(
      name: '연인',
      emoji: '💛',
      keyword: '선택 · 연결 · 진심',
      message: '사랑은 감정이기도 하지만, 선택이기도 해. '
          '지금 네 앞의 갈림길, 마음이 이미 방향을 알고 있을지도 몰라.',
      teddyComment: '네 마음이 이미 답을 알고 있을 거야 💛',
      color: Color(0xFFFF9999),
    ),

    TarotCard(
      name: '전차',
      emoji: '🚲',
      keyword: '의지 · 전진 · 자기 조율',
      message: '지금은 밀어붙일 때야. 핸들을 꽉 쥐고 바람을 가르며 나아가봐. '
          '단, 왜 달리는지는 잊지 마—방향이 먼저고, 속도는 그다음이야.',
      teddyComment: '힘들어도 포기하지 마. 곁에서 응원할게 🚀',
      color: Color(0xFF4FC3F7),
    ),

    TarotCard(
      name: '힘',
      emoji: '🦁',
      keyword: '용기 · 자기 수용 · 경계',
      message: '내 안의 사자가 울고 있다면, 도망치지 말고 조용히 손을 내밀어봐. '
          '두려움은 다정함을 만나면 조용히 눕거든. 진짜 힘은 나를 온전히 받아들이는 데서 나와.',
      teddyComment: '천천히 해도 괜찮아. 네 속도가 맞는 속도야 🦁',
      color: Color(0xFFFFE082),
    ),

    TarotCard(
      name: '은둔자',
      emoji: '🕯️',
      keyword: '성찰 · 멈춤 · 내면의 빛',
      message: '앞만 보는 것보다, 발밑의 그림자를 보는 용기가 필요할 때도 있어. '
          '속도를 줄인다고 뒤처지는 건 아니야. 삶은 앞이 아니라 안에서 자라.',
      teddyComment: '쉬는 것도 중요한 일이야. 오늘은 푹 쉬어 🕯️',
      color: Color(0xFF90A4AE),
    ),

    TarotCard(
      name: '운명의 바퀴',
      emoji: '🎡',
      keyword: '운명 · 변화 · 흐름',
      message: '사계절이 바뀌듯 지금 네 삶도 다음 장면으로 넘어가려 하고 있어. '
          '변화는 예고 없이 오지만, 그것도 하나의 리듬이야. 네 타이밍을 찾아봐.',
      teddyComment: '오래전부터 예정된 흐름이 지금 움직이고 있는지도 몰라 🎡',
      color: Color(0xFFFFF59D),
    ),

    TarotCard(
      name: '정의',
      emoji: '⚖️',
      keyword: '균형 · 진실 · 내면의 기준',
      message: '정의는 칼을 휘두르는 게 아니라, 고요한 눈으로 진실을 바라보는 힘이야. '
          '내면의 저울이 흔들릴 땐, 먼저 마음의 무게를 살펴봐.',
      teddyComment: '말은 무기이기도 하고, 치유이기도 해. 오늘 네 말의 무게는 어때? ⚖️',
      color: Color(0xFFC5E1A5),
    ),

    TarotCard(
      name: '매달린 사람',
      emoji: '🙃',
      keyword: '멈춤 · 수용 · 거꾸로 된 성장',
      message: '고통스러운 멈춤이 오히려 새로운 눈을 뜨게 해줄 때가 있어. '
          '거꾸로 매달렸을 때 보이는 풍경이, 때론 가장 진짜인 세상이야.',
      teddyComment: '포기는 실패가 아니라, 더 큰 전환의 문이야 🙃',
      color: Color(0xFFB3E5FC),
    ),

    TarotCard(
      name: '죽음',
      emoji: '🍂',
      keyword: '끝 · 변화 · 재생',
      message: '무언가의 끝은, 다음 계절이 오기 위한 자리 비우기야. '
          '낙엽이 져야 봄이 오듯, 지금 놓아야 할 것을 부드럽게 떠나보내봐.',
      teddyComment: '손을 놓아야 새로운 것을 잡을 수 있어. 겨울이 지나야 봄이 와 🍂',
      color: Color(0xFF78909C),
    ),

    TarotCard(
      name: '절제',
      emoji: '🫖',
      keyword: '조화 · 균형 · 절제',
      message: '서두르지 않고 내면의 흐름을 바라볼 때 진정한 균형이 찾아와. '
          '절제는 멈춤이 아니라, 흐름을 읽는 예술이야.',
      teddyComment: '망상의 파도를 억누르는 대신, 차분히 흐름을 지켜봐 🍵',
      color: Color(0xFFFBC02D),
    ),

    TarotCard(
      name: '악마',
      emoji: '🪢',
      keyword: '집착 · 속박 · 내면의 해방',
      message: '가장 무겁게 나를 짓누르는 건 사실 내가 만든 족쇄일 때가 많아. '
          '그것을 알아채는 순간, 진짜 자유가 시작돼.',
      teddyComment: '당신이 이미 존재한다는 사실만으로 충분해 🌿',
      color: Color(0xFF8D6E63),
    ),

    TarotCard(
      name: '탑',
      emoji: '⚡',
      keyword: '붕괴 · 각성 · 재건',
      message: '무너지는 건 두려운 일이지만, 껍질이 깨져야 진짜 모습이 드러나. '
          '무너진 뒤에야 하늘이 얼마나 가까운지 알 수 있어.',
      teddyComment: '안전하다고 믿은 구조물이 가끔 가장 깊은 감옥이 되기도 하더라 ⚡',
      color: Color(0xFFE64A19),
    ),

    TarotCard(
      name: '별',
      emoji: '⭐',
      keyword: '희망 · 치유 · 소원성취',
      message: '어둠 뒤에 떠오른 별빛은 길을 잃은 마음을 비춰. '
          '네 머리 위 북극성은 소원을 잃지 않게 지켜주는 영혼의 지도야.',
      teddyComment: '별은 사라진 게 아니야. 지금은 네 눈에만 안 보일 뿐이야 ⭐',
      color: Color(0xFF4FC3F7),
    ),

    TarotCard(
      name: '달',
      emoji: '🌕',
      keyword: '혼란 · 직관 · 무의식',
      message: '달빛은 태양처럼 모든 걸 드러내지 않아. 그 안개 속에서 길을 잃지 않으려면 '
          '마음 깊은 곳의 직관을 따라야 해. 그건 거짓이 없거든.',
      teddyComment: '불안한 마음, 곰돌이가 함께 있을게 🌕',
      color: Color(0xFFAB47BC),
    ),

    TarotCard(
      name: '태양',
      emoji: '☀️',
      keyword: '기쁨 · 명확성 · 성취',
      message: '지금이 바로 네가 빛날 때야. 걱정도 두려움도 햇살 아래서는 그림자가 돼. '
          '오늘만큼은 춤춰도 좋아.',
      teddyComment: '오늘의 너는 정말 멋져 ☀️',
      color: Color(0xFFFBC02D),
    ),

    TarotCard(
      name: '심판',
      emoji: '📯',
      keyword: '각성 · 반성 · 새로운 출발',
      message: '과거는 짐이 아니라 네 발걸음의 흔적이야. '
          '스스로를 용서할 때, 새로운 장이 열려. 오래된 일기장을 덮고 새 페이지를 펼쳐봐.',
      teddyComment: '여기까지 온 것만으로도 충분히 대단해 📯',
      color: Color(0xFFFFB300),
    ),

    TarotCard(
      name: '세계',
      emoji: '🌍',
      keyword: '완성 · 통합 · 새로운 시작',
      message: '긴 여행 끝에 숲으로 돌아온 곰돌이처럼, 네가 찾던 건 사실 처음부터 여기 있었어. '
          '끝은 새로운 무대의 커튼콜이야.',
      teddyComment: '마무리를 통해 다음을 준비할 수 있어. 잘 해냈어 🌍',
      color: Color(0xFF7986CB),
    ),


    // ═══════════════════════════════════════════
    // MINOR ARCANA — WANDS (완즈 · 불의 슈트)
    // ═══════════════════════════════════════════

    TarotCard(
      name: '완즈 에이스',
      emoji: '🔥',
      keyword: '열정의 시작 · 창의력',
      message: '머리 위에서 불꽃이 반짝이는 게 느껴져? '
          '모든 큰 일은 작은 불씨 하나에서 시작돼. 아이디어가 보이면 지금 바로 움직여봐.',
      teddyComment: '작은 불씨도 세상을 밝힐 수 있어 🔥',
      color: Color(0xFFFFE082),
    ),

    TarotCard(
      name: '완즈 2',
      emoji: '🗺️',
      keyword: '계획 · 선택 · 비전',
      message: '두 갈래 길 앞에서 지도를 펼칠 때야. '
          '가만히 있는 게 가장 큰 미궁이야—작은 발걸음 하나가 모든 선택의 시작이야.',
      teddyComment: '망설임도 괜찮아. 하지만 지도는 펼쳐두는 거야 🗺️',
      color: Color(0xFFFFD54F),
    ),

    TarotCard(
      name: '완즈 3',
      emoji: '⛵',
      keyword: '확장 · 기대 · 미래 지향',
      message: '수평선 너머로 배가 출항하고 있어. 기회가 넓어지는 때야. '
          '먼 곳을 보려면 발은 땅에 단단히 서 있어야 한다는 것도 잊지 마.',
      teddyComment: '기대와 현실을 균형 잡아야 길이 열려 ⛵',
      color: Color(0xFFFFCA28),
    ),

    TarotCard(
      name: '완즈 4',
      emoji: '🎉',
      keyword: '축하 · 안정 · 공동체',
      message: '함께 나눈 기쁨은 오래 간직돼. 작은 성취도 꽃길처럼 축하할 자격이 있어. '
          '혼자보단 함께 축하할 때 성취는 더 깊어져.',
      teddyComment: '오늘은 맘껏 기뻐해도 좋아 🎉',
      color: Color(0xFFFFF176),
    ),

    TarotCard(
      name: '완즈 5',
      emoji: '🤼',
      keyword: '갈등 · 경쟁 · 연습',
      message: '부딪힘도 배움이야. 장난처럼 시작된 다툼도 서로를 더 알아가는 과정일 수 있어. '
          '경쟁보다 중요한 건, 함께 배우는 과정임을 잊지 마.',
      teddyComment: '마음이 다치지 않도록 조심하면서 배워나가자 🤝',
      color: Color(0xFFFFCC80),
    ),

    TarotCard(
      name: '완즈 6',
      emoji: '🏅',
      keyword: '승리 · 인정 · 리더십',
      message: '환호 속에 걸어가는 이 순간, 겸손히 받아들여. '
          '승리는 홀로 빛나는 게 아니라 함께 나눌 때 더 환해져.',
      teddyComment: '성취를 겸손히 받아들일 때, 더 큰 신뢰가 생겨 🏅',
      color: Color(0xFFFFD740),
    ),

    TarotCard(
      name: '완즈 7',
      emoji: '🛡️',
      keyword: '방어 · 용기 · 주장',
      message: '언덕 위에서 혼자 막대를 쥐고 서있어도 괜찮아. '
          '네가 옳다고 믿는 자리는 끝까지 지켜낼 수 있어. 작은 몸짓이라도 지키는 것이 용기야.',
      teddyComment: '때로는 물러서지 않는 것 자체가 메시지야 🛡️',
      color: Color(0xFFEF6C00),
    ),

    TarotCard(
      name: '완즈 8',
      emoji: '💨',
      keyword: '속도 · 진전 · 가속',
      message: '모든 것이 빠르게 흘러가는 때야. 속도를 두려워하지 말고 중심을 지켜. '
          '빠른 물살에도 작은 노젓기는 방향을 잡을 수 있어.',
      teddyComment: '빠른 변화 속에서도 네 중심만 잃지 마 💨',
      color: Color(0xFFFF9100),
    ),

    TarotCard(
      name: '완즈 9',
      emoji: '🩹',
      keyword: '인내 · 경계 · 마지막 힘',
      message: '상처투성이여도 괜찮아. 아직 막대를 쥐고 서 있다면 넌 버티고 있는 거야. '
          '마지막 힘이 가장 큰 차이를 만들어.',
      teddyComment: '버티는 힘은 작지만, 끝을 바꾸기도 해 🩹',
      color: Color(0xFFD84315),
    ),

    TarotCard(
      name: '완즈 10',
      emoji: '🎒',
      keyword: '짐 · 책임 · 과부하',
      message: '무거운 짐을 혼자 다 짊어질 필요는 없어. '
          '책임은 중요하지만, 짐을 나누는 지혜도 그만큼 중요해.',
      teddyComment: '짐은 나눌 때 가벼워져. 도움을 요청해도 괜찮아 🎒',
      color: Color(0xFFF4511E),
    ),

    TarotCard(
      name: '완즈 시종',
      emoji: '🌱',
      keyword: '호기심 · 탐험 · 새로운 시작',
      message: '작은 횃불 하나 들고 넓은 세상을 바라보는 눈빛이 반짝이고 있어. '
          '서툴어도 괜찮아. 호기심을 따르는 발걸음이 큰 모험의 시작이야.',
      teddyComment: '새로운 불씨는 작아도 세상을 밝힐 수 있어 🌱',
      color: Color(0xFFFFB74D),
    ),

    TarotCard(
      name: '완즈 기사',
      emoji: '🏇',
      keyword: '열정 · 추진력 · 모험',
      message: '불꽃처럼 달려나가는 에너지가 느껴져. 그 열정은 멋져. '
          '다만 속도는 힘이지만, 방향이 없다면 그건 바람일 뿐이야.',
      teddyComment: '열정이 빠를수록 마음의 중심이 필요해 🏇',
      color: Color(0xFFF4511E),
    ),

    TarotCard(
      name: '완즈 여왕',
      emoji: '🌻',
      keyword: '자신감 · 따뜻한 리더십 · 풍요',
      message: '해바라기처럼 자기 자신을 향해 피어나는 에너지가 있어. '
          '자신감은 남을 억누르지 않고 함께 빛나게 하는 힘이야.',
      teddyComment: '따뜻한 햇살은 모두에게 스며들어 🌻',
      color: Color(0xFFFBC02D),
    ),

    TarotCard(
      name: '완즈 왕',
      emoji: '🦅',
      keyword: '비전 · 통찰 · 강한 리더십',
      message: '높은 언덕에서 멀리 바라보는 눈빛. 바람이 세도 흔들리지 않는 그 눈빛. '
          '리더십은 자신을 지키는 힘이 아니라, 모두를 비추는 불꽃이야.',
      teddyComment: '멀리 보는 눈이 있어야 모두를 함께 이끌 수 있어 🦅',
      color: Color(0xFFE65100),
    ),


    // ═══════════════════════════════════════════
    // MINOR ARCANA — CUPS (컵 · 물의 슈트)
    // ═══════════════════════════════════════════

    TarotCard(
      name: '컵 에이스',
      emoji: '💧',
      keyword: '새로운 감정 · 사랑의 시작',
      message: '마음의 샘이 열리고 있어. 맑은 물이 넘쳐흐르듯 새로운 감정이 피어나려 해. '
          '열린 마음으로 그것을 맞이해봐.',
      teddyComment: '마음의 샘이 열리면, 작은 감정도 큰 기적이 돼 💧',
      color: Color(0xFF90CAF9),
    ),

    TarotCard(
      name: '컵 2',
      emoji: '🫂',
      keyword: '연결 · 파트너십 · 상호 이해',
      message: '두 마음이 이어지는 순간이야. 컵을 마주 드는 것처럼 서로를 바라보는 것, '
          '그 작은 존중에서 진짜 관계가 시작돼.',
      teddyComment: '두 마음이 만날 때, 세상은 조금 더 따뜻해져 🫂',
      color: Color(0xFFBA68C8),
    ),

    TarotCard(
      name: '컵 3',
      emoji: '🥂',
      keyword: '우정 · 축하 · 공동체',
      message: '함께 웃고 나누는 기쁨은 혼자서는 가질 수 없는 선물이야. '
          '오늘은 소중한 사람과 컵을 부딪혀봐.',
      teddyComment: '누군가와 기쁨을 나눌 때, 행복은 배가 돼 🥂',
      color: Color(0xFFF48FB1),
    ),

    TarotCard(
      name: '컵 4',
      emoji: '🪷',
      keyword: '내면 몰입 · 무관심 · 탐색',
      message: '고개를 숙이고 있는 동안, 하늘에서 컵 하나가 내려오고 있을지도 몰라. '
          '잠시 눈을 들어봐. 바로 옆에 답이 놓여 있을 때도 있어.',
      teddyComment: '닫힌 마음을 잠시 열면, 새로운 기회가 들어와 🪷',
      color: Color(0xFF90A4AE),
    ),

    TarotCard(
      name: '컵 5',
      emoji: '😢',
      keyword: '상실 · 슬픔 · 후회',
      message: '흘려보낸 것에 머무는 마음, 충분히 이해해. 실컷 울어도 괜찮아. '
          '하지만 울고 나서는, 아직 서 있는 두 개의 컵을 봐줘.',
      teddyComment: '상실은 아프지만, 여전히 남은 희망도 있어 😢',
      color: Color(0xFF78909C),
    ),

    TarotCard(
      name: '컵 6',
      emoji: '🌼',
      keyword: '추억 · 순수 · 향수',
      message: '과거의 따뜻한 기억이 마음을 데워줄 때야. '
          '그 기억을 품되, 발걸음도 함께 앞으로 나아가줘.',
      teddyComment: '추억은 마음을 데워주지만, 거기 머물면 발걸음이 멈춰 🌼',
      color: Color(0xFFFFD54F),
    ),

    TarotCard(
      name: '컵 7',
      emoji: '🫧',
      keyword: '환상 · 선택 · 혼란',
      message: '일곱 가지 꿈이 눈앞에 떠다니고 있어. 모든 컵을 가질 수는 없지만, '
          '단 하나의 진실은 선택할 수 있어. 네 마음이 가장 원하는 소리를 들어봐.',
      teddyComment: '유혹과 환상 속에서도 진짜 원하는 게 뭔지 들어봐 🫧',
      color: Color(0xFFAB47BC),
    ),

    TarotCard(
      name: '컵 8',
      emoji: '🌄',
      keyword: '떠남 · 탐색 · 내면 추구',
      message: '쌓아온 것들을 뒤로 두고 새로운 길을 향해 걸어가는 때야. '
          '무언가를 떠나야 새로운 세상이 열려. 달빛이 길을 비춰줄 거야.',
      teddyComment: '때로는 떠남이 곧 성장이야 🌄',
      color: Color(0xFF42A5F5),
    ),

    TarotCard(
      name: '컵 9',
      emoji: '😊',
      keyword: '만족 · 성취 · 감정적 풍요',
      message: '마음이 충만한 때야. 네가 가진 것들을 감사하는 순간, 이미 풍요는 시작돼. '
          '진짜 만족은 마음 깊은 곳에서 와.',
      teddyComment: '네가 가진 것을 감사하는 순간, 이미 풍요는 시작돼 😊',
      color: Color(0xFFFFEB3B),
    ),

    TarotCard(
      name: '컵 10',
      emoji: '🌈',
      keyword: '사랑의 완성 · 조화 · 행복',
      message: '무지개 아래 모든 사람이 함께 서 있는 그 그림. '
          '진짜 행복은 함께 웃을 때 완성돼. 사랑이 있는 곳이 바로 집이야.',
      teddyComment: '진짜 행복은 함께 웃을 때 완성돼 🌈',
      color: Color(0xFF29B6F6),
    ),

    TarotCard(
      name: '컵 시종',
      emoji: '🐟',
      keyword: '순수한 감정 · 직관 · 호기심',
      message: '컵 속에서 금빛 물고기가 튀어나오는 걸 보고 놀랐어? '
          '작은 놀라움 속에도 마음을 흔드는 선물이 숨어 있어. 감정에 솔직해져봐.',
      teddyComment: '호기심과 순수함을 잃지 마. 그게 네 가장 큰 힘이야 🐟',
      color: Color(0xFF81D4FA),
    ),

    TarotCard(
      name: '컵 기사',
      emoji: '🕊️',
      keyword: '로맨스 · 이상 추구 · 헌신',
      message: '이상을 향해 물 위를 달리는 것처럼 감정에 충실한 때야. '
          '꿈을 좇되 현실을 놓치지 않는 균형도 함께 가져가줘.',
      teddyComment: '이상은 때로 멀어 보여도, 그 열정은 늘 빛나 🕊️',
      color: Color(0xFF0288D1),
    ),

    TarotCard(
      name: '컵 여왕',
      emoji: '🐚',
      keyword: '직관 · 공감 · 치유',
      message: '파도가 출렁여도 조개 모양 컵을 놓지 않는 곰돌이처럼, '
          '타인의 마음을 감싸려면 먼저 내 마음부터 편안해야 해.',
      teddyComment: '감정을 읽고 돌보는 힘이 강해지고 있어 🐚',
      color: Color(0xFF6A1B9A),
    ),

    TarotCard(
      name: '컵 왕',
      emoji: '🌊',
      keyword: '감정의 균형 · 지혜 · 포용',
      message: '거친 파도 속에서도 잔잔하게 컵을 드는 것처럼, '
          '진정한 힘은 흔들림 속에서도 균형을 지키는 마음이야.',
      teddyComment: '불안정한 환경에서도 침착함을 잃지 마 🌊',
      color: Color(0xFF5E35B1),
    ),


    // ═══════════════════════════════════════════
    // MINOR ARCANA — SWORDS (소드 · 바람의 슈트)
    // ═══════════════════════════════════════════

    TarotCard(
      name: '소드 에이스',
      emoji: '🗡️',
      keyword: '진실 · 명확성 · 결단',
      message: '안개가 걷히고 빛이 비추는 것처럼, 흐릿하던 것이 뚜렷해지는 때야. '
          '진실은 날카롭지만 길을 밝혀주는 빛이 되기도 해. 지금 마음을 분명히 해봐.',
      teddyComment: '진실의 칼은 휘두르는 게 아니라, 길을 가리키는 빛이야 🗡️',
      color: Color(0xFF90A4AE),
    ),

    TarotCard(
      name: '소드 2',
      emoji: '🙈',
      keyword: '갈등 · 선택 · 양가감정',
      message: '두 개의 칼을 양손에 들고 눈을 감은 채 서 있어. '
          '결정은 두려움을 동반하지만, 눈을 뜨면 길은 보여. 잠시 고요 속에서 중심을 잡아봐.',
      teddyComment: '결정은 두려움을 동반하지만, 눈을 뜨면 길은 보여 🙈',
      color: Color(0xFF455A64),
    ),

    TarotCard(
      name: '소드 3',
      emoji: '💔',
      keyword: '슬픔 · 상실 · 진실의 아픔',
      message: '마음이 아파. 충분히 아파해도 괜찮아. '
          '눈물 속에서도 배움이 있고, 회복이 와. 마음이 아플수록 사랑은 더 단단해져.',
      teddyComment: '비가 그치면, 상처 입은 마음을 조심스레 감싸 안을게 💔',
      color: Color(0xFFC62828),
    ),

    TarotCard(
      name: '소드 4',
      emoji: '🛏️',
      keyword: '휴식 · 회복 · 재충전',
      message: '잠시 멈추고 마음을 재정비해도 괜찮아. '
          '휴식은 게으름이 아니라 회복이야. 움직임도 중요하지만, 고요 속에서 더 큰 힘이 자라.',
      teddyComment: '쉬는 것도 중요한 일이야. 오늘은 충분히 쉬어 🛏️',
      color: Color(0xFF616161),
    ),

    TarotCard(
      name: '소드 5',
      emoji: '😶',
      keyword: '갈등 · 승리와 패배 · 자존심',
      message: '이긴 것처럼 보여도, 돌아서는 친구들의 발걸음 소리가 마음에 걸려. '
          '진짜 승리는 혼자가 아닌 함께일 때 완성돼. 이겼어도 마음을 잃지 않도록 해줘.',
      teddyComment: '이길 수도 있지만, 마음을 잃지 않도록 조심해 😶',
      color: Color(0xFF607D8B),
    ),

    TarotCard(
      name: '소드 6',
      emoji: '🚣',
      keyword: '이동 · 변화 · 회복',
      message: '강을 건너는 거야. 뒤돌아보지 않아도 돼. '
          '과거의 강을 건너면 새로운 지평이 열려. 때로는 앞으로만 가야 마음이 가벼워져.',
      teddyComment: '과거의 강을 건너면 새로운 지평이 열려 🚣',
      color: Color(0xFF0288D1),
    ),

    TarotCard(
      name: '소드 7',
      emoji: '🦊',
      keyword: '속임수 · 회피 · 비밀',
      message: '모든 걸 드러내지 않는 상황. 때론 교묘함이 필요할 때도 있어. '
          '하지만 모든 진실은 언젠가 빛 속으로 나와. 숨기기보다 솔직함이 더 큰 힘이 될 때가 있어.',
      teddyComment: '진실은 언젠가 빛 속으로 나오더라 🦊',
      color: Color(0xFF607D8B),
    ),

    TarotCard(
      name: '소드 8',
      emoji: '🪢',
      keyword: '속박 · 두려움 · 갇힘',
      message: '갇혀 있다고 느껴지지만, 그 울타리가 사실 네가 만든 것일 수도 있어. '
          '마음을 열면, 검 사이로 넓은 길이 보여. 진짜 감옥은 두려움 안에 있거든.',
      teddyComment: '마음을 열면, 길은 언제나 있어 🪢',
      color: Color(0xFF37474F),
    ),

    TarotCard(
      name: '소드 9',
      emoji: '😰',
      keyword: '불안 · 악몽 · 두려움',
      message: '밤에 마음을 괴롭히는 것들, 실제보다 훨씬 크게 느껴지는 거야. '
          '두려움은 진짜가 아니라 마음의 그림자일 수 있어. 새벽은 언제나 와.',
      teddyComment: '밤은 두려움을 크게 보이게 하지만, 새벽은 언제나 와 😰',
      color: Color(0xFF212121),
    ),

    TarotCard(
      name: '소드 10',
      emoji: '🌅',
      keyword: '끝 · 파국 · 새로운 시작',
      message: '한 싸움이 완전히 끝났어. 고통스럽지만, '
          '가장 깊은 어둠 뒤에 새벽이 찾아와. 끝은 언제나 새로운 시작의 문턱이야.',
      teddyComment: '가장 깊은 어둠 뒤에, 새벽이 찾아와 🌅',
      color: Color(0xFFFFB300),
    ),

    TarotCard(
      name: '소드 시종',
      emoji: '🔍',
      keyword: '호기심 · 탐구 · 새로운 생각',
      message: '서툴지만 반짝이는 눈빛으로 하늘을 바라보는 때야. '
          '호기심은 성장의 첫 걸음이야. 지금은 배움의 열정을 놓치지 마.',
      teddyComment: '서툴지만, 지금의 열정을 놓치지 마 🔍',
      color: Color(0xFF4FC3F7),
    ),

    TarotCard(
      name: '소드 기사',
      emoji: '⚡',
      keyword: '돌진 · 결단 · 빠른 행동',
      message: '바람을 가르며 달려나가는 에너지가 넘쳐. '
          '속도는 힘이지만, 방향이 없다면 바람일 뿐이야. 과감함과 조율된 방향성이 함께 있어야 해.',
      teddyComment: '과감함은 필요하지만, 방향도 함께 가져가 ⚡',
      color: Color(0xFF1976D2),
    ),

    TarotCard(
      name: '소드 여왕',
      emoji: '🌬️',
      keyword: '지혜 · 명확성 · 솔직함',
      message: '바람결에 스치는 듯한 눈빛은 맑고 단호해. '
          '진실은 때로 차갑지만 가장 명확한 빛이야. 마음을 열면서도 분별력을 잃지 마.',
      teddyComment: '차가워 보여도, 그게 네 방식의 사랑이야 🌬️',
      color: Color(0xFF9E9E9E),
    ),

    TarotCard(
      name: '소드 왕',
      emoji: '👁️',
      keyword: '권위 · 이성 · 명확한 판단',
      message: '흔들림 없는 눈빛으로 공정하게 판단할 때야. '
          '진정한 힘은 공정함과 이성 속에서 나와. 강함 속에서도 따뜻함을 잃지 않는 것이 리더의 길이야.',
      teddyComment: '강함 속에서도 따뜻함을 잃지 않는 것이 진짜 리더야 👁️',
      color: Color(0xFF455A64),
    ),


    // ═══════════════════════════════════════════
    // MINOR ARCANA — PENTACLES (펜타클 · 흙의 슈트)
    // ═══════════════════════════════════════════

    TarotCard(
      name: '펜타클 에이스',
      emoji: '🪙',
      keyword: '현실적 기회 · 물질적 시작',
      message: '손바닥에 반짝이는 씨앗 같은 동전이 놓여 있어. '
          '기회는 심을 때 기회가 돼. 작게라도 오늘 심으면 내일의 그림이 달라져.',
      teddyComment: '작은 씨앗 하나가 숲이 될 수 있어 🪙',
      color: Color(0xFFFBC02D),
    ),

    TarotCard(
      name: '펜타클 2',
      emoji: '🤹',
      keyword: '균형 · 자원관리 · 우선순위',
      message: '두 가지를 동시에 저글링하며 파도 앞에서 균형을 잡는 때야. '
          '균형은 고정이 아니라 계속 조율하는 춤이야. 작은 리듬을 찾아봐.',
      teddyComment: '작은 리듬을 만들면 큰 파도도 잔잔해져 🤹',
      color: Color(0xFF8BC34A),
    ),

    TarotCard(
      name: '펜타클 3',
      emoji: '🏗️',
      keyword: '협업 · 기술 · 성과',
      message: '각자의 역할이 모여 결과물을 만드는 시간이야. '
          '혼자 솜씨보다 함께 완성도가 더 높아져. 역할을 명확히 나누면 속도가 붙어.',
      teddyComment: '함께 만든 것은 더 단단하고 아름다워 🏗️',
      color: Color(0xFFA1887F),
    ),

    TarotCard(
      name: '펜타클 4',
      emoji: '🤲',
      keyword: '소유 · 집착 · 안정 추구',
      message: '지켜내려는 마음은 소중해. 하지만 과도하면 흐름이 막혀. '
          '쥐는 힘을 조금만 풀면, 손이 다시 따뜻해져. 안정은 흐름이 있을 때 더 오래가.',
      teddyComment: '쥐는 힘을 조금만 풀면, 손이 다시 따뜻해져 🤲',
      color: Color(0xFFFFCA28),
    ),

    TarotCard(
      name: '펜타클 5',
      emoji: '❄️',
      keyword: '결핍 · 고독 · 어려움',
      message: '눈 내리는 거리가 차갑지만, 창문 너머엔 불빛이 있어. '
          '도움을 청하는 건 약함이 아니라 용기야. 따뜻한 문을 두드려봐.',
      teddyComment: '차가운 밤에도 창문 너머엔 불빛이 있어 ❄️',
      color: Color(0xFF78909C),
    ),

    TarotCard(
      name: '펜타클 6',
      emoji: '🍯',
      keyword: '나눔 · 공평 · 균형',
      message: '저울을 들고 꿀을 나누어 주는 모습이 아름다워. '
          '진짜 나눔은 저울이 필요 없을 때 드러나. 받는 법을 배우는 것도 성장이야.',
      teddyComment: '받는 법을 배우는 것도 성장이야 🍯',
      color: Color(0xFFFBC02D),
    ),

    TarotCard(
      name: '펜타클 7',
      emoji: '🌿',
      keyword: '인내 · 중간 점검 · 성장 과정',
      message: '열매는 자라고 있어. 잠시 삽을 내려놓고 숨을 돌려봐. '
          '기다림도 일의 일부야. 중간 점검이 결과를 바꿔.',
      teddyComment: '기다림도 일의 일부야. 열매는 자라고 있어 🌿',
      color: Color(0xFF558B2F),
    ),

    TarotCard(
      name: '펜타클 8',
      emoji: '🔨',
      keyword: '숙련 · 집중 · 장인정신',
      message: '동전을 하나하나 새기듯 몰입해서 실력을 쌓는 시간이야. '
          '반복이 실력을 만들어. 정성은 흔적을 남겨. 속도를 줄이면 완성도가 올라가.',
      teddyComment: '정성은 흔적을 남겨. 지금 그 노력이 쌓이고 있어 🔨',
      color: Color(0xFFFFA000),
    ),

    TarotCard(
      name: '펜타클 9',
      emoji: '🦜',
      keyword: '자립 · 풍요 · 여유',
      message: '스스로 일군 정원에서 여유와 만족을 누리는 때야. '
          '풍요는 물건이 아니라 누리는 마음이야. 자립은 혼자라는 뜻이 아니라 스스로 서는 힘이야.',
      teddyComment: '풍요는 물건이 아니라, 누리는 마음이야 🦜',
      color: Color(0xFF689F38),
    ),

    TarotCard(
      name: '펜타클 10',
      emoji: '🏡',
      keyword: '완성 · 가족 · 유산 · 안정',
      message: '세대가 이어지는 안정과 완성의 시간이야. '
          '진짜 유산은 함께 쌓은 기억이야. 안정은 관계에서 완성돼.',
      teddyComment: '진짜 유산은 함께 쌓은 기억이야 🏡',
      color: Color(0xFFF57C00),
    ),

    TarotCard(
      name: '펜타클 시종',
      emoji: '🌰',
      keyword: '학습 · 실용적 계획 · 기초',
      message: '작은 씨앗을 손에 쥔 것처럼, 작지만 현실적인 시작이야. '
          '아직 열매는 없지만 땅에 심으면 자랄 걸 알아. 오늘의 작은 걸음이 큰 미래가 돼.',
      teddyComment: '작은 씨앗 하나가 숲이 될 수 있어 🌰',
      color: Color(0xFFFF9800),
    ),

    TarotCard(
      name: '펜타클 기사',
      emoji: '🐂',
      keyword: '근면함 · 인내 · 성실한 노력',
      message: '묵묵히 밭을 가는 것처럼, 눈에 띄는 성과는 없어도 '
          '땅은 조금씩 옥토로 변하고 있어. 꾸준한 마음이 결국 결실을 맺어.',
      teddyComment: '꾸준한 마음이 결국 결실을 맺어 🐂',
      color: Color(0xFF5D4037),
    ),

    TarotCard(
      name: '펜타클 여왕',
      emoji: '🧺',
      keyword: '풍요 · 배려 · 실질적 돌봄',
      message: '따뜻한 배려와 현실적인 도움을 나누는 때야. '
          '돌봄은 자신에게도 필요해. 진짜 풍요는 함께 나눌 때 완성돼.',
      teddyComment: '진짜 풍요는 함께 나눌 때 완성돼 🧺',
      color: Color(0xFF43A047),
    ),

    TarotCard(
      name: '펜타클 왕',
      emoji: '🌾',
      keyword: '안정된 성취 · 풍요의 책임',
      message: '땀 흘린 만큼 결실이 있었고, 이제는 그걸 나눌 차례야. '
          '성취의 크기는 함께 웃는 이들로 정해져. 풍요도 함께할 때 의미가 있어.',
      teddyComment: '성취의 크기는 함께 웃는 이들로 정해져 🌾',
      color: Color(0xFF6D4C41),
    ),

  ];

// ============================================================
// 총 78장
// Major Arcana    : 22장 (바보 ~ 세계)
// Minor · Wands   : 14장 (에이스 ~ 왕)
// Minor · Cups    : 14장 (에이스 ~ 왕)
// Minor · Swords  : 14장 (에이스 ~ 왕)
// Minor · Pentacles : 14장 (에이스 ~ 왕)
// ============================================================

}