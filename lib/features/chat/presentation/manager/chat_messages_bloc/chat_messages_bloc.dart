import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/fetch_messages_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/listen_to_message_use_case.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final ListenToMessageUseCase listenToMessageUseCase;

  int _currentPage = 1;
  final int _limit = 20;

  StreamSubscription<Message>? _messageSubscription;

  ChatMessagesBloc(this.fetchMessageUseCase, this.listenToMessageUseCase) : super(ChatMessagesInitial()) {
    on<GetMessages>(_fetchMessage);
    on<ResetChatMessages>(_resetMessages);
    on<StartListeningToMessages>(_startListeningToMessages);
    on<StopListeningToMessages>(_stopListeningToMessages);
    on<NewMessageReceived>((event, emit) {
      if (state is ChatMessagesFetched) {
        final currentState = state as ChatMessagesFetched;
        final currentMessages = currentState.messages.messages;

        emit(ChatMessagesFetched(Messages(messages: [event.message, ...currentMessages])));
      } else {
        emit(ChatMessagesFetched(Messages(messages: [event.message])));
      }
    });

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

  void _resetMessages(ResetChatMessages event, Emitter<ChatMessagesState> emit) async {
    emit(ChatMessagesInitial());
  }

  void _startListeningToMessages(StartListeningToMessages event, Emitter<ChatMessagesState> emit) {
    _messageSubscription?.cancel();

    emit(ChatMessagesListening());

    try {
      _messageSubscription = listenToMessageUseCase.listenToMessage().listen((message) {
        add(NewMessageReceived(message));
      });
    } catch (error) {
      emit(ChatMessagesError(error.toString()));
    }
  }

  void _stopListeningToMessages(StopListeningToMessages event, Emitter<ChatMessagesState> emit) {
    _messageSubscription?.cancel();
    emit(ChatMessagesStopped());
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
