import 'dart:io';
import 'package:taskflow/features/chat/data/data_sources/local/chat_group_local_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_group_remote_data_source.dart';
import 'package:taskflow/features/chat/data/mappers/chat_group_mapper.dart';
import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/domain/entities/my_chat_groups.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';

class ChatGroupRepositoryImpl extends ChatGroupRepository {
  final ChatGroupRemoteDataSource chatGroupRemoteDataSource;
  final ChatGroupLocalDataSource chatGroupLocalDataSource;

  ChatGroupRepositoryImpl(
      this.chatGroupRemoteDataSource,
      this.chatGroupLocalDataSource,
      );

  @override
  Future<MyChatGroups> getMyGroups() async {
    try {
      final response = await chatGroupRemoteDataSource.getMyGroups();

      final groups = response.groups
          .map((val) => ChatGroupEntity(id: val.id, name: val.name))
          .toList();

      await chatGroupLocalDataSource.saveMyGroups(response);

      return MyChatGroups(groups: groups);
    } on SocketException {
      final local = await chatGroupLocalDataSource.getMyGroups();
      final groups = local.groups
          .map((val) => ChatGroupEntity(id: val.id, name: val.name))
          .toList();
      return MyChatGroups(groups: groups);
    } catch (e) {
      throw Exception('Error fetching my groups: $e');
    }
  }

  @override
  Future<bool> createGroup(String name, List<String> memberEmails) async {
    try {
      return await chatGroupRemoteDataSource.createGroup(name, memberEmails);
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  @override
  Future<ChatGroup> getGroup(String groupId) async {
    try {
      final groupData = await chatGroupRemoteDataSource.getGroup(groupId);

      await chatGroupLocalDataSource.saveGroup(groupData);

      return mapGroupModelToEntity(groupData);
    } on SocketException {
      final local = await chatGroupLocalDataSource.getGroup(groupId);
      return mapGroupModelToEntity(local);
    } catch (e) {
      throw Exception('Error fetching group: $e');
    }
  }
}
