import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';

import '../../../core/api/apis.dart';
import '../../../data/model/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<AskQuestion>(_onAskQuestion);
    on<SearchMessages>(_onSearchMessages);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onAskQuestion(
      AskQuestion event,
      Emitter<ChatState> emit,
      ) async {
    print('askQuestion 이벤트 시작: ${event.question}');

    // 1. 사용자 메시지 추가
    final userMessage = Message(
      msg: event.question,
      msgType: MessageType.user,
    );
    final messagesWithUser = [...state.messages, userMessage];
    emit(state.copyWith(messages: messagesWithUser));

    // 2. 로딩 메시지 추가
    final loadingMessage = Message(msg: '', msgType: MessageType.bot);
    final messagesWithLoading = [...messagesWithUser, loadingMessage];
    emit(state.copyWith(
      messages: messagesWithLoading,
      isLoading: true,
    ));

    try {
      // 3. API 호출
      final res = await APIs.getAnswer(event.question);

      // 4. 로딩 메시지를 실제 응답으로 교체
      final botMessage = Message(msg: res, msgType: MessageType.bot);
      final finalMessages = [...messagesWithUser, botMessage];

      emit(state.copyWith(
        messages: finalMessages,
        isLoading: false,
      ));

      print('✅ 응답 완료: ${res.length}자');
    } catch (e) {
      // 5. 에러 처리
      print('❌ API 오류: $e');
      final errorMessage = Message(
        msg: 'Sorry, something went wrong. Please try again.',
        msgType: MessageType.bot,
      );
      final errorMessages = [...messagesWithUser, errorMessage];

      emit(state.copyWith(
        messages: errorMessages,
        isLoading: false,
      ));
    }
  }

  void _onSearchMessages(
      SearchMessages event,
      Emitter<ChatState> emit,
      ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onClearSearch(
      ClearSearch event,
      Emitter<ChatState> emit,
      ) {
    emit(state.copyWith(searchQuery: ''));
  }
}