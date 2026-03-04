import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';


class EmotionGraphPage_5 extends StatefulWidget {
  const EmotionGraphPage_5({super.key});

  @override
  State<EmotionGraphPage_5> createState() => _EmotionGraphPage_5State();
}

class _EmotionGraphPage_5State extends State<EmotionGraphPage_5>
    with TickerProviderStateMixin {
  late DialogueController _dialogueController;
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late AnimationController _shimmerController;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _shimmerAnim;
  bool _isWeekly = true;

  static const Color _bg        = Color(0xFFF5E2B8);
  static const Color _cardBg    = Color(0xFFFFF8EC);
  static const Color _brown     = Color(0xFF8B6F47);
  static const Color _darkBrown = Color(0xFF5D4037);
  static const Color _gold      = Color(0xFFD4A017);
  static const Color _softGold  = Color(0xFFF5C842);
  static const Color _border    = Color(0xFFD4A97A);

  final List<Map<String, dynamic>> _emotions = [
    {'emoji': '😊', 'label': '괜찮아',    'color': Color(0xFFFFB347), 'pastel': Color(0xFFFFF3DC), 'rpg': '⚔️ 용감한 전사'},
    {'emoji': '😢', 'label': '슬퍼',      'color': Color(0xFF87CEEB), 'pastel': Color(0xFFE8F4FD), 'rpg': '💧 물의 마법사'},
    {'emoji': '😤', 'label': '답답해',    'color': Color(0xFFFF9999), 'pastel': Color(0xFFFFEEEE), 'rpg': '🔥 화염 기사'},
    {'emoji': '🤔', 'label': '모르겠어',  'color': Color(0xFF98D8C8), 'pastel': Color(0xFFE8F8F2), 'rpg': '🌿 숲의 현자'},
    {'emoji': '😴', 'label': '그냥 그래', 'color': Color(0xFFCDABE8), 'pastel': Color(0xFFF5EEFF), 'rpg': '🌙 달빛 음유시인'},
  ];

  Map<String, int> _getMockStats() => _isWeekly
      ? {'😊': 3, '😢': 1, '😤': 2, '🤔': 1, '😴': 0}
      : {'😊': 12, '😢': 5, '😤': 7, '🤔': 3, '😴': 4};

  final List<Map<String, dynamic>> _weeklyData = [
    {'day': '월', 'emoji': '😤', 'value': 2.0, 'event': '험난한 하루'},
    {'day': '화', 'emoji': '😊', 'value': 5.0, 'event': '빛나는 승리'},
    {'day': '수', 'emoji': '😊', 'value': 5.0, 'event': '평화로운 마을'},
    {'day': '목', 'emoji': '😢', 'value': 1.0, 'event': '외로운 밤'},
    {'day': '금', 'emoji': '🤔', 'value': 3.0, 'event': '미로 속 탐험'},
    {'day': '토', 'emoji': '😊', 'value': 5.0, 'event': '보물 발견'},
    {'day': '일', 'emoji': '😤', 'value': 2.0, 'event': '폭풍 전야'},
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _shimmerAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "모험가여, 어서오게! 🧸",
      "이번 주 감정 퀘스트 결과를 확인해볼까?",
      "네 마음속 여정이 여기 기록되어 있어 ✨",
    ]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    _shimmerController.dispose();
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: _bg,
              elevation: 0,
              floating: true,
              centerTitle: true,
              title: AnimatedBuilder(
                animation: _shimmerAnim,
                builder: (context, child) => Opacity(
                  opacity: _shimmerAnim.value,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('✨ ', style: TextStyle(fontSize: 16)),
                      Text('감정 모험 일지',
                          style: TextStyle(
                            color: _darkBrown,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            letterSpacing: 1.0,
                          )),
                      Text(' ✨', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildNpcSection(),
                  if (topEmotion != null)
                    _buildQuestResultBanner(topEmotion, topEntry!.value, total),
                  _buildToggle(),
                  _buildExpGauges(filtered, total),
                  _buildAdventureChart(),
                  _buildBattleLog(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNpcSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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

  Widget _buildQuestResultBanner(Map<String, dynamic> emotion, int count, int total) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border, width: 2),
        boxShadow: [
          BoxShadow(
            color: _brown.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: _brown,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _shimmerAnim,
                  builder: (context, child) =>
                      Opacity(opacity: _shimmerAnim.value, child: const Text('⭐', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 8),
                Text(
                  _isWeekly ? '주간 퀘스트 완료!' : '월간 퀘스트 완료!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _shimmerAnim,
                  builder: (context, child) =>
                      Opacity(opacity: _shimmerAnim.value, child: const Text('⭐', style: TextStyle(fontSize: 14))),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: emotion['pastel'] as Color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (emotion['color'] as Color).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _floatAnim.value * 0.3),
                        child: Text(emotion['emoji'], style: const TextStyle(fontSize: 36)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emotion['rpg'],
                        style: TextStyle(
                          fontSize: 13,
                          color: _brown.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"${emotion['label']}" 감정',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _darkBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('EXP  ',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: _gold)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: count / total,
                                backgroundColor: _brown.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(_softGold),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${count}회',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _gold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _toggleChip('⚔️  주간', true),
          const SizedBox(width: 10),
          _toggleChip('🏰  월간', false),
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _brown : _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _brown : _border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _brown.withOpacity(isSelected ? 0.2 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _brown,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildExpGauges(Map<String, int> stats, int total) {
    final orderedEmotions = _emotions.where((e) => stats.containsKey(e['emoji'])).toList();
    if (orderedEmotions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: _brown.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('📊 ', style: TextStyle(fontSize: 16)),
              Text('감정 스탯',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _darkBrown,
                    letterSpacing: 0.5,
                  )),
            ],
          ),
          const SizedBox(height: 16),
          ...orderedEmotions.map((e) {
            final count = stats[e['emoji']] ?? 0;
            final percent = count / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  SizedBox(width: 28, child: Text(e['emoji'], style: const TextStyle(fontSize: 20))),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52,
                    child: Text(e['label'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _darkBrown)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: _brown.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percent,
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: e['color'] as Color,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: (e['color'] as Color).withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 28,
                    child: Text('${count}회',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _brown)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdventureChart() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: _brown.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🗺️ ', style: TextStyle(fontSize: 16)),
              const Text('감정 여정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _darkBrown)),
              const Spacer(),
              Text(
                _isWeekly ? '7일간의 기록' : '30일간의 기록',
                style: TextStyle(fontSize: 11, color: _brown.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0, maxY: 6,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: _brown.withOpacity(0.08), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _weeklyData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(_weeklyData[index]['emoji'],
                                style: const TextStyle(fontSize: 16)),
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
                        .map((e) => FlSpot(e.key.toDouble(), e.value['value'] as double))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: _brown,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 6,
                        color: _cardBg,
                        strokeWidth: 2.5,
                        strokeColor: _brown,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _softGold.withOpacity(0.3),
                          _softGold.withOpacity(0.0),
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

  Widget _buildBattleLog() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: _brown.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text('📜 ', style: TextStyle(fontSize: 16)),
                Text('모험 일지',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: _darkBrown)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8D5B7), indent: 20, endIndent: 20),
          ...List.generate(_weeklyData.length, (i) {
            final item = _weeklyData[i];
            final emotionData = _emotions.firstWhere(
                  (e) => e['emoji'] == item['emoji'],
              orElse: () => _emotions.first,
            );
            final isLast = i == _weeklyData.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: emotionData['pastel'] as Color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (emotionData['color'] as Color).withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(item['day'],
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800, color: _darkBrown)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(item['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['event'],
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700, color: _darkBrown)),
                            Text(emotionData['label'],
                                style: TextStyle(fontSize: 11, color: _brown.withOpacity(0.6))),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(5, (j) {
                          final filled = j < (item['value'] as double).round();
                          return Text(filled ? '❤️' : '🤍', style: const TextStyle(fontSize: 10));
                        }),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1, color: Color(0xFFE8D5B7), indent: 20, endIndent: 20),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}