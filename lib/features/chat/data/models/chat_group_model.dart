import 'package:hive/hive.dart';

part 'chat_group_model.g.dart';

@HiveType(typeId: 2)
class ChatGroupModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<MemberModel> members;

  @HiveField(3)
  final List<String> admins;

  @HiveField(4)
  final List<String> messages;

  @HiveField(5)
  final DateTime createdAt;

  ChatGroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.admins,
    required this.messages,
    required this.createdAt,
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json['_id'],
      name: json['name'],
      members: (json['members'] as List).map((e) => MemberModel.fromJson(e)).toList(),
      messages: (json['messages'] as List).map((e) => e.toString()).toList(),
      admins: (json['admins'] as List).map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

@HiveType(typeId: 3)
class MemberModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
