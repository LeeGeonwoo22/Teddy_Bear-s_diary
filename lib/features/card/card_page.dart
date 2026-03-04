import 'package:flutter/material.dart';
import 'package:teddyBear/features/card/model/tarot_class.dart';
import 'package:teddyBear/features/card/widgets/RecordList.dart';
import 'package:teddyBear/features/card/widgets/card_back.dart';
import 'package:teddyBear/features/card/widgets/card_front.dart';
import 'package:teddyBear/features/card/widgets/category_dialog.dart';
import 'package:teddyBear/features/card/widgets/deck_illust.dart';
import 'package:teddyBear/features/card/widgets/question_badge.dart';
import 'package:teddyBear/features/card/widgets/question_dialog.dart';
import 'package:teddyBear/features/card/widgets/revealed_card_panel.dart';
import 'dart:math';
import '../../core/common/appColors.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';
import 'data/deck.dart';
import 'model/card_record.dart';
import 'model/category.dart';

enum _PageState { intro, ready, drawing, revealed }

class CardReadingPage extends StatefulWidget {
  const CardReadingPage({super.key});

  @override
  State<CardReadingPage> createState() => _CardReadingPageState();
}

class _CardReadingPageState extends State<CardReadingPage>
    with TickerProviderStateMixin {
  late DialogueController _dialogueController;
  late AnimationController _floatCtrl;
  late AnimationController _flipCtrl;
  late AnimationController _slideCtrl;
  late Animation<double> _flipAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _floatAnim;

  _PageState _pageState = _PageState.intro;
  CardCategory? _selectedCategory;
  String? _selectedQuestion;
  TarotCard? _drawnCard;
  List<TarotCard> _shuffled = [];
  final _etcController = TextEditingController();

  final List<CardRecord> _records = [
    CardRecord(date: DateTime(2026, 2, 20), category: '인간관계', question: '우리는 좋은 친구로 발전할 수 있을까?', card: CardDeck.deck[5]),
    CardRecord(date: DateTime(2026, 2, 15), category: '학업 / 성적', question: '이번 시험은 잘 볼 수 있을까?', card: CardDeck.deck[9]),
  ];

  @override
  void initState() {
    super.initState();
    // 🃏 카드 초기 셔플
    _shuffled = List.from(CardDeck.deck)..shuffle(Random());
    // 🧸 곰돌이 둥둥 애니메이션
    _floatCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5.0, end: 5.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    // 🃏 카드 뒤집기 애니메이션
    _flipCtrl = AnimationController(duration: const Duration(milliseconds: 750), vsync: this);
    _flipAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
    // 🃏 결과 카드 슬라이드 등장
    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    // 💬 다이얼로그 초기 설정
    _dialogueController = DialogueController();
    _setIntroDialogues();
  }
  // 💬 인트로 대사 설정
  void _setIntroDialogues() {
    _dialogueController.setDialogues([
      "안녕? 지금은 어떠니? 🧸",
      "뭐가 안 풀린 것처럼 마음이 답답하고 힘드니?",
      "그런 너를 위해 준비했어! 🎴",
      "매일 힘들어 하는 너를 위해 내가 직접 '고민 카드'들을 뽑아볼게..",
      "않좋은 카드가 나오더라도 너무 진지하게 생각하진 말아줘.. ㅎㅎ",
      "자, 이 중에 너를 제일 답답하게 만드는 고민은 무엇이니?",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _floatCtrl.dispose();
    _flipCtrl.dispose();
    _slideCtrl.dispose();
    _etcController.dispose();
    super.dispose();
  }

  // ── 카테고리 팝업 ───────────────────────────────────
  void _showCategoryPopup() {
    showCategoryDialog(
      context,
      onSelected: (category) => _showQuestionPopup(category),
    );
  }

  // ── 세부 질문 팝업 ──────────────────────────────────
  void _showQuestionPopup(CardCategory category) {
    showQuestionDialog(
      context,
      category: category,
      etcController: _etcController,
      onSelected: (category, question) => _onQuestionSelected(category, question),
    );
  }
  // ❓ 질문 선택 완료 처리
  void _onQuestionSelected(CardCategory category, String question) {
    _selectedCategory = category;
    _selectedQuestion = question;
    // 카드 다시 섞기
    _shuffled.shuffle(Random());
    _drawnCard = _shuffled.first;
    _flipCtrl.reset();
    _slideCtrl.reset();
    // 페이지 상태 변경
    setState(() => _pageState = _PageState.ready);
    // 다이얼로그 변경
    _dialogueController.setDialogues([
      '"$question"\n음... 그렇구나.. 알았어 이제 한번 시작해볼까? 🧸',
      '마음속으로 진지하게 몰입해줘..\n그리고 준비되었으면 카드를 클릭해줘 ✨',
    ]);
  }
  // 🃏 카드 클릭 시
  void _onCardTap() {
    if (_pageState != _PageState.ready && _pageState != _PageState.drawing) return;

    setState(() => _pageState = _PageState.drawing);

    _flipCtrl.forward().then((_) {
      setState(() => _pageState = _PageState.revealed);
      _slideCtrl.forward();
      // 결과 다이얼로그 출력
      _dialogueController.setDialogues([
        '${_drawnCard!.name} 카드야 ${_drawnCard!.emoji}',
        _drawnCard!.message,
        _drawnCard!.teddyComment,
      ]);
      // 상담 기록 저장
      _records.insert(0, CardRecord(
        date: DateTime.now(),
        category: _selectedCategory!.name,
        question: _selectedQuestion!,
        card: _drawnCard!,
      ));
    });
  }

  void _reset() {
    _etcController.clear();
    _flipCtrl.reset();
    _slideCtrl.reset();
    setState(() {
      _pageState = _PageState.intro;
      _selectedCategory = null;
      _selectedQuestion = null;
      _drawnCard = null;
    });
    _setIntroDialogues();
  }

  // 화면
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        // 🎯 하단 버튼 (카드 뽑기 / 다시 뽑기)
        floatingActionButton: _buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // 🧸 상단 앱바
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.bg,
              elevation: 0,
              floating: true,
              title: const Text('🃏 카드 상담',
                  style: TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.w800, fontSize: 18)),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Column(children: [
                _buildCardArea(),
                const SizedBox(height: 40),
                _buildDivider(),
                const SizedBox(height: 16),
                _buildRecordList(),
                const SizedBox(height: 16),
                _buildTeddy(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ── 곰돌이와 다이얼로그
  Widget _buildTeddy() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (ctx, child) =>
                Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
            child: const TeddyCharacter(size: 80),
          ),
          SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DialogueBox(
                  controller: _dialogueController,
                  characterName: '곰돌이',
                  onDialogueEnd: () {
                    // 인트로 대사 끝나면 팝업 자동 오픈
                    if (_pageState == _PageState.intro) {
                      Future.delayed(
                        const Duration(milliseconds: 400),
                        _showCategoryPopup,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 카드 영역 ────────────────────────────────────────
  Widget _buildCardArea() {
    if (_pageState == _PageState.intro) return DeckIllust();
    if (_pageState == _PageState.ready || _pageState == _PageState.drawing) {
      return Column(
          children : [
        // 선택된 질문 배지
        if (_selectedQuestion != null && _selectedCategory != null)
          QuestionBadge(
            category: _selectedCategory!,
            question: _selectedQuestion!,
          ),
        const SizedBox(height: 24),
        _buildFlippableCard(),
      ]);
    }
    return _buildRevealedCard();
  }
  // 플립 카드
  Widget _buildFlippableCard() {
    return GestureDetector(
      onTap: _onCardTap,
      child: AnimatedBuilder(
        animation: _flipAnim,
        builder: (ctx, _) {
          final angle = _flipAnim.value * pi;
          final isFront = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: CardFront(card: _drawnCard!),
            )
                : CardBack(floatAnim: _floatAnim),
          );
        },
      ),
    );
  }

  Widget _buildRevealedCard() {
    if (_drawnCard == null) return const SizedBox.shrink();
    return
      RevealedCardPanel(card: _drawnCard!, slideAnim: _slideAnim,);
  }

  // ── FAB ─────────────────────────────────────────────
  Widget? _buildFab() {
    if (_pageState == _PageState.intro) {
      return FloatingActionButton.extended(
        onPressed: _showCategoryPopup,
        backgroundColor: AppColors.brown,
        label: const Text('🃏 카드 뽑기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      );
    }
    if (_pageState == _PageState.revealed) {
      return FloatingActionButton.extended(
        onPressed: _reset,
        backgroundColor: AppColors.brown,
        label: const Text('🔄 다시 뽑기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      );
    }
    return null;
  }

  // ── 기록 구분선 ─────────────────────────────────────
  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(children: [
      const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('📜 상담 기록', style: TextStyle(
          fontSize: 12, color: AppColors.softBrown.withOpacity(0.7), fontWeight: FontWeight.w600,
        )),
      ),
      const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
    ]),
  );

  // ── 날짜별 기록 리스트 ───────────────────────────────
  Widget _buildRecordList() {
    return Recordlist(records: _records);
  }
}