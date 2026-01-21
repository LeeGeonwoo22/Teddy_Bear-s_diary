import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart' as DateHelper;
import 'package:teddyBear/features/diary/widgets/diaryCalendar.dart';
import 'package:teddyBear/features/diary/widgets/dummy.dart';
import '../../data/model/diary.dart';


class DiaryPage extends StatefulWidget {
  final Map<String, dynamic> diary;
  final VoidCallback onClose;

  const DiaryPage({
        super.key,
        required this.diary,
        required this.onClose,
  });

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentDialogueIndex = 0;
  String _displayedText = '';
  bool _isTyping = false;
  Timer? _typingTimer;
  int _charIndex = 0;
  List<String> _dialogues = [];

  @override
  void initState(){
    super.initState();
    // animation 컨트롤러
    _controller = AnimationController(duration : const Duration(milliseconds: 500), vsync: this,);
    _fadeAnimation = Tween<double>(begin: 0.0, end : 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // animation 등장
    _controller.forward();
    // 초기 대사
    _dialogues = ["어느 일기를 같이 읽어볼까 ? 🧸"];
    // 타이핑 효과
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
  // 1. 날짜 정규화 함수 (시/분/초를 0으로 맞춤)
  // DateTime _normalizeDate(DateTime date) {
  //   return DateTime(date.year, date.month, date.day);
  // }
  // 날짜별 일기 읽어주기
  void _handleDaySelected(DateTime selectedDay) {
    // 클릭한 날짜와 더미 데이터의 키 값을 동일하게 정규화
    final dateKey = DateHelper.normalizeDate((selectedDay));
    final diary = dummyDiaries[dateKey];
    // 타이머 중복 실행 방지
    _typingTimer?.cancel();
    setState(() {
      _currentDialogueIndex = 0;
      _charIndex = 0;
      _displayedText = ''; // 텍스트 초기화
      if (diary != null) {
        _dialogues = [
          '${selectedDay.month}월 ${selectedDay.day}일 일기를 읽어줄게',
          diary.title,
          ...diary.content.split('\n\n'),
          '오늘 하루 수고했어 💛',
        ];
      } else {
        _dialogues = ['이 날은 기록된 이야기가 없네.. 🧸'];
      }
    });
    // 애니메이션을 처음(0.0)부터 다시 실행 (중요!)
    _controller.forward(from: 0.0);
    _startTyping();
  }

  // 타이핑 효과 시작
  void _startTyping() {
    _typingTimer?.cancel();
    setState(() {
      _isTyping = true;
      _displayedText = '';
      _charIndex = 0;
    });

    final currentText = _dialogues[_currentDialogueIndex];

    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_charIndex < currentText.length) {
        setState(() {
          _displayedText = currentText.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTyping = false;
        });
      }
    });

  }

  void _nextDialogue() {
    // 타이핑 중이면 즉시 완료
    if (_isTyping) {
      _typingTimer?.cancel();
      setState(() {
        _displayedText = _dialogues[_currentDialogueIndex];
        _isTyping = false;
      });
      return;
    }
    if (_currentDialogueIndex >= _dialogues.length - 1) {
      _close();
      return;
    }
    setState(() {
      _currentDialogueIndex++;
    });
    _startTyping();
  }

  // 닫기
  void _close() {
    setState(() {
      _dialogues = ["어느 일기를 같이 읽어볼까 ? 🧸"];
      _currentDialogueIndex = 0;
      _displayedText = "";
    });

    _startTyping();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teddy Bear's Diary", style: TextStyle(
        color: Color(0xFF8B6F47),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF8B6F47)),
            onPressed: () {
              // 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 달력 영역 (화면의 상단 일부 차지)
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: DiaryCalendar(onDaySelected: (DateTime selectedDay) { _handleDaySelected(selectedDay); },),
              )),
          // 2. 대화창 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: _nextDialogue,
                child: Container(
                  // color: Colors.black54, // 이 색상 때문에 달력이 가려질 수 있으니 확인!
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Spacer(flex: 1), // flex 수치 조정
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildTeddyCharacter(),
                        ),
                        const SizedBox(height: 20),
                        _buildDialogueBox(),
                        // const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// 곰돌이 캐릭터
  Widget _buildTeddyCharacter() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -5 * (1 - value)),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4C4),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🧸',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
        );
      },
    );
  }

  // 대화창
  Widget _buildDialogueBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B6F47),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 화자 이름
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6F47),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '곰돌이',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 대사 텍스트
          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              child: Text(
                _displayedText + (_isTyping ? '▂' : ''),
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF5D4E37),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 진행 표시 + 다음 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 진행도 (3/10)
              Text(
                '${_currentDialogueIndex + 1}/${_dialogues.length}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),

              // 다음 버튼 (타이핑 완료 시만)
              if (!_isTyping)
                Row(
                  children: [
                    Text(
                      _currentDialogueIndex >= _dialogues.length - 1
                          ? '닫기'
                          : '다음',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B6F47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Color(0xFF8B6F47),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
