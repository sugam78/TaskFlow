import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/profile/presentation/manager/my_profile_bloc/my_profile_bloc.dart';
import 'package:taskflow/shared/domain/entities/task.dart';
import 'package:taskflow/shared/presentation/manager/chat_task_bloc/chat_task_bloc.dart';

class TaskViewWidget extends StatelessWidget {
  final Task task;

  const TaskViewWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileBloc, MyProfileState>(
  builder: (context, profileState) {
    if(profileState is MyProfileInitial){
      context.read<MyProfileBloc>().add(GetMyProfile());
    }
    if(profileState is MyProfileLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(profileState is MyProfileError){
      return Center(
        child: Text(profileState.message),
      );
    }
    if(profileState is MyProfileLoaded) {
      return Card(
        margin:  EdgeInsets.all(deviceWidth * 0.03),
        child: Padding(
          padding:  EdgeInsets.all(deviceWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              SizedBox(height: deviceHeight * 0.008),
              if (task.description != null)
                Text(task.description!, style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium),
              SizedBox(height: deviceHeight * 0.008),
              Text("Assigned to: ${task.assignedTo}"),
              Text("Created by: ${task.createdBy}"),
              if (task.dueDate != null) Text(
                  "Due Date: ${task.dueDate!.toLocal()}"),
              SizedBox(height: deviceHeight * 0.16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status:"),
                  BlocConsumer<ChatTaskBloc, ChatTaskState>(
                    listener: (context, state) {
                      if (state is ChatTaskError) {
                        CustomSnackBar.show(context, message: state.message,
                            type: SnackBarType.error);
                      }
                    },
                    builder: (context, state) {
                      final chatTaskBloc = context.read<ChatTaskBloc>();
                      String selectedStatus = task.status;

                      if (state is ChatTaskUpdated && state.taskId == task.id) {
                        selectedStatus = state.status;
                      } else {
                        selectedStatus =
                            chatTaskBloc.taskStatusMap[task.id] ?? task.status;
                      }
                      final bool canChange = profileState.profile.email == task.assignedTo;
                      return DropdownButton<String>(
                        value: selectedStatus,
                        items: ["pending", "in-progress", "completed"]
                            .map((status) =>
                            DropdownMenuItem(
                                value: status, child: Text(status)))
                            .toList(),
                        onChanged: canChange
                            ? (newStatus) {
                          if (newStatus != null) {
                            context.read<ChatTaskBloc>().add(UpdateTask(task.id, newStatus));
                          }
                        }
                            : null,
                      );
                    },
                  ),
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
}
