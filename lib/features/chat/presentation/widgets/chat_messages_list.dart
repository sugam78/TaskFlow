import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/resources/app_colors.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_messages_bloc/chat_messages_bloc.dart';

class ChatMessagesList extends StatefulWidget {
  final String groupId;

  const ChatMessagesList({super.key, required this.groupId});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatMessagesBloc>().add(ResetChatMessages());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100) {
      if (!isFetching) {
        isFetching = true;
        context.read<ChatMessagesBloc>().add(GetMessages(widget.groupId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        builder: (context, state) {
          if(state is ChatMessagesInitial){
            context.read<ChatMessagesBloc>().add(GetMessages(widget.groupId));
          }
          if (state is ChatMessagesFetching && state is! ChatMessagesFetched) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatMessagesError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is ChatMessagesFetched) {
            final messages = state.messages.messages;

            return ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return state is ChatMessagesFetching
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const SizedBox.shrink();
                }

                final message = messages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(index==messages.length -1)Text(message.senderName),
                      if(index>messages.length)
                        if(message.sender!=messages[index+1].sender)
                          Text(message.senderName),
                      ChatMessageBubble(message: message),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessageBubble extends StatelessWidget {
  final Message message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:  EdgeInsets.symmetric(vertical: deviceHeight * 0.01, horizontal: deviceWidth * 0.02),
        padding:  EdgeInsets.all(deviceWidth * 0.03),
        decoration: BoxDecoration(
          color: message.isCurrentUser ? AppColors.primary : Theme.of(context).textTheme.bodySmall!.color,
          borderRadius: BorderRadius.circular(deviceWidth * 0.02),
        ),
        child:
            message.content!=null?
        Text(
          message.content ?? "Attachment",
          style: TextStyle(color: message.isCurrentUser ? AppColors.white : AppColors.black),
        ):message.fileUrl!=null?SizedBox(height: deviceHeight * 0.2,child: Image.network(message.fileUrl!)):Text('Task'),
      ),
    );
  }
}
