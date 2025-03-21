import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/domain/entities/my_chat_groups.dart';

abstract class ChatGroupRepository{
  Future<MyChatGroups> getMyGroups();
  Future<bool> createGroup(String name, List<String> memberEmails);
  Future<ChatGroup> getGroup(String groupId);
}