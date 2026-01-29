import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/diary_bloc.dart';
import '../bloc/diary_state.dart';

class DiaryCalendar extends StatefulWidget {
  // 부모 위젯에서 넘겨받은 콜백 함수
  final Function(DateTime) onDaySelected;

  const DiaryCalendar({super.key, required this.onDaySelected});

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryBloc, DiaryState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TableCalendar(
            locale: 'ko_KR', // 한국어 설정을 원하시면 추가 (pubspec.yaml 설정 필요)
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            // 미래 날짜 클릭 방지 (오늘까지만 활성화)
            enabledDayPredicate: (day) {
              final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              final checkDay = DateTime(day.year, day.month, day.day);

              return !checkDay.isAfter(today);
            },
            // 1. 선택된 날짜 표시 로직
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            // 2. 이벤트 마커 로더
            eventLoader: (day) {
              final normalizedDay = DateTime(day.year, day.month, day.day);
              return state.diaries.containsKey(normalizedDay) ? ['●'] : [];
            },

            // 3. 날짜 클릭 시 동작 (핵심 수정!)
            onDaySelected: (selectedDay, focusedDay) {
              // 2. 부모에게 날짜 전달
              // 중요: 부모 위젯(DiaryPage)에게 클릭된 날짜를 전달합니다!
              // widget.onDaySelected를 실행함으로써 DiaryPage의 _handleDaySelected가 실행됩니다.
              widget.onDaySelected(selectedDay);
            },

            // 디자인 스타일 설정
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFFD7CCC8), // 연한 브라운 (오늘 날짜)
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF8B6F47), // 진한 브라운 (선택 날짜)
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color(0xFF5D4037),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B6F47)),
            ),
          ),
        );
      }
    );
  }
}