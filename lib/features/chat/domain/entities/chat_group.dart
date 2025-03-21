
class ChatGroup {
  final String id;
  final String name;
  final List<Member> members;
  final List<String> messages;
  final List<String> admins;
  final DateTime createdAt;

  ChatGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.messages,
    required this.admins,
    required this.createdAt,
  });

}

class Member {
  final String id;
  final String name;
  final String email;

  Member({required this.id, required this.name, required this.email});

}

