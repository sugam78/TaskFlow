import 'package:hive/hive.dart';

part 'my_chat_groups_model.g.dart';

@HiveType(typeId: 0)
class MyChatGroupsModel {
  @HiveField(0)
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

@HiveType(typeId: 1)
class ChatGroupItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
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
