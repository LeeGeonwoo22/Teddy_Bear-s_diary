import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/core/common/appString.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';
import '../../../data/model/message.dart';
import '../repository/chatRepository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  ChatBloc(this._chatRepository) : super(ChatState.initial()) {
    // 상태 방출
    on<AskQuestion>(_onAskQuestion);
    on<SearchMessages>(_onSearchMessages);
    on<ClearSearch>(_onClearSearch);
  }

  void onTransition(Transition<ChatEvent, ChatState> transition) {
    super.onTransition(transition);
    print('🌀 [Chat Transition]');
    print('  Chat Event : ${transition.event}');
    print('  Chat From  : ${transition.currentState}');
    print('  Chat To    : ${transition.nextState}');
    print('-----------------------------');
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
      // 3. repository 호출
      final res = await _chatRepository.sendMessage(userMessage.msg);


      // 4. 응답 메세지
      final botMessage = res;
      final finalMessages = [...messagesWithUser, botMessage];

      emit(state.copyWith(
        messages: finalMessages,
        isLoading: false,
      ));

      print('✅ 응답 완료: ${res.msg.length}자');


    } catch (e) {
      // 5. 에러 처리
      print('❌ API 오류: $e');
      final errorMessage = Message(
        msg: AppStrings.tr('error_api'),
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