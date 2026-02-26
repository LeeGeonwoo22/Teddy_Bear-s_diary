import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';
import '../diary/bloc/diary_bloc.dart';
import '../diary/bloc/diary_state.dart';

class EmotionGraphPage extends StatefulWidget {
  const EmotionGraphPage({super.key});

  @override
  State<EmotionGraphPage> createState() => _EmotionGraphPageState();
}

class _EmotionGraphPageState extends State<EmotionGraphPage> {
  late DialogueController _dialogueController;

  // 감정 정의
  final List<Map<String, dynamic>> _emotions = [
    {'emoji': '😊', 'label': '괜찮아', 'color': Color(0xFFFFD54F)},
    {'emoji': '😢', 'label': '슬퍼', 'color': Color(0xFF90CAF9)},
    {'emoji': '😤', 'label': '답답해', 'color': Color(0xFFEF9A9A)},
    {'emoji': '🤔', 'label': '모르겠어', 'color': Color(0xFFA5D6A7)},
    {'emoji': '😴', 'label': '그냥 그래', 'color': Color(0xFFCE93D8)},
  ];

  // 상단에 토글 상태 추가
  bool _isWeekly = true;  // true = 주간, false = 월간

// 목업 데이터
  Map<String, int> _getMockStats() {
    if (_isWeekly) {
      return {
        '😊': 3,
        '😢': 1,
        '😤': 2,
        '🤔': 1,
        '😴': 0,
      };
    } else {
      return {
        '😊': 12,
        '😢': 5,
        '😤': 7,
        '🤔': 3,
        '😴': 4,
      };
    }
  }

  @override
  void initState() {
    super.initState();
    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "안녕! 이번 주 너의 감정을 살펴볼게 🧸",
      "어떤 감정이 가장 많았는지 같이 봐볼까?",
      "네 마음이 잘 보이도록 그려봤어 💛",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    super.dispose();
  }

  // DiaryState에서 최근 7일 감정 통계 계산
  Map<String, int> _getWeeklyStats(DiaryState state) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final stats = <String, int>{};

    for (var entry in state.diaries.entries) {
      if (entry.key.isAfter(weekAgo) &&
          entry.value.emotion != null &&
          entry.value.emotion!.isNotEmpty) {
        final emotion = entry.value.emotion!;
        stats[emotion] = (stats[emotion] ?? 0) + 1;
      }
    }
    return stats;
  }

  // 최근 7일 이모지 리스트 (날짜순)
  List<Map<String, dynamic>> _getWeeklyEmojis(DiaryState state) {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final diary = state.diaries[date];
      result.add({
        'date': date,
        'emotion': diary?.emotion ?? '',
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryBloc, DiaryState>(
      builder: (context, state) {
        final weeklyStats = _getMockStats();
        final weeklyEmojis = _getWeeklyEmojis(state);

        return Scaffold(
          backgroundColor: const Color(0xFFFDF6EE),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFDF6EE),
            elevation: 0,
            title: const Text(
              '감정 리포트',
              style: TextStyle(
                color: Color(0xFF8B6F47),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 주간/월간 토글
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isWeekly = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isWeekly ? const Color(0xFF8B6F47) : Colors.white,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                          border: Border.all(color: const Color(0xFF8B6F47)),
                        ),
                        child: Text(
                          '주간',
                          style: TextStyle(
                            color: _isWeekly ? Colors.white : const Color(0xFF8B6F47),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isWeekly = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: !_isWeekly ? const Color(0xFF8B6F47) : Colors.white,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                          border: Border.all(color: const Color(0xFF8B6F47)),
                        ),
                        child: Text(
                          '월간',
                          style: TextStyle(
                            color: !_isWeekly ? Colors.white : const Color(0xFF8B6F47),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // 1️⃣ 곰돌이 + 다이얼로그
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const TeddyCharacter(size: 100),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: DialogueBox(
                          controller: _dialogueController,
                          characterName: '곰돌이',
                          onDialogueEnd: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // 2️⃣ 이번 주 이모지 그리드 (7일)
                _buildWeeklyEmojiRow(weeklyEmojis),

                const SizedBox(height: 24),

                // 3️⃣ 막대 차트
                if (weeklyStats.isEmpty)
                  _buildEmptyChart()
                else
                  _buildBarChart(weeklyStats),

                const SizedBox(height: 24),

                // 4️⃣ 감정별 카운트 카드
                _buildEmotionSummary(weeklyStats),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // 이번 주 7일 이모지 행
  Widget _buildWeeklyEmojiRow(List<Map<String, dynamic>> weeklyEmojis) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이번 주 감정',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B6F47),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final item = weeklyEmojis[index];
              final date = item['date'] as DateTime;
              final emotion = item['emotion'] as String;
              final dayLabel = days[date.weekday - 1];

              return Column(
                children: [
                  Text(
                    emotion.isNotEmpty ? emotion : '·',
                    style: TextStyle(
                      fontSize: emotion.isNotEmpty ? 24 : 16,
                      color: emotion.isEmpty ? Colors.grey.shade300 : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // 막대 차트
  Widget _buildBarChart(Map<String, int> stats) {
    final maxY = stats.values.reduce((a, b) => a > b ? a : b).toDouble();

    // 감정 순서대로 정렬
    final orderedEmotions = _emotions
        .where((e) => stats.containsKey(e['emoji']))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: const Text(
              '감정 분포',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B6F47),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
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
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
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
                  final count = stats[emotion['emoji']] ?? 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        color: emotion['color'] as Color,
                        width: 32,
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

  // 데이터 없을 때
  Widget _buildEmptyChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('🧸', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            '아직 이번 주 감정 기록이 없어',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // 감정별 카운트 카드
  Widget _buildEmotionSummary(Map<String, int> stats) {
    if (stats.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 요약',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B6F47),
            ),
          ),
          const SizedBox(height: 12),
          ..._emotions
              .where((e) => stats.containsKey(e['emoji']))
              .map((e) {
            final count = stats[e['emoji']] ?? 0;
            final total = stats.values.reduce((a, b) => a + b);
            final percent = (count / total * 100).toStringAsFixed(0);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text(e['emoji'], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    e['label'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5D4E37),
                    ),
                  ),
                  const Spacer(),
                  // 퍼센트 바
                  SizedBox(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: count / total,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          e['color'] as Color,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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