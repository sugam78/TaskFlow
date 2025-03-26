import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/resources/app_colors.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/chat/presentation/manager/create_group_bloc/create_group_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/my_groups_bloc/my_groups_bloc.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  State<CreateGroupBottomSheet> createState() => _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: deviceWidth * 0.02,
        right: deviceWidth * 0.02,
        top: deviceWidth * 0.02,
        bottom: MediaQuery.of(context).viewInsets.bottom + deviceWidth * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: deviceWidth * 0.08,
              height: deviceHeight * 0.008,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(deviceWidth * 0.02),
              ),
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          Text(
            'Create Group',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: deviceHeight * 0.01),
          BlocBuilder<CreateGroupBloc, CreateGroupState>(
            builder: (context, state) {
              String groupName = state is CreateGroupData ? state.groupName : '';

              return TextField(
                controller: _groupNameController..text = groupName,
                decoration: const InputDecoration(labelText: 'Group Name'),
                onChanged: (value) => context.read<CreateGroupBloc>().add(UpdateGroupName(value)),
              );
            },
          ),
          SizedBox(height: deviceHeight * 0.01),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter Email',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    context.read<CreateGroupBloc>().add(AddEmail(_emailController.text));
                    _emailController.clear();
                  }
                },
              ),
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          Text(
            'Added Emails:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: deviceHeight * 0.005),
          BlocBuilder<CreateGroupBloc, CreateGroupState>(
            builder: (context, state) {
              if (state is CreateGroupData && state.emails.isNotEmpty) {
                return SizedBox(
                  height: deviceHeight * 0.3,
                  child: ListView.builder(
                    itemCount: state.emails.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(state.emails[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle, color: AppColors.error),
                        onPressed: () => context.read<CreateGroupBloc>().add(RemoveEmail(index)),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: deviceHeight * 0.01),
          BlocConsumer<CreateGroupBloc, CreateGroupState>(
            listener: (context,state){
              if(state is CreateGroupLoaded){
                context.read<MyGroupsBloc>().add(GetMyGroups());
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  if (state is CreateGroupData && state.groupName.isNotEmpty && state.emails.isNotEmpty) {
                    context.read<CreateGroupBloc>().add(CreateGroup(state.groupName, state.emails));
                    context.pop();
                  }
                },
                child: const Text('Create Group'),
              );
            },
          ),
        ],
      ),
    );
  }
}
