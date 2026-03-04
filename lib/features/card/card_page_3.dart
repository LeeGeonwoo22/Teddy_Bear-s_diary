import 'package:flutter/material.dart';
import 'package:teddyBear/features/card/model/tarot_class.dart';
import 'package:teddyBear/features/card/widgets/card_back.dart';
import 'package:teddyBear/features/card/widgets/card_front.dart';
import 'package:teddyBear/features/card/widgets/deck_illust.dart';
import 'dart:math';
import '../../core/common/appColors.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';
import 'data/deck.dart';
import 'model/card_record.dart';
import 'model/category.dart';

enum _PageState { intro, ready, drawing, revealed }

class CardReadingPage_3 extends StatefulWidget {
  const CardReadingPage_3({super.key});

  @override
  State<CardReadingPage_3> createState() => _CardReadingPage_3State();
}

class _CardReadingPage_3State extends State<CardReadingPage_3>
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
    _shuffled = List.from(CardDeck.deck)..shuffle(Random());

    _floatCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5.0, end: 5.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _flipCtrl = AnimationController(duration: const Duration(milliseconds: 750), vsync: this);
    _flipAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));

    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));

    _dialogueController = DialogueController();
    _setIntroDialogues();
  }

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
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [BoxShadow(
              color: AppColors.brown.withOpacity(0.12),
              blurRadius: 20, offset: const Offset(0, 8),
            )],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 곰돌이 말풍선
              Row(children: [
                const Text('🧸', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 8),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    '어떤 고민이 제일 마음에 걸려?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
                  ),
                )),
              ]),
              const SizedBox(height: 16),
              // 카테고리 리스트
              ...QCategories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _showQuestionPopup(category);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Text(category.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(category.name, style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkBrown,
                      )),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.softBrown.withOpacity(0.5)),
                    ]),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── 세부 질문 팝업 ──────────────────────────────────
  void _showQuestionPopup(CardCategory category) {
    final questions = category.questions;
    final isEtc = category.isEtc;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [BoxShadow(
              color: AppColors.brown.withOpacity(0.12),
              blurRadius: 20, offset: const Offset(0, 8),
            )],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 곰돌이 말풍선
              Row(children: [
                const Text('🧸', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 8),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    isEtc ? '고민을 적어줘! Yes/No로 답할 수 있게 써줘 :)' : '어떤 부분이 궁금해?',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
                  ),
                )),
              ]),
              const SizedBox(height: 16),

              if (isEtc) ...[
                // 텍스트 입력
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _etcController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13, color: AppColors.darkBrown),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '예) 이 일을 계속하는 게 맞을까?',
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.softBrown.withOpacity(0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 툴팁
                Row(children: [
                  Icon(Icons.lightbulb_outline, size: 13, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Expanded(child: Text(
                    'Yes / No로 답할 수 있도록 질문을 작성해주세요',
                    style: TextStyle(fontSize: 11, color: AppColors.softBrown.withOpacity(0.7)),
                  )),
                ]),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    final q = _etcController.text.trim();
                    if (q.isEmpty) return;
                    Navigator.pop(ctx);
                    _onQuestionSelected(category, q);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(child: Text('확인', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14,
                    ))),
                  ),
                ),
              ] else ...[
                // 질문 리스트
                ...questions.map((q) => GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _onQuestionSelected(category, q);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Text('•  ', style: TextStyle(color: AppColors.softBrown, fontSize: 16)),
                      Expanded(child: Text(q, style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkBrown,
                      ))),
                    ]),
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onQuestionSelected(CardCategory category, String question) {
    _selectedCategory = category;
    _selectedQuestion = question;
    _shuffled.shuffle(Random());
    _drawnCard = _shuffled.first;
    _flipCtrl.reset();
    _slideCtrl.reset();
    setState(() => _pageState = _PageState.ready);
    _dialogueController.setDialogues([
      '"$question"\n음... 그렇구나.. 알았어 이제 한번 시작해볼까? 🧸',
      '마음속으로 진지하게 몰입해줘..\n그리고 준비되었으면 카드를 클릭해줘 ✨',
    ]);
  }

  void _onCardTap() {
    if (_pageState != _PageState.ready && _pageState != _PageState.drawing) return;
    setState(() => _pageState = _PageState.drawing);
    _flipCtrl.forward().then((_) {
      setState(() => _pageState = _PageState.revealed);
      _slideCtrl.forward();
      _dialogueController.setDialogues([
        '${_drawnCard!.name} 카드야 ${_drawnCard!.emoji}',
        _drawnCard!.message,
        _drawnCard!.teddyComment,
      ]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              _buildTeddy(),
              const SizedBox(height: 32),
              _buildCardArea(),
              const SizedBox(height: 40),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildRecordList(),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }

  // ── 곰돌이 ──────────────────────────────────────────
  Widget _buildTeddy() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (ctx, child) =>
                Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
            child: const TeddyCharacter(size: 80),
          ),
          const SizedBox(width: 12),
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
    );
  }

  // ── 카드 영역 ────────────────────────────────────────
  Widget _buildCardArea() {
    if (_pageState == _PageState.intro) return DeckIllust();
    if (_pageState == _PageState.ready || _pageState == _PageState.drawing) {
      return Column(children: [
        // 선택된 질문 배지
        if (_selectedQuestion != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Text(_selectedCategory!.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(child: Text(
                _selectedQuestion!,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
              )),
            ]),
          ),
        const SizedBox(height: 24),
        _buildFlippableCard(),
      ]);
    }
    return _buildRevealedCard();
  }

  // 덱 일러스트


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



  // Widget _cardFront() {
  //   if (_drawnCard == null) return const SizedBox.shrink();
  //   return Container(
  //     width: 140, height: 210,
  //     decoration: BoxDecoration(
  //       color: AppColors.cardBg,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: _drawnCard!.color.withOpacity(0.6), width: 2),
  //       boxShadow: [BoxShadow(
  //         color: _drawnCard!.color.withOpacity(0.22),
  //         blurRadius: 20, offset: const Offset(0, 8),
  //       )],
  //     ),
  //     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       Text(_drawnCard!.emoji, style: const TextStyle(fontSize: 48)),
  //       const SizedBox(height: 8),
  //       Text(_drawnCard!.name, style: const TextStyle(
  //         fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
  //       )),
  //       const SizedBox(height: 6),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //         decoration: BoxDecoration(
  //           color: _drawnCard!.color.withOpacity(0.2),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Text(_drawnCard!.keyword, style: TextStyle(
  //           fontSize: 11, color: _drawnCard!.color, fontWeight: FontWeight.w700,
  //         )),
  //       ),
  //     ]),
  //   );
  // }

  Widget _buildRevealedCard() {
    if (_drawnCard == null) return const SizedBox.shrink();
    return SlideTransition(
      position: _slideAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          CardFront(card: _drawnCard!),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _drawnCard!.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _drawnCard!.color.withOpacity(0.25)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(_drawnCard!.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text('${_drawnCard!.name} · ${_drawnCard!.keyword}',
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkBrown,
                    )),
              ]),
              const SizedBox(height: 12),
              Text(_drawnCard!.message, style: const TextStyle(
                fontSize: 14, color: AppColors.darkBrown, height: 1.7,
              )),
              Divider(height: 24, color: AppColors.border),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🧸 ', style: TextStyle(fontSize: 14)),
                Expanded(child: Text(_drawnCard!.teddyComment, style: TextStyle(
                  fontSize: 13, color: AppColors.softBrown,
                  fontStyle: FontStyle.italic, height: 1.5,
                ))),
              ]),
            ]),
          ),
        ]),
      ),
    );
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
    if (_records.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('아직 상담 기록이 없어 🧸',
            style: TextStyle(fontSize: 13, color: AppColors.softBrown.withOpacity(0.6))),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _records.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            // 날짜 배지
            Container(
              width: 42, padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bg, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(children: [
                Text('${r.date.month}월', style: TextStyle(
                  fontSize: 9, color: AppColors.softBrown.withOpacity(0.7), fontWeight: FontWeight.w500,
                )),
                Text('${r.date.day}', style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.1,
                )),
              ]),
            ),
            const SizedBox(width: 12),
            Text(r.card.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(r.card.name, style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
                  )),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: r.card.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.category, style: TextStyle(
                      fontSize: 10, color: r.card.color, fontWeight: FontWeight.w700,
                    )),
                  ),
                ]),
                const SizedBox(height: 3),
                Text(r.question, style: TextStyle(
                  fontSize: 11, color: AppColors.softBrown.withOpacity(0.8),
                ), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            )),
          ]),
        )).toList(),
      ),
    );
  }
}