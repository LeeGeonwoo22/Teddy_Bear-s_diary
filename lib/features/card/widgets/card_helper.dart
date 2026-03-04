// class CardHelper {
//   // ── 카드 영역 ────────────────────────────────────────
//   Widget _buildCardArea() {
//     if (_pageState == _PageState.intro) return _buildDeckIllust();
//     if (_pageState == _PageState.ready || _pageState == _PageState.drawing) {
//       return Column(children: [
//         // 선택된 질문 배지
//         if (_selectedQuestion != null)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: AppColors.cardBg,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: AppColors.border),
//             ),
//             child: Row(children: [
//               Text(_categoryData[_selectedCategory]!['emoji'], style: const TextStyle(fontSize: 16)),
//               const SizedBox(width: 8),
//               Expanded(child: Text(
//                 _selectedQuestion!,
//                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
//               )),
//             ]),
//           ),
//         const SizedBox(height: 24),
//         _buildFlippableCard(),
//       ]);
//     }
//     return _buildRevealedCard();
//   }
//
//   // 덱 일러스트
//   Widget _buildDeckIllust() {
//     return SizedBox(
//       height: 190,
//       child: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: List.generate(5, (i) => Transform.rotate(
//             angle: (i - 2) * 0.07,
//             child: Transform.translate(
//               offset: Offset((i - 2) * 10.0, 0),
//               child: Container(
//                 width: 100, height: 148,
//                 decoration: BoxDecoration(
//                   color: AppColors.gold.withOpacity(0.2 + i * 0.08),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
//                   boxShadow: [BoxShadow(
//                     color: AppColors.brown.withOpacity(0.08),
//                     blurRadius: 8, offset: const Offset(0, 4),
//                   )],
//                 ),
//                 child: i == 4
//                     ? const Center(child: Text('🧸', style: TextStyle(fontSize: 36)))
//                     : null,
//               ),
//             ),
//           )),
//         ),
//       ),
//     );
//   }
//
//   // 플립 카드
//   Widget _buildFlippableCard() {
//     return GestureDetector(
//       onTap: _onCardTap,
//       child: AnimatedBuilder(
//         animation: _flipAnim,
//         builder: (ctx, _) {
//           final angle = _flipAnim.value * pi;
//           final isFront = angle > pi / 2;
//           return Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(angle),
//             child: isFront
//                 ? Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()..rotateY(pi),
//               child: _cardFront(),
//             )
//                 : _cardBack(),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _cardBack() => Container(
//     width: 140, height: 210,
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [AppColors.gold.withOpacity(0.5), AppColors.softBrown.withOpacity(0.35)],
//         begin: Alignment.topLeft, end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: AppColors.gold, width: 2),
//       boxShadow: [BoxShadow(color: AppColors.brown.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 8))],
//     ),
//     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//       AnimatedBuilder(
//         animation: _floatAnim,
//         builder: (ctx, child) =>
//             Transform.translate(offset: Offset(0, _floatAnim.value * 0.4), child: child),
//         child: const Text('🧸', style: TextStyle(fontSize: 44)),
//       ),
//       const SizedBox(height: 8),
//       Text('TOUCH', style: TextStyle(
//         fontSize: 10, fontWeight: FontWeight.w800,
//         color: AppColors.brown.withOpacity(0.55), letterSpacing: 3,
//       )),
//     ]),
//   );
//
//   Widget _cardFront() {
//     if (_drawnCard == null) return const SizedBox.shrink();
//     return Container(
//       width: 140, height: 210,
//       decoration: BoxDecoration(
//         color: AppColors.cardBg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _drawnCard!.color.withOpacity(0.6), width: 2),
//         boxShadow: [BoxShadow(
//           color: _drawnCard!.color.withOpacity(0.22),
//           blurRadius: 20, offset: const Offset(0, 8),
//         )],
//       ),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text(_drawnCard!.emoji, style: const TextStyle(fontSize: 48)),
//         const SizedBox(height: 8),
//         Text(_drawnCard!.name, style: const TextStyle(
//           fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
//         )),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//           decoration: BoxDecoration(
//             color: _drawnCard!.color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(_drawnCard!.keyword, style: TextStyle(
//             fontSize: 11, color: _drawnCard!.color, fontWeight: FontWeight.w700,
//           )),
//         ),
//       ]),
//     );
//   }
//
//   Widget _buildRevealedCard() {
//     if (_drawnCard == null) return const SizedBox.shrink();
//     return SlideTransition(
//       position: _slideAnim,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(children: [
//           _cardFront(),
//           const SizedBox(height: 20),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: _drawnCard!.color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: _drawnCard!.color.withOpacity(0.25)),
//             ),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(children: [
//                 Text(_drawnCard!.emoji, style: const TextStyle(fontSize: 16)),
//                 const SizedBox(width: 6),
//                 Text('${_drawnCard!.name} · ${_drawnCard!.keyword}',
//                     style: const TextStyle(
//                       fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkBrown,
//                     )),
//               ]),
//               const SizedBox(height: 12),
//               Text(_drawnCard!.message, style: const TextStyle(
//                 fontSize: 14, color: AppColors.darkBrown, height: 1.7,
//               )),
//               Divider(height: 24, color: AppColors.border),
//               Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 const Text('🧸 ', style: TextStyle(fontSize: 14)),
//                 Expanded(child: Text(_drawnCard!.teddyComment, style: TextStyle(
//                   fontSize: 13, color: AppColors.softBrown,
//                   fontStyle: FontStyle.italic, height: 1.5,
//                 ))),
//               ]),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   // ── FAB ─────────────────────────────────────────────
//   Widget? _buildFab() {
//     if (_pageState == _PageState.intro) {
//       return FloatingActionButton.extended(
//         onPressed: _showCategoryPopup,
//         backgroundColor: AppColors.brown,
//         label: const Text('🃏 카드 뽑기',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//       );
//     }
//     if (_pageState == _PageState.revealed) {
//       return FloatingActionButton.extended(
//         onPressed: _reset,
//         backgroundColor: AppColors.brown,
//         label: const Text('🔄 다시 뽑기',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//       );
//     }
//     return null;
//   }
//
//   // ── 기록 구분선 ─────────────────────────────────────
//   Widget _buildDivider() => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Row(children: [
//       const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Text('📜 상담 기록', style: TextStyle(
//           fontSize: 12, color: AppColors.softBrown.withOpacity(0.7), fontWeight: FontWeight.w600,
//         )),
//       ),
//       const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
//     ]),
//   );
//
//   // ── 날짜별 기록 리스트 ───────────────────────────────
//   Widget _buildRecordList() {
//     if (_records.isEmpty) {
//       return Center(child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text('아직 상담 기록이 없어 🧸',
//             style: TextStyle(fontSize: 13, color: AppColors.softBrown.withOpacity(0.6))),
//       ));
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: _records.map((r) => Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: AppColors.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: AppColors.border),
//           ),
//           child: Row(children: [
//             // 날짜 배지
//             Container(
//               width: 42, padding: const EdgeInsets.symmetric(vertical: 6),
//               decoration: BoxDecoration(
//                 color: AppColors.bg, borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(children: [
//                 Text('${r.date.month}월', style: TextStyle(
//                   fontSize: 9, color: AppColors.softBrown.withOpacity(0.7), fontWeight: FontWeight.w500,
//                 )),
//                 Text('${r.date.day}', style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.1,
//                 )),
//               ]),
//             ),
//             const SizedBox(width: 12),
//             Text(r.card.emoji, style: const TextStyle(fontSize: 26)),
//             const SizedBox(width: 10),
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(children: [
//                   Text(r.card.name, style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
//                   )),
//                   const SizedBox(width: 6),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: r.card.color.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(r.category, style: TextStyle(
//                       fontSize: 10, color: r.card.color, fontWeight: FontWeight.w700,
//                     )),
//                   ),
//                 ]),
//                 const SizedBox(height: 3),
//                 Text(r.question, style: TextStyle(
//                   fontSize: 11, color: AppColors.softBrown.withOpacity(0.8),
//                 ), maxLines: 1, overflow: TextOverflow.ellipsis),
//               ],
//             )),
//           ]),
//         )).toList(),
//       ),
//     );
//   }
// }