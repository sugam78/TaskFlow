import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/common/widgets/custom_text_field.dart';
import 'package:taskflow/core/resources/app_colors.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_pick_image_bloc/chat_pick_image_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_upload_image_bloc/chat_upload_image_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/send_messages_bloc/send_message_bloc.dart';
import 'package:taskflow/shared/presentation/manager/chat_task_bloc/chat_task_bloc.dart';

class ChatMessagesBottom extends StatefulWidget {
  final TextEditingController controller;
  final String groupId;

  const ChatMessagesBottom({
    super.key,
    required this.controller,
    required this.groupId,
  });

  @override
  State<ChatMessagesBottom> createState() => _ChatMessagesBottomState();
}

class _ChatMessagesBottomState extends State<ChatMessagesBottom> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToEmailController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _assignedToEmailController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToEmailController.dispose();
    super.dispose();
  }

  void createTask(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  labelText: 'Title',
                  controller: _titleController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Title can\'t be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Description',
                  controller: _descriptionController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Description can\'t be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Assigned To (Email)',
                  controller: _assignedToEmailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            BlocConsumer<SendMessageBloc, SendMessageState>(
              listener: (context, messagesState) {
                if (messagesState is MessagesSent) {
                  CustomSnackBar.show(
                    context,
                    message: 'Task Sent Successfully',
                    type: SnackBarType.success,
                  );
                  context.pop();
                }
              },
              builder: (context, state) {
                return BlocConsumer<ChatTaskBloc, ChatTaskState>(
                  listener: (context, state) {
                    if (state is ChatTaskCreated) {
                      context.read<SendMessageBloc>().add(
                        SendMessages(
                          widget.groupId,
                          'task',
                          null,
                          null,
                          state.taskId,
                        ),
                      );
                    }
                    if (state is ChatTaskError) {
                      CustomSnackBar.show(
                        context,
                        message: state.message,
                        type: SnackBarType.error,
                      );
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String title = _titleController.text;
                          String description = _descriptionController.text;
                          String assignedToEmail = _assignedToEmailController
                              .text;

                          context.read<ChatTaskBloc>().add(
                            CreateTask(
                              title,
                              description,
                              assignedToEmail,
                              widget.groupId,
                            ),
                          );
                        }
                      },
                      child: const Text('Send task'),
                    );
                  },
                );
              },
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth * 0.03),
      child: BlocConsumer<SendMessageBloc, SendMessageState>(
        listener: (context, state) {
          if(state is MessagesSent){
            context.read<ChatUploadImageBloc>().add(ResetUploadImage());
            context.read<ChatPickImageBloc>().add(
              ResetPickImage(),
            );
          }
          if(state is MessagesError){
            CustomSnackBar.show(context, message: state.message, type: SnackBarType.error);
            context.read<ChatUploadImageBloc>().add(ResetUploadImage());
          }
        },
        builder: (context, msgState) {
          return BlocBuilder<ChatUploadImageBloc, ChatUploadImageState>(
            builder: (context, state) {
              if (state is ChatUploadImageLoading) {
                return const CircularProgressIndicator();
              }
              if (state is ChatUploadImageLoaded) {
                if(msgState is MessagesSending){
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    context.read<SendMessageBloc>().add(
                      SendMessages(
                        widget.groupId,
                        'file',
                        null,
                        state.imageUrl,
                        null,
                      ),
                    );
                  },
                  child: const Text('Send'),
                );
              }

              return Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton(
                      icon: Icon(Icons.add, size: deviceHeight * 0.05),
                      itemBuilder:
                          (context) =>
                      [
                        PopupMenuItem(
                          onTap: () {
                            context.read<ChatPickImageBloc>().add(
                              ChatPickImage(),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.image, color: AppColors.primary),
                              SizedBox(width: deviceWidth * 0.02),
                              Text('Select Image'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            createTask(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add_task, color: AppColors.green),
                              SizedBox(width: deviceWidth * 0.02),
                              Text('Create Task'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.02),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Type a message....',
                        controller: widget.controller,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'It can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: deviceWidth * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SendMessageBloc>().add(
                            SendMessages(
                              widget.groupId,
                              'text',
                              widget.controller.text,
                              null,
                              null,
                            ),
                          );
                          widget.controller.clear();
                        }
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
