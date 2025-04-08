
import 'package:hive/hive.dart';
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';
import 'package:taskflow/features/my_tasks/data/models/my_tasks_model.dart';
import 'package:taskflow/features/profile/data/models/profile_model.dart';
import 'package:taskflow/shared/data/models/task_model.dart';

Future<void> registerAdapters()async{
Hive.registerAdapter(ChatGroupItemAdapter());
Hive.registerAdapter(MyChatGroupsModelAdapter());
await  Hive.openBox('MyChatGroup');

Hive.registerAdapter(ChatGroupModelAdapter());
Hive.registerAdapter(MemberModelAdapter());
await  Hive.openBox('ChatGroup');

Hive.registerAdapter(ProfileModelAdapter());
await  Hive.openBox('Profile');

Hive.registerAdapter(MyTasksModelAdapter());
await  Hive.openBox('MyTasks');

Hive.registerAdapter(MessageModelAdapter());
Hive.registerAdapter(MessagesListAdapter());
Hive.registerAdapter(TaskModelAdapter());
await  Hive.openBox('Messages');


}