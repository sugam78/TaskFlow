import 'dart:convert';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';

MyChatGroupsModel parseGroups(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return MyChatGroupsModel.fromJson(parsed);
}
