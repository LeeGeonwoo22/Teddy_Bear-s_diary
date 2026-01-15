import 'package:flutter/material.dart';

class DiaryBottomSheet extends StatelessWidget {
  final Map<String, dynamic> diary;

  const DiaryBottomSheet({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 내용
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        diary['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B6F47),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 감정 + 음악
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4C4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text('💛', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  diary['emotion'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B6F47),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8D5C4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text('🎵', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  diary['music'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B6F47),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // 본문
                      Text(
                        diary['content'],
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: Color(0xFF5D4E37),
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 곰돌이 서명
                      Row(
                        children: [
                          const Text('🧸', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Text(
                            '곰돌이가 너의 하루를 기억할게',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}