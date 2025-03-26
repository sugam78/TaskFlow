import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_pick_image_bloc/chat_pick_image_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_upload_image_bloc/chat_upload_image_bloc.dart';

class ShowPickedImage extends StatelessWidget {
  const ShowPickedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatPickImageBloc, ChatPickImageState>(
      listener: (context,state){
        if(state is ChatPickImageError){
          return CustomSnackBar.show(context, message: state.message, type: SnackBarType.error);
        }
        if(state is ChatPickImageLoading){
          return CustomSnackBar.show(context, message: 'Picking image', type: SnackBarType.success);
        }
        if(state is ChatPickImageLoaded){
          context.read<ChatUploadImageBloc>().add(ChatUploadImage(state.imageFIle));
        }
      },
      builder: (context, state) {
        if(state is ChatPickImageLoaded){
          return Image.file(state.imageFIle,height: deviceHeight * 0.2,width: deviceHeight * 0.4,);
        }
        return SizedBox.shrink();

      },
    );
  }
}
