import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_upload_image_use_case.dart';

part 'chat_upload_image_event.dart';
part 'chat_upload_image_state.dart';

class ChatUploadImageBloc extends Bloc<ChatUploadImageEvent, ChatUploadImageState> {
  final ChatUploadImageUseCase chatUploadImageUseCase;
  ChatUploadImageBloc(this.chatUploadImageUseCase) : super(ChatUploadImageInitial()) {
    on<ChatUploadImage>(_chatUploadImage);
    on<ResetUploadImage>(_reset);
  }
  void _chatUploadImage(ChatUploadImage event, emit) async{
    emit(ChatUploadImageLoading());
    try{
      final imageUrl = await chatUploadImageUseCase.uploadImage(event.file);
      emit(ChatUploadImageLoaded(imageUrl));
    }
    catch(e){
      emit(ChatUploadImageError(e.toString()));
    }
  }

  void _reset(event, emit) async{
    emit(ChatUploadImageInitial());

  }
}
