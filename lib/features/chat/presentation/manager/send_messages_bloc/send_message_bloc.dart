import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/send_message_use_case.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendMessageUseCase sendMessageUseCase;
  SendMessageBloc(this.sendMessageUseCase) : super(SendMessageInitial()) {
    on<SendMessages>(_sendMessage);
  }
void _sendMessage(SendMessages event, emit) async{
  emit(MessagesSending());
  try{
    await sendMessageUseCase.sendMessage(event.groupId, event.type, event.content, event.fileUrl, event.taskId);
    emit(MessagesSent());
  }
  catch(e){
    emit(MessagesError(e.toString()));
  }
}
}
