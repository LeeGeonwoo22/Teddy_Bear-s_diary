import 'dart:async';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

class DialogueController extends ChangeNotifier {
  List<String> _dialogues = [];
  int _currentIndex = 0;
  String _displayedText = '';
  bool _isTyping = false;
  Timer? _typingTimer;
  int _charIndex = 0;

  List<String> get dialogues => _dialogues;
  int get currentIndex => _currentIndex;
  String get displayedText => _displayedText;
  bool get isTyping => _isTyping;

  void setDialogues(List<String> newDialogues, {bool autoStart = true}) {
    print("🔵 setDialogues 호출: $newDialogues");

    _dialogues = newDialogues;
    _currentIndex = 0;
    _displayedText = '';
    _charIndex = 0;

    notifyListeners();

    if (autoStart && _dialogues.isNotEmpty) {
      // ✅ 약간의 딜레이를 줘서 UI가 준비된 후 시작
      Future.microtask(() => startTyping());
    }
  }

  void startTyping() {

    _typingTimer?.cancel();

    if (_currentIndex >= _dialogues.length) {
      print("❌ 범위 초과로 리턴");
      return;
    }

    _isTyping = true;
    _displayedText = '';
    _charIndex = 0;
    notifyListeners();

    final currentText = _dialogues[_currentIndex];
    // print("   타이핑할 텍스트: '$currentText'");
    // print("   텍스트 길이: ${currentText.length}");
    // ✅ Characters로 변환 (이모지 안전)
    final charList = currentText.characters.toList();

    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_charIndex < currentText.length) {
        _displayedText = charList.take(_charIndex + 1).join();
        _charIndex++;


        notifyListeners();  // ✅ 확실하게 호출
      } else {
        // print("✅ 타이핑 완료");
        timer.cancel();
        _isTyping = false;
        notifyListeners();
      }
    });
  }

  void skipTyping() {
    // print("⏩ skipTyping 호출");
    _typingTimer?.cancel();
    if (_currentIndex < _dialogues.length) {
      _displayedText = _dialogues[_currentIndex];
      _isTyping = false;
      notifyListeners();
    }
  }

  bool nextDialogue() {


    if (_isTyping) {
      skipTyping();
      return false;
    }

    if (_currentIndex >= _dialogues.length - 1) {
      print("🏁 대화 종료");
      return true;
    }

    _currentIndex++;
    print("   다음 인덱스: $_currentIndex");
    startTyping();
    return false;
  }

  void reset() {

    _typingTimer?.cancel();
    _dialogues = [];
    _currentIndex = 0;
    _displayedText = '';
    _charIndex = 0;
    _isTyping = false;
    notifyListeners();
  }

  @override
  void dispose() {

    _typingTimer?.cancel();
    super.dispose();
  }
}