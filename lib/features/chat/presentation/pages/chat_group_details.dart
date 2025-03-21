import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/group_details_bloc/group_details_bloc.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_bottom.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_list.dart';

class ChatGroupDetails extends StatefulWidget {
  final String groupId;

  const ChatGroupDetails({super.key, required this.groupId});

  @override
  State<ChatGroupDetails> createState() => _ChatGroupDetailsState();
}

class _ChatGroupDetailsState extends State<ChatGroupDetails> {
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<GroupDetailsBloc>().add(GetChatGroup(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
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
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.menu),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {},
                        child: Text('See Members'),
                      )
                    ];
                  },
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    ChatMessagesList(groupId: widget.groupId),
                    Expanded(child: Container()),
                    ChatMessagesBottom(controller: _messageController),
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
