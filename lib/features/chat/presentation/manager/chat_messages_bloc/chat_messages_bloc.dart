

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/use_cases/fetch_messages_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/send_message_use_case.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final SendMessageUseCase sendMessageUseCase;
  final FetchMessageUseCase fetchMessageUseCase;
  int _currentPage = 1;
  final int _limit = 20;
  ChatMessagesBloc(this.sendMessageUseCase, this.fetchMessageUseCase) : super(ChatMessagesInitial()) {
    on<SendMessages>(_sendMessage);
    on<GetMessages>(_fetchMessage);
    on<ResetChatMessages>(_resetMessages);
  }
  void _sendMessage(SendMessages event, emit) async{
    emit(ChatMessagesSending());
    try{
      await sendMessageUseCase.sendMessage(event.groupId, event.type, event.content, event.fileUrl, event.taskId);
      emit(ChatMessagesSent());
    }
    catch(e){
      emit(ChatMessagesError(e.toString()));
    }
  }
  void _fetchMessage(GetMessages event, Emitter<ChatMessagesState> emit) async {
    if (state is ChatMessagesFetched) {
      final currentState = state as ChatMessagesFetched;
      final currentMessages = currentState.messages.messages;

      emit(ChatMessagesFetching());

      try {
        final newMessages = await fetchMessageUseCase.fetchMessages(event.groupId, _currentPage, _limit);

        if (newMessages.messages.isEmpty) {
          emit(ChatMessagesFetched(Messages(messages: currentMessages)));
        } else {
          _currentPage++;
          emit(ChatMessagesFetched(Messages(messages: [...newMessages.messages, ...currentMessages])));
        }
      } catch (e) {
        emit(ChatMessagesError(e.toString()));
      }
    } else {
      emit(ChatMessagesFetching());

      try {
        final messages = await fetchMessageUseCase.fetchMessages(event.groupId, 1, _limit);
        _currentPage = 2;
        emit(ChatMessagesFetched(Messages(messages: messages.messages)));
      } catch (e) {
        emit(ChatMessagesError(e.toString()));
      }
    }
  }
  void _resetMessages( event,  emit) async {
    emit(ChatMessagesInitial());
  }

}
