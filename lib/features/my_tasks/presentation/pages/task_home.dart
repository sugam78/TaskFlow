import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/features/my_tasks/presentation/manager/my_tasks_bloc/my_tasks_bloc.dart';
import 'package:taskflow/shared/presentation/widgets/task_view.dart';

class TaskHome extends StatelessWidget {
  const TaskHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
      ),
      body: BlocBuilder<MyTasksBloc,MyTasksState>(builder: (context,state){
        if(state is MyTasksInitial){
          context.read<MyTasksBloc>().add(FetchMyTasks());
        }
        if(state is MyTasksLoading){
          return Center(child: CircularProgressIndicator(),);
        }
        if(state is MyTasksError){
          return Center(child: Text(state.message),);
        }
        if(state is MyTasksLoaded){
          return ListView.builder(
              itemCount: state.myTasks.taskList.length,
              itemBuilder: (context,index){
            return TaskViewWidget(task: state.myTasks.taskList[index]);
          });
        }
        return SizedBox.shrink();
      }),
    );
  }
}
