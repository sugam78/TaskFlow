
class ChatGroupModel {
  final String id;
  final String name;
  final List<MemberModel> members;
  final List<String> admins;
  final List<String> messages;
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
      messages: (json['messages'] as List<dynamic>).map((e) => e.toString()).toList(),
      admins: (json['admins'] as List<dynamic>).map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class MemberModel {
  final String id;
  final String name;
  final String email;

  MemberModel({required this.id, required this.name, required this.email});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

