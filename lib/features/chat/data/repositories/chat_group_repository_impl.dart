
import 'package:taskflow/features/chat/data/data_sources/remote/chat_group_remote_data_source.dart';

import 'package:taskflow/features/chat/data/mappers/chat_group_mapper.dart';
import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/domain/entities/my_chat_groups.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';

class ChatGroupRepositoryImpl extends ChatGroupRepository {
  final ChatGroupRemoteDataSource chatGroupRemoteDataSource;

  ChatGroupRepositoryImpl(this.chatGroupRemoteDataSource);

  // Method to fetch all my chat groups
  @override
  Future<MyChatGroups> getMyGroups() async {
    try {
      final response = await chatGroupRemoteDataSource.getMyGroups();

      final groups =
          response.groups.map((val) {
            return ChatGroupEntity(id: val.id, name: val.name);
          }).toList();
      return MyChatGroups(groups: groups);
    } catch (e) {
      throw '$e';
    }
  }

  // Method to create a new group
  @override
  Future<bool> createGroup(String name, List<String> memberEmails) async {
    try {
      return await chatGroupRemoteDataSource.createGroup(name, memberEmails);
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  // Method to fetch a specific group
  @override
  Future<ChatGroup> getGroup(String groupId) async {
    try {
      final groupData = await chatGroupRemoteDataSource.getGroup(groupId);

      // Map the response to ChatGroup entity
      return mapGroupModelToEntity(groupData);
    } catch (e) {
      throw Exception('Error fetching group: $e');
    }
  }
}
