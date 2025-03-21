import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';

ChatGroup mapGroupModelToEntity(ChatGroupModel groupData) {
  return ChatGroup(
    id: groupData.id,
    name: groupData.name,
    members: groupData.members.map((val) {
      return Member(id: val.id, name: val.name, email: val.email);
    }).toList(),
    messages: groupData.messages,
    admins: groupData.admins,
    createdAt: groupData.createdAt,
  );
}
