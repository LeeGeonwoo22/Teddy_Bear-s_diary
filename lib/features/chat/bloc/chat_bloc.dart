import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';

import '../../../core/api/apis.dart';
import '../../../data/model/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  /*print('chat bloc 생성');*/

  ChatBloc() : super(ChatState.initial()) {
    on<AskQuestion>(_askQuestion);
  }

  Future<void> _askQuestion(
          AskQuestion event, Emitter<ChatState> emit) async {
    print('askQuestion 이벤트시작');
    print('bloc : $state');
      final updated = List<Message>.from(state.messages);
    // 유저 대화
    updated.add(Message(msg: event.question, msgType: MessageType.user));

    // 봇 대화
    updated.add(Message(msg: '', msgType: MessageType.bot));
    emit(state.copyWith(messages: updated, isLoading: true));

    final res = await APIs.getAnswer(event.question);
    final newList = List<Message>.from(updated)
    ..removeLast()
    ..add(Message(msg: res, msgType: MessageType.bot));
    emit(state.copyWith(messages: newList, isLoading: false));
  }
}