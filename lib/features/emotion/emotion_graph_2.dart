import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';
import '../diary/bloc/diary_bloc.dart';
import '../diary/bloc/diary_state.dart';

class EmotionGraphPage_2 extends StatefulWidget {
  const EmotionGraphPage_2({super.key});

  @override
  State<EmotionGraphPage_2> createState() => _EmotionGraphPage_2State();
}

class _EmotionGraphPage_2State extends State<EmotionGraphPage_2>
    with SingleTickerProviderStateMixin {
  late DialogueController _dialogueController;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  bool _isWeekly = true;

  final List<Map<String, dynamic>> _emotions = [
    {'emoji': '😊', 'label': '괜찮아', 'color': Color(0xFFFFD54F)},
    {'emoji': '😢', 'label': '슬퍼', 'color': Color(0xFF90CAF9)},
    {'emoji': '😤', 'label': '답답해', 'color': Color(0xFFEF9A9A)},
    {'emoji': '🤔', 'label': '모르겠어', 'color': Color(0xFFA5D6A7)},
    {'emoji': '😴', 'label': '그냥 그래', 'color': Color(0xFFCE93D8)},
  ];

  // 목업 데이터
  Map<String, int> _getMockStats() {
    if (_isWeekly) {
      return {'😊': 3, '😢': 1, '😤': 2, '🤔': 1, '😴': 0};
    } else {
      return {'😊': 12, '😢': 5, '😤': 7, '🤔': 3, '😴': 4};
    }
  }

  List<Map<String, dynamic>> _getMockWeeklyEmojis() {
    final now = DateTime.now();
    final mockEmotions = ['😊', '😢', '', '😤', '😊', '', '🤔'];
    final result = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      result.add({
        'date': date,
        'emotion': mockEmotions[6 - i],
      });
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();

    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "이번 주 너의 감정을 살펴봤어 🧸",
      "어떤 감정이 가장 많았는지 볼까?",
      "네 마음이 잘 보이도록 그려봤어 💛",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getMockStats();
    final weeklyEmojis = _getMockWeeklyEmojis();
    final topEmotion = stats.entries.isNotEmpty
        ? stats.entries.reduce((a, b) => a.value > b.value ? a : b)
        : null;
    final topEmotionData = topEmotion != null
        ? _emotions.firstWhere((e) => e['emoji'] == topEmotion.key,
        orElse: () => _emotions.first)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE3),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── 헤더 ──────────────────────────────────
            SliverToBoxAdapter(
              child: _buildHeader(topEmotionData),
            ),

            // ── 곰돌이 + 다이얼로그 ───────────────────
            SliverToBoxAdapter(
              child: _buildTeddySection(),
            ),

            // ── 토글 ──────────────────────────────────
            SliverToBoxAdapter(
              child: _buildToggle(),
            ),

            // ── 비대칭 메인 섹션 ──────────────────────
            SliverToBoxAdapter(
              child: _buildAsymmetricSection(stats, weeklyEmojis),
            ),

            // ── 감정 요약 리스트 ──────────────────────
            SliverToBoxAdapter(
              child: _buildEmotionSummary(stats),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 60)),
          ],
        ),
      ),
    );
  }

  // ── 헤더 ──────────────────────────────────────────
  Widget _buildHeader(Map<String, dynamic>? topEmotionData) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
        color: Color(0xFF8B6F47),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 - 타이틀
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isWeekly ? '이번 주' : '이번 달',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '감정 리포트',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (topEmotionData != null)
                      Row(
                        children: [
                          Text(
                            topEmotionData['emoji'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${topEmotionData['label']} 이 가장 많았어',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // 오른쪽 - 큰 이모지
              if (topEmotionData != null)
                Text(
                  topEmotionData['emoji'],
                  style: const TextStyle(fontSize: 56),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 곰돌이 섹션 ───────────────────────────────────
  Widget _buildTeddySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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

  // ── 토글 ──────────────────────────────────────────
  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _toggleBtn('주간', true),
          const SizedBox(width: 8),
          _toggleBtn('월간', false),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool isWeekly) {
    final isSelected = _isWeekly == isWeekly;
    return GestureDetector(
      onTap: () => setState(() {
        _isWeekly = isWeekly;
        _animController.forward(from: 0.0);
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B6F47) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF8B6F47)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B6F47),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── 비대칭 메인 섹션 ──────────────────────────────
  Widget _buildAsymmetricSection(
      Map<String, int> stats, List<Map<String, dynamic>> weeklyEmojis) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 상단 비대칭 행: 차트(넓게) + 7일 이모지(좁게)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 왼쪽 - 막대차트 (넓게)
                Expanded(
                  flex: 3,
                  child: _buildBarChartCard(stats),
                ),
                const SizedBox(width: 12),
                // 오른쪽 - 7일 이모지 세로 (좁게)
                Expanded(
                  flex: 1,
                  child: _buildWeeklyEmojiColumn(weeklyEmojis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 막대 차트 카드
  Widget _buildBarChartCard(Map<String, int> stats) {
    if (stats.isEmpty || stats.values.every((v) => v == 0)) {
      return _buildEmptyCard();
    }

    final filteredStats = Map.fromEntries(
      stats.entries.where((e) => e.value > 0),
    );
    final maxY =
    filteredStats.values.reduce((a, b) => a > b ? a : b).toDouble();
    final orderedEmotions = _emotions
        .where((e) => filteredStats.containsKey(e['emoji']))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '감정 분포',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY + 1,
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
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < orderedEmotions.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              orderedEmotions[index]['emoji'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(orderedEmotions.length, (index) {
                  final emotion = orderedEmotions[index];
                  final count = filteredStats[emotion['emoji']] ?? 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        color: emotion['color'] as Color,
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7일 이모지 세로 컬럼
  Widget _buildWeeklyEmojiColumn(List<Map<String, dynamic>> weeklyEmojis) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8B6F47).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final item = weeklyEmojis[i];
          final date = item['date'] as DateTime;
          final emotion = item['emotion'] as String;
          final dayLabel = days[date.weekday - 1];
          return Column(
            children: [
              Text(
                emotion.isNotEmpty ? emotion : '·',
                style: TextStyle(
                  fontSize: emotion.isNotEmpty ? 20 : 14,
                  color: emotion.isEmpty ? Colors.grey.shade300 : null,
                ),
              ),
              Text(
                dayLabel,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 빈 상태 카드
  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧸', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            '아직 기록이 없어',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── 감정 요약 ──────────────────────────────────────
  Widget _buildEmotionSummary(Map<String, int> stats) {
    final filteredStats = Map.fromEntries(
      stats.entries.where((e) => e.value > 0),
    );
    if (filteredStats.isEmpty) return const SizedBox.shrink();

    final total = filteredStats.values.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀 - 잡지 스타일
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6F47),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '감정 요약',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5D4E37),
                  ),
                ),
              ],
            ),
          ),
          // 감정 카드들 - 2열 그리드
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: _emotions
                .where((e) => filteredStats.containsKey(e['emoji']))
                .map((e) {
              final count = filteredStats[e['emoji']] ?? 0;
              final percent = (count / total * 100).round();
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: (e['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (e['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(e['emoji'],
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e['label'],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D4E37),
                            ),
                          ),
                          Text(
                            '$count회 · $percent%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
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
}