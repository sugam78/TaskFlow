import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/my_groups_bloc/my_groups_bloc.dart';
import 'package:taskflow/features/chat/presentation/widgets/chat_home_app_bar.dart';
import 'package:taskflow/features/chat/presentation/widgets/group_banner.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: ChatHomeAppBar()),
      body: BlocBuilder<MyGroupsBloc, MyGroupsState>(
        builder: (context, state) {
          if(state is MyGroupsInitial){
            context.read<MyGroupsBloc>().add(GetMyGroups());
          }
          if(state is MyGroupsLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is MyGroupsError){
            return Center(
              child: Text(state.message),
            );
          }
          if(state is MyGroupsLoaded) {
            final groups = state.myChatGroups.groups;
            if(groups.isEmpty){
              return Center(
                child: Text('No groups. Create one'),
              );
            }
            return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
              return GroupBanner(groupName: groups[index].name, groupId: groups[index].id);
            });
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
