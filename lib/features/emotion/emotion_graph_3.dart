import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';

class EmotionGraphPage_3 extends StatefulWidget {
  const EmotionGraphPage_3({super.key});

  @override
  State<EmotionGraphPage_3> createState() => _EmotionGraphPage_3State();
}

class _EmotionGraphPage_3State extends State<EmotionGraphPage_3>
    with TickerProviderStateMixin {
  late DialogueController _dialogueController;
  late AnimationController _animController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isWeekly = true;

  final List<Map<String, dynamic>> _emotions = [
    {'emoji': '😊', 'label': '괜찮아',   'color': Color(0xFFFFB347), 'light': Color(0xFFFFF3E0)},
    {'emoji': '😢', 'label': '슬퍼',     'color': Color(0xFF64B5F6), 'light': Color(0xFFE3F2FD)},
    {'emoji': '😤', 'label': '답답해',   'color': Color(0xFFE57373), 'light': Color(0xFFFFEBEE)},
    {'emoji': '🤔', 'label': '모르겠어', 'color': Color(0xFF81C784), 'light': Color(0xFFE8F5E9)},
    {'emoji': '😴', 'label': '그냥 그래','color': Color(0xFFBA68C8), 'light': Color(0xFFF3E5F5)},
  ];

  Map<String, int> _getMockStats() => _isWeekly
      ? {'😊': 3, '😢': 1, '😤': 2, '🤔': 1, '😴': 0}
      : {'😊': 12, '😢': 5, '😤': 7, '🤔': 3, '😴': 4};

  // 라인차트용 주간 데이터 (감정을 숫자로: 😊=5, 🤔=4, 😴=3, 😢=2, 😤=1)
  final List<Map<String, dynamic>> _weeklyLine = [
    {'day': '월', 'value': 3.0, 'emoji': '😤'},
    {'day': '화', 'value': 5.0, 'emoji': '😊'},
    {'day': '수', 'value': 5.0, 'emoji': '😊'},
    {'day': '목', 'value': 2.0, 'emoji': '😢'},
    {'day': '금', 'value': 4.0, 'emoji': '🤔'},
    {'day': '토', 'value': 5.0, 'emoji': '😊'},
    {'day': '일', 'value': 3.0, 'emoji': '😤'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    _cardController.forward();

    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "이번 주 너의 감정 흐름이야 🧸",
      "어떤 날이 가장 힘들었어?",
      "그래도 잘 버텨줘서 고마워 💛",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _animController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getMockStats();
    final filteredStats = Map.fromEntries(stats.entries.where((e) => e.value > 0));
    final total = filteredStats.isEmpty ? 1 : filteredStats.values.reduce((a, b) => a + b);

    // 가장 많은 감정
    final topEntry = filteredStats.isEmpty
        ? null
        : filteredStats.entries.reduce((a, b) => a.value > b.value ? a : b);
    final topEmotion = topEntry == null
        ? null
        : _emotions.firstWhere((e) => e['emoji'] == topEntry.key,
        orElse: () => _emotions.first);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── SliverAppBar ─────────────────────────
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                backgroundColor: const Color(0xFFFAF6F1),
                elevation: 0,
                title: const Text(
                  '감정 리포트',
                  style: TextStyle(
                    color: Color(0xFF6D4C41),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                centerTitle: false,
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ── 곰돌이 + 다이얼로그 ─────────────
                    _buildTeddySection(),

                    // ── 오늘의 감정 하이라이트 카드 ──────
                    if (topEmotion != null)
                      _buildHighlightCard(topEmotion, topEntry!.value, total),

                    // ── 토글 ────────────────────────────
                    _buildToggle(),

                    // ── 라인 차트 ────────────────────────
                    _buildLineChartCard(),

                    // ── 감정별 버블 그리드 ───────────────
                    _buildBubbleGrid(filteredStats, total),

                    // ── 주간 흐름 타임라인 ───────────────
                    _buildWeekTimeline(),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 곰돌이 ──────────────────────────────────────────
  Widget _buildTeddySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const TeddyCharacter(size: 80),
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

  // ── 하이라이트 카드 ──────────────────────────────────
  Widget _buildHighlightCard(
      Map<String, dynamic> emotion, int count, int total) {
    final percent = (count / total * 100).round();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (emotion['color'] as Color).withOpacity(0.8),
            (emotion['color'] as Color).withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (emotion['color'] as Color).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emotion['emoji'], style: const TextStyle(fontSize: 52)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isWeekly ? '이번 주 대표 감정' : '이번 달 대표 감정',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emotion['label'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count회 · $percent%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 토글 ────────────────────────────────────────────
  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE0D4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _toggleBtn('주간', true),
            _toggleBtn('월간', false),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, bool isWeekly) {
    final isSelected = _isWeekly == isWeekly;
    return GestureDetector(
      onTap: () => setState(() {
        _isWeekly = isWeekly;
        _animController.forward(from: 0.3);
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF6D4C41)
                : const Color(0xFF6D4C41).withOpacity(0.5),
            fontWeight:
            isSelected ? FontWeight.w700 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── 라인 차트 ────────────────────────────────────────
  Widget _buildLineChartCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                const Text('감정 흐름',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5D4037),
                    )),
                const Spacer(),
                Text(
                  _isWeekly ? '최근 7일' : '최근 30일',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 6,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade100,
                    strokeWidth: 1,
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
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _weeklyLine.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _weeklyLine[index]['emoji'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem(
                      _weeklyLine[s.x.toInt()]['day'],
                      const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ))
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _weeklyLine.asMap().entries.map((e) {
                      return FlSpot(
                          e.key.toDouble(), e.value['value'] as double);
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: const Color(0xFFFFB347),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: const Color(0xFFFFB347),
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFB347).withOpacity(0.2),
                          const Color(0xFFFFB347).withOpacity(0.0),
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

  // ── 감정 버블 그리드 ─────────────────────────────────
  Widget _buildBubbleGrid(Map<String, int> stats, int total) {
    if (stats.isEmpty) return const SizedBox.shrink();

    final orderedEmotions =
    _emotions.where((e) => stats.containsKey(e['emoji'])).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정별 기록',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: orderedEmotions.map((e) {
              final count = stats[e['emoji']] ?? 0;
              final percent = (count / total * 100).round();
              // 버블 크기 비례
              final size = 48.0 + (count / total * 32);
              return Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: e['light'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (e['color'] as Color).withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          e['emoji'],
                          style: TextStyle(fontSize: size * 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count회',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: e['color'] as Color,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── 주간 흐름 타임라인 ───────────────────────────────
  Widget _buildWeekTimeline() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '하루하루 기록',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_weeklyLine.length, (i) {
            final item = _weeklyLine[i];
            final emotionData = _emotions.firstWhere(
                  (e) => e['emoji'] == item['emoji'],
              orElse: () => _emotions.first,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // 날짜
                  SizedBox(
                    width: 28,
                    child: Text(
                      item['day'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 이모지
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  // 감정 바
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (item['value'] as double) / 5.0,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          (emotionData['color'] as Color).withOpacity(0.7),
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 감정 레이블
                  SizedBox(
                    width: 48,
                    child: Text(
                      emotionData['label'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.right,
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