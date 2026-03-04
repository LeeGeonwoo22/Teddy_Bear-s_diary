import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';

class EmotionGraphPage_4 extends StatefulWidget {
  const EmotionGraphPage_4({super.key});

  @override
  State<EmotionGraphPage_4> createState() => _EmotionGraphPage_4State();
}

class _EmotionGraphPage_4State extends State<EmotionGraphPage_4>
    with TickerProviderStateMixin {
  late DialogueController _dialogueController;
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;
  bool _isWeekly = true;

  // 동화 파스텔 컬러 팔레트
  static const Color _bg          = Color(0xFFFFF8F0);       // 크림 베이지
  static const Color _cloudPink   = Color(0xFFFFE4EE);       // 연한 핑크
  static const Color _softMint    = Color(0xFFE8F8F2);       // 민트
  static const Color _lavender    = Color(0xFFF0EAFF);       // 라벤더
  static const Color _peach       = Color(0xFFFFEDD8);       // 피치
  static const Color _brown       = Color(0xFF8B6F47);       // 브라운
  static const Color _softBrown   = Color(0xFFD4A97A);       // 소프트 브라운

  final List<Map<String, dynamic>> _emotions = [
    {'emoji': '😊', 'label': '괜찮아',    'color': Color(0xFFFFB347), 'pastel': Color(0xFFFFF3DC), 'story': '맑고 따뜻한 날'},
    {'emoji': '😢', 'label': '슬퍼',      'color': Color(0xFF87CEEB), 'pastel': Color(0xFFE8F4FD), 'story': '비 오는 오후'},
    {'emoji': '😤', 'label': '답답해',    'color': Color(0xFFFF9999), 'pastel': Color(0xFFFFEEEE), 'story': '구름 낀 하늘'},
    {'emoji': '🤔', 'label': '모르겠어',  'color': Color(0xFF98D8C8), 'pastel': Color(0xFFE8F8F2), 'story': '안개 낀 아침'},
    {'emoji': '😴', 'label': '그냥 그래', 'color': Color(0xFFCDABE8), 'pastel': Color(0xFFF5EEFF), 'story': '노을빛 저녁'},
  ];

  Map<String, int> _getMockStats() => _isWeekly
      ? {'😊': 3, '😢': 1, '😤': 2, '🤔': 1, '😴': 0}
      : {'😊': 12, '😢': 5, '😤': 7, '🤔': 3, '😴': 4};

  final List<Map<String, dynamic>> _weeklyData = [
    {'day': '월', 'emoji': '😤', 'value': 2.0},
    {'day': '화', 'emoji': '😊', 'value': 5.0},
    {'day': '수', 'emoji': '😊', 'value': 5.0},
    {'day': '목', 'emoji': '😢', 'value': 1.0},
    {'day': '금', 'emoji': '🤔', 'value': 3.0},
    {'day': '토', 'emoji': '😊', 'value': 5.0},
    {'day': '일', 'emoji': '😤', 'value': 2.0},
  ];

  @override
  void initState() {
    super.initState();

    // 둥실둥실 떠다니는 애니메이션
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "이번 주 너의 감정 동화책이야 🧸",
      "어떤 날이 가장 빛났어?",
      "모든 감정이 다 소중해 💛",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getMockStats();
    final filtered = Map.fromEntries(stats.entries.where((e) => e.value > 0));
    final total = filtered.isEmpty ? 1 : filtered.values.reduce((a, b) => a + b);
    final topEntry = filtered.isEmpty
        ? null
        : filtered.entries.reduce((a, b) => a.value > b.value ? a : b);
    final topEmotion = topEntry == null
        ? null
        : _emotions.firstWhere((e) => e['emoji'] == topEntry.key,
        orElse: () => _emotions.first);

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // 배경 구름 장식들
            _buildBackgroundDecorations(),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 0,
                  floating: true,
                  title: const Text(
                    '✨ 감정 그래프',
                    style: TextStyle(
                      color: _brown,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  centerTitle: true,
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // ── 곰돌이 + 대사 ────────────────────
                      _buildTeddySection(),

                      // ── 오늘의 감정 동화 카드 ─────────────
                      if (topEmotion != null)
                        _buildStoryCard(topEmotion, topEntry!.value, total),

                      // ── 토글 ─────────────────────────────
                      _buildToggle(),

                      // ── 감정 구름 버블들 ──────────────────
                      _buildEmotionClouds(filtered, total),

                      // ── 라인 차트 (물결 느낌) ──────────────
                      _buildWaveChart(),

                      // ── 하루하루 일기 카드 ────────────────
                      _buildDailyCards(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── 배경 장식 ────────────────────────────────────────
  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -30, right: -30,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _cloudPink.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: 100, left: -40,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _lavender.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: 300, right: -20,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _softMint.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 곰돌이 섹션 ──────────────────────────────────────
  Widget _buildTeddySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 둥실둥실 곰돌이
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: child,
            ),
            child: const TeddyCharacter(size: 90),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DialogueBox(
              controller: _dialogueController,
              characterName: '곰돌이',
              onDialogueEnd: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ── 동화 스타일 대표 감정 카드 ───────────────────────
  Widget _buildStoryCard(Map<String, dynamic> emotion, int count, int total) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: emotion['pastel'] as Color,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: (emotion['color'] as Color).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (emotion['color'] as Color).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 왼쪽 - 이모지 + 장식
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (emotion['color'] as Color).withOpacity(0.2),
                ),
              ),
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnim.value * 0.5),
                  child: Text(
                    emotion['emoji'],
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // 오른쪽 - 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isWeekly ? '이번 주 이야기' : '이번 달 이야기',
                  style: TextStyle(
                    fontSize: 11,
                    color: _softBrown.withOpacity(0.8),
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emotion['story'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _brown,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"${emotion['label']}" 감정이\n가장 많았어',
                  style: TextStyle(
                    fontSize: 12,
                    color: _softBrown.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (emotion['color'] as Color).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count번 · ${(count / total * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _brown,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 토글 ─────────────────────────────────────────────
  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _toggleChip('🌸 주간', true),
          const SizedBox(width: 10),
          _toggleChip('🌙 월간', false),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool isWeekly) {
    final isSelected = _isWeekly == isWeekly;
    return GestureDetector(
      onTap: () => setState(() {
        _isWeekly = isWeekly;
        _fadeController.forward(from: 0.4);
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _brown : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _brown.withOpacity(isSelected ? 0.25 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _softBrown,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── 감정 구름 버블 ───────────────────────────────────
  Widget _buildEmotionClouds(Map<String, int> stats, int total) {
    final orderedEmotions =
    _emotions.where((e) => stats.containsKey(e['emoji'])).toList();
    if (orderedEmotions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀
          Row(
            children: [
              const Text('🌈 ', style: TextStyle(fontSize: 16)),
              const Text(
                '감정 구름',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 구름 버블들
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: orderedEmotions.map((e) {
              final count = stats[e['emoji']] ?? 0;
              final percent = (count / total * 100).round();
              final size = 64.0 + (count / total * 40);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: e['pastel'] as Color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (e['color'] as Color).withOpacity(0.35),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (e['color'] as Color).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e['emoji'],
                            style: TextStyle(fontSize: size * 0.35)),
                        Text(
                          '$count회',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _brown.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e['label'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _softBrown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 9,
                      color: _softBrown.withOpacity(0.6),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── 물결 라인 차트 ───────────────────────────────────
  Widget _buildWaveChart() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _brown.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📈 ', style: TextStyle(fontSize: 16)),
              const Text(
                '감정의 흐름',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _brown,
                ),
              ),
              const Spacer(),
              Text(
                _isWeekly ? '7일간' : '30일간',
                style: TextStyle(
                  fontSize: 11,
                  color: _softBrown.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                minY: 0, maxY: 6,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: const Color(0xFFF5EDE3),
                    strokeWidth: 1.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _weeklyData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _weeklyData[index]['emoji'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _weeklyData.asMap().entries
                        .map((e) => FlSpot(
                      e.key.toDouble(),
                      e.value['value'] as double,
                    ))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.5,
                    color: _softBrown,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: _softBrown,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _softBrown.withOpacity(0.15),
                          _softBrown.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 하루하루 동화 카드 ───────────────────────────────
  Widget _buildDailyCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('📖 ', style: TextStyle(fontSize: 16)),
              Text(
                '하루하루 이야기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._weeklyData.map((item) {
            final emotionData = _emotions.firstWhere(
                  (e) => e['emoji'] == item['emoji'],
              orElse: () => _emotions.first,
            );
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: emotionData['pastel'] as Color,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: (emotionData['color'] as Color).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  // 요일
                  SizedBox(
                    width: 24,
                    child: Text(
                      item['day'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _softBrown.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 이모지
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  // 감정 이름
                  Text(
                    emotionData['label'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _brown,
                    ),
                  ),
                  const Spacer(),
                  // 프로그레스 바
                  SizedBox(
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (item['value'] as double) / 5.0,
                        backgroundColor:
                        (emotionData['color'] as Color).withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          (emotionData['color'] as Color).withOpacity(0.6),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}