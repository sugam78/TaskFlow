import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_image_picker_use_case.dart';

part 'chat_pick_image_event.dart';
part 'chat_pick_image_state.dart';

class ChatPickImageBloc extends Bloc<ChatPickImageEvent, ChatPickImageState> {
  final ChatImagePickerUseCase imagePickerUseCase;
  ChatPickImageBloc(this.imagePickerUseCase) : super(ChatPickImageInitial()) {
    on<ChatPickImage>(_chatPickImage);
    on<ResetPickImage>(_reset);
  }

  void _chatPickImage(event, emit) async{
    emit(ChatPickImageLoading());
    try{
      final file = await imagePickerUseCase.pickImage();
      if(file==null){
        throw 'Cant pick image';
      }
        else {
        emit(ChatPickImageLoaded(file));
      }
    }
    catch(e){
      emit(ChatPickImageError(e.toString()));
    }
  }
  void _reset(event, emit) async{
    emit(ChatPickImageInitial());
  }
}
