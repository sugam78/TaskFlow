import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/features/chat/presentation/manager/create_group_bloc/create_group_bloc.dart';

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
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Create Group',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          const Text(
            'Added Emails:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          BlocBuilder<CreateGroupBloc, CreateGroupState>(
            builder: (context, state) {
              if (state is CreateGroupData && state.emails.isNotEmpty) {
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: state.emails.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(state.emails[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => context.read<CreateGroupBloc>().add(RemoveEmail(index)),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<CreateGroupBloc, CreateGroupState>(
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
