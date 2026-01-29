class AppStrings {
  static String currentLang = 'ko'; // 기본 언어

  static const Map<String, Map<String, String>> localized = {
    'ko': {
      'chat_greeting': '안녕 반가워. 오늘은 무슨 이야기를 해줄꺼야 ? 🧸',
      'diary_greeting' : "어느 일기를 같이 읽어볼까 ? 🧸",
      'error_api': '곰돌이가 잠시 쉬고 있어요... 🧸 잠시 후 다시 시도해주세요.',
      'loading': '잠시만 기다려주세요...',
    },
    'en': {
      'chat_greeting': 'Hello there. Nice to meet you. What are we going to talk about today? 🧸',
      'error_api': 'The bear is taking a nap... 🧸 Please try again later.',
      'loading': 'Please wait a moment...',
    },
    'ja': {
      'chat_greeting': '今日はどんなお話をしてくれますか？ 🧸',
      'error_api': 'クマさんは少し休憩中です... 🧸 しばらくしてからお試しください。',
      'loading': '少々お待ちください...',
    },
  };

  static String tr(String key) =>
  // 현재 언어의 맵 전체를 꺼냅니다. 해당안에서
      localized[currentLang]?[key] ?? localized['en']![key]!;
}


