import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/resources/app_colors.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:taskflow/shared/presentation/widgets/task_view.dart';

class ChatMessagesList extends StatefulWidget {
  final String groupId;

  const ChatMessagesList({super.key, required this.groupId});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();
  late ChatMessagesBloc _chatMessagesBloc;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();

    _chatMessagesBloc = context.read<ChatMessagesBloc>();
    _scrollController.addListener(_onScroll);

    _initializeChat();
  }

  void _initializeChat() {
    _chatMessagesBloc.add(StopListeningToMessages());  // Stop previous listeners
    _chatMessagesBloc.add(ResetChatMessages());        // Clear previous messages

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _chatMessagesBloc.add(GetMessages(widget.groupId));
        _chatMessagesBloc.add(StartListeningToMessages());
      }
    });
  }



  void _onScroll() {
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100) {
      if (!isFetching) {
        isFetching = true;

        context.read<ChatMessagesBloc>().add(GetMessages(widget.groupId));

        // Set delay to prevent frequent calls
        Future.delayed(Duration(seconds: 1), () {
          isFetching = false;
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        buildWhen: (previous, current) {
          if (current is ChatMessagesFetching && previous is ChatMessagesFetched) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is ChatMessagesFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatMessagesError) {
            return Center(child: Text("Error: ${state.error}"));
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
                final bool isFirstMessageOfSender = index == messages.length - 1 ||
                    (index < messages.length - 1 && messages[index].sender != messages[index + 1].sender);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05, vertical: 4),
                  child: Column(
                    crossAxisAlignment: message.isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (isFirstMessageOfSender && !message.isCurrentUser)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            message.senderName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ChatMessageBubble(message: message),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      )
    );
  }

  @override
  void dispose() {
    _chatMessagesBloc.add(StopListeningToMessages());
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
        margin: EdgeInsets.symmetric(vertical: deviceHeight * 0.005, horizontal: deviceWidth * 0.01),
        padding: EdgeInsets.all(deviceWidth * 0.02),
        decoration: BoxDecoration(
          color: message.isCurrentUser ? AppColors.primary : Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(deviceWidth * 0.01),
        ),
        child: message.content != null
            ? Text(
          message.content ?? "Attachment",
        )
            : message.fileUrl != null
            ? SizedBox(height: deviceHeight * 0.2, child: Image.network(message.fileUrl!))
            : TaskViewWidget(task: message.task!),
      ),
    );
  }
}
