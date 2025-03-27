import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/shared/domain/entities/task.dart';
import 'package:taskflow/shared/presentation/manager/chat_task_bloc/chat_task_bloc.dart';

class TaskViewWidget extends StatelessWidget {
  final Task task;

  const TaskViewWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (task.description != null)
              Text(task.description!, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("Assigned to: ${task.assignedTo}"),
            Text("Created by: ${task.createdBy}"),
            if (task.dueDate != null) Text("Due Date: ${task.dueDate!.toLocal()}"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status:"),
                BlocConsumer<ChatTaskBloc, ChatTaskState>(
                  listener: (context, state) {
                    if(state is ChatTaskError){
                      CustomSnackBar.show(context, message: state.message, type: SnackBarType.error);
                    }
                  },
                  builder: (context, state) {
                    final chatTaskBloc = context.read<ChatTaskBloc>();
                    String selectedStatus = task.status;

                    if (state is ChatTaskUpdated && state.taskId == task.id) {
                      selectedStatus = state.status;
                    } else {
                      selectedStatus = chatTaskBloc.taskStatusMap[task.id] ?? task.status;
                    }

                    return DropdownButton<String>(
                      value: selectedStatus,
                      items: ["pending", "in-progress", "completed"]
                          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          context.read<ChatTaskBloc>().add(UpdateTask(task.id, newStatus));
                        }
                      },
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
}
