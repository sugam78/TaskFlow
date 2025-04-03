import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/presentation/manager/group_details_bloc/group_details_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/group_member_bloc/group_member_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/make_admin_bloc/make_admin_bloc.dart';
import 'package:taskflow/features/profile/presentation/manager/my_profile_bloc/my_profile_bloc.dart';

class ChatMembers extends StatelessWidget {
  final String groupId;

  const ChatMembers({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Members'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.05,
          vertical: deviceHeight * 0.03,
        ),
        child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, groupState) {
            if (groupState is GroupDetailsInitial) {
              context.read<GroupDetailsBloc>().add(GetChatGroup(groupId));
            } else if (groupState is GroupDetailsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (groupState is GroupDetailsError) {
              return Center(child: Text(groupState.message));
            } else if (groupState is GroupDetailsLoaded) {
              final ChatGroup group = groupState.chatGroup;
      
              return BlocBuilder<MyProfileBloc, MyProfileState>(
                builder: (context, profileState) {
                  if (profileState is MyProfileInitial) {
                    context.read<MyProfileBloc>().add(GetMyProfile());
                  }
                  if (profileState is MyProfileLoaded) {
                    final String currentUserId = profileState.profile.id;
                    final bool isCurrentUserAdmin = group.admins.contains(
                      currentUserId,
                    );
      
                    return ListView.builder(
                      itemCount: group.members.length,
                      itemBuilder: (context, index) {
                        final Member member = group.members[index];
                        final bool isMemberAdmin = group.admins.contains(
                          member.id,
                        );
                        final bool isCurrentUser = member.id == profileState.profile.id;
      
                        return BlocListener<GroupMemberBloc, GroupMemberState>(
                          listener: (context, memberState) {
                            if (memberState is MemberRemoved) {
                              CustomSnackBar.show(
                                context,
                                message: 'Removed Successfully',
                                type: SnackBarType.success,
                              );
                              context.read<GroupDetailsBloc>().add(GetChatGroup(groupId));
                            }
                            if(memberState is GroupMemberError){
                              CustomSnackBar.show(
                                context,
                                message: memberState.message,
                                type: SnackBarType.error,
                              );
                            }
                          },
                          child: BlocListener<MakeAdminBloc, MakeAdminState>(
                            listener: (context, adminState) {
                              if (adminState is MakeAdminLoaded) {
                                CustomSnackBar.show(
                                  context,
                                  message: 'Made admin Successfully',
                                  type: SnackBarType.success,
                                );
                                context.read<GroupDetailsBloc>().add(GetChatGroup(groupId));
                              }
                              if (adminState is MakeAdminError) {
                                CustomSnackBar.show(
                                  context,
                                  message: adminState.message,
                                  type: SnackBarType.error,
                                );
                              }
                            },
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    member.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(width: deviceWidth * 0.03),
                                  isMemberAdmin
                                      ? Text(
                                        '(Admin)',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleSmall,
                                      )
                                      : SizedBox(),
                                ],
                              ),
                              subtitle: Text(member.email),
                              trailing: isCurrentUser?SizedBox():PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "make_admin") {
                                    context.read<MakeAdminBloc>().add(
                                      MakeGroupAdmin(groupId, member.email),
                                    );
                                  } else if (value == "remove_member") {
                                    context.read<GroupMemberBloc>().add(
                                      RemoveMember(groupId, member.email),
                                    );
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    if (isCurrentUserAdmin && !isMemberAdmin)
                                      PopupMenuItem(
                                        value: "make_admin",
                                        child: Text("Make Admin"),
                                      ),
                                    if (isCurrentUserAdmin)
                                      PopupMenuItem(
                                        value: "remove_member",
                                        child: Text("Remove Member"),
                                      ),
                                  ];
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
