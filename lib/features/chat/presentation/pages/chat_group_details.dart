import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/features/chat/presentation/manager/group_details_bloc/group_details_bloc.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_bottom.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_list.dart';
import 'package:taskflow/features/chat/presentation/widgets/show_picked_image.dart';

class ChatGroupDetails extends StatefulWidget {
  final String groupId;

  const ChatGroupDetails({super.key, required this.groupId});

  @override
  State<ChatGroupDetails> createState() => _ChatGroupDetailsState();
}

class _ChatGroupDetailsState extends State<ChatGroupDetails> {
  final TextEditingController _messageController = TextEditingController();
  final NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    context.read<GroupDetailsBloc>().add(GetChatGroup(widget.groupId));
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/chatHome');
        }
      },
      child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
        builder: (context, state) {
          if (state is GroupDetailsInitial) {
            context.read<GroupDetailsBloc>().add(GetChatGroup(widget.groupId));
          }
          if (state is GroupDetailsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GroupDetailsError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is GroupDetailsLoaded) {
            return Scaffold(
      
              appBar: AppBar(
                title: Text(state.chatGroup.name),
                // actions: [
                //   PopupMenuButton(
                //     icon: Icon(Icons.menu),
                //     itemBuilder: (context) {
                //       return [
                //         PopupMenuItem(
                //           onTap: () {},
                //           child: Text('See Members'),
                //         )
                //       ];
                //     },
                //   )
                // ],
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      ChatMessagesList(groupId: widget.groupId),
                      SizedBox(height: deviceHeight * 0.02,),
                      ShowPickedImage(),
                      ChatMessagesBottom(controller: _messageController,groupId: widget.groupId,),
                    ],
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
