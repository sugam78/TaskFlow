import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/features/chat/presentation/manager/group_actions_bloc/group_actions_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/group_details_bloc/group_details_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/group_member_bloc/group_member_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/my_groups_bloc/my_groups_bloc.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_bottom.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_messages_list.dart';
import 'package:taskflow/features/chat/presentation/widgets/show_picked_image.dart';
import 'package:taskflow/features/profile/presentation/manager/my_profile_bloc/my_profile_bloc.dart';

class ChatGroupDetails extends StatefulWidget {
  final String groupId;

  const ChatGroupDetails({super.key, required this.groupId});

  @override
  State<ChatGroupDetails> createState() => _ChatGroupDetailsState();
}

class _ChatGroupDetailsState extends State<ChatGroupDetails> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
          print('Hello');
          if (state is GroupDetailsInitial) {
            context.read<GroupDetailsBloc>().add(GetChatGroup(widget.groupId));
          }
          if (state is GroupDetailsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GroupDetailsError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text(state.message),
              ),
            );
          }
          if (state is GroupDetailsLoaded) {
            return BlocBuilder<MyProfileBloc, MyProfileState>(
              builder: (context, profileState) {
                if (profileState is MyProfileInitial) {
                  context.read<MyProfileBloc>().add(GetMyProfile());
                }
                if(profileState is MyProfileError){
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Error'),
                    ),
                    body: Center(
                      child: Text(profileState.message),
                    ),
                  );
                }
                if (profileState is MyProfileLoaded) {
                  final String currentUserId = profileState.profile.id;
                  final bool isCurrentUserAdmin = state.chatGroup.admins
                      .contains(
                    currentUserId,
                  );
                  return BlocListener<GroupActionsBloc, GroupActionsState>(
                    listener: (context, groupActionsState) {
                      if(groupActionsState is GroupLeaveSuccess){
                        context.read<MyGroupsBloc>().add(GetMyGroups());
                        context.go('/chatHome');
                      }
                      if(groupActionsState is GroupActionsError){
                        CustomSnackBar.show(context, message: groupActionsState.message, type: SnackBarType.error);
                      }
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(state.chatGroup.name),
                        actions: [
                          PopupMenuButton(
                            icon: Icon(Icons.menu),
                            onSelected: (value) {
                              if (value == 'see_members') {
                                context.pushNamed(
                                    'chatMembers', extra: widget.groupId);
                              }
                              if (value == 'add_member') {
                                _showAddMemberDialog(context);
                              }
                              if (value == 'leave_group') {
                                context.read<GroupActionsBloc>().add(
                                    LeaveGroup(widget.groupId));
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'see_members',
                                  child: Text('See Members'),
                                ),
                                if(isCurrentUserAdmin)
                                  PopupMenuItem(
                                    value: 'add_member',
                                    child: Text('Add member'),
                                  ),
                                PopupMenuItem(
                                  value: 'leave_group',
                                  child: Text('Leave Group'),
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
                              SizedBox(height: deviceHeight * 0.02,),
                              ShowPickedImage(),
                              ChatMessagesBottom(controller: _messageController,
                                groupId: widget.groupId,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Member'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter member email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancel'),
            ),
            BlocConsumer<GroupMemberBloc, GroupMemberState>(
              listener: (context, state) {
                if (state is MemberAdded) {
                  CustomSnackBar.show(context, message: 'Member added successfully', type: SnackBarType.success);
                  context.pop();
                  context.read<GroupDetailsBloc>().add(GetChatGroup(widget.groupId));
                }
              },
              builder: (context, state) {
                if (state is GroupMemberLoading) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text.trim();
                    if (email.isNotEmpty) {
                      context.read<GroupMemberBloc>().add(
                          AddMember(widget.groupId, email));
                    }
                  },
                  child: Text('Add'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
