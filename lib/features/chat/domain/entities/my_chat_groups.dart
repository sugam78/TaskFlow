class MyChatGroups {
  final List<ChatGroupEntity> groups;

  const MyChatGroups({required this.groups});
}

class ChatGroupEntity {
  final String id;
  final String name;

  const ChatGroupEntity({required this.id, required this.name});
}
