import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/core/common/appString.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';
import '../repository/chatRepository.dart';
import 'package:teddyBear/data/model/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  ChatBloc(this._chatRepository) : super(ChatState.initial()) {
    // 상태 방출
    on<AskQuestion>(_onAskQuestion);
    on<SearchMessages>(_onSearchMessages);
    on<ClearSearch>(_onClearSearch);
    on<LoadMessages>(_onLoadMessages);
    on<DeleteAllMessages>(_onDeleteAllMessages);
  }

  @override
  void onTransition(Transition<ChatEvent, ChatState> transition) {
    super.onTransition(transition);
    print('🌀 [Chat Transition]');
    print('  Chat Event : ${transition.event}');
    print('  Chat From  : ${transition.currentState}');
    print('  Chat To    : ${transition.nextState}');
    print('-----------------------------');
  }


  // ✅ 메시지 불러오기 (추가)
  Future<void> _onLoadMessages(
      LoadMessages event,
      Emitter<ChatState> emit,
      ) async {
    print('📥 메시지 불러오기 시작...');
    emit(state.copyWith(isLoading: true));

    try {
      final messages = await _chatRepository.loadMessages();
      final finalMessages = messages.isEmpty ? [
      Message(
        msg : AppStrings.tr('chat_greeting'),
        msgType: MessageType.bot,
      )
      ]: messages ;

      emit(state.copyWith(
        messages: finalMessages,
        isLoading: false,
      ));


      print('✅ 메시지 불러오기 완료: ${messages.length}개');

    } catch (e) {
      print('❌ 메시지 불러오기 실패: $e');

      emit(state.copyWith(
        messages: [
          Message(
            msg: AppStrings.tr('error_api'),
            msgType: MessageType.bot,
          )
        ],
        isLoading: false,
      ));
    }
  }

  Future<void> _onAskQuestion(
      AskQuestion event,
      Emitter<ChatState> emit,
      )
  async {
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
      final res = await _chatRepository.sendMessage(
        event.question,
        messagesWithUser,  // 현재 state에 이미 히스토리 있음
      );

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

  Future<void> _onDeleteAllMessages(
      DeleteAllMessages event,
      Emitter<ChatState> emit,
      ) async {
    print('🗑️ 모든 메시지 삭제 시작...');

    try {
      await _chatRepository.deleteAllMessages();

      emit(state.copyWith(messages: [
        Message(
          // msg: 'Hello! How can I help you?',
          msg : AppStrings.tr('chat_greeting'),
          msgType: MessageType.bot,
        )
      ]));

      print('✅ 모든 메시지 삭제 완료');

    } catch (e) {
      print('❌ 삭제 실패: $e');

      emit(state.copyWith(
        messages: [
          ...state.messages,
          Message(
            msg: 'Failed to delete messages.',
            msgType: MessageType.bot,
          )
        ],
      ));
    }
  }
}