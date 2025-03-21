class MyChatGroupsModel {
  final List<ChatGroupItem> groups;

  const MyChatGroupsModel({required this.groups});

  factory MyChatGroupsModel.fromJson(List<dynamic> json) {
    return MyChatGroupsModel(
      groups: json.map((group) => ChatGroupItem.fromJson(group)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return groups.map((group) => group.toJson()).toList();
  }
}

class ChatGroupItem {
  final String id;
  final String name;

  const ChatGroupItem({required this.id, required this.name});

  factory ChatGroupItem.fromJson(Map<String, dynamic> json) {
    return ChatGroupItem(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
