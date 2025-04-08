import 'package:hive/hive.dart';
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';

abstract class ChatGroupLocalDataSource {
  Future<MyChatGroupsModel> getMyGroups();
  Future<void> saveMyGroups(MyChatGroupsModel myChatGroupModel);
  Future<ChatGroupModel> getGroup(String groupId);
  Future<void> saveGroup(ChatGroupModel chatGroupModel);
}

class ChatGroupLocalDataSourceImpl extends ChatGroupLocalDataSource {
  final Box myChatGroupBox = Hive.box('MyChatGroup');
  final Box chatGroupBox = Hive.box('ChatGroup');

  @override
  Future<MyChatGroupsModel> getMyGroups() async {
    final data = myChatGroupBox.get('myGroups');
    if (data != null && data is MyChatGroupsModel) {
      return data;
    } else {
      throw "No Internet connection";
    }
  }

  @override
  Future<void> saveMyGroups(MyChatGroupsModel myChatGroupModel) async {
    await myChatGroupBox.put('myGroups', myChatGroupModel);
  }

  @override
  Future<ChatGroupModel> getGroup(String groupId) async {
    final data = chatGroupBox.get(groupId);
    if (data != null && data is ChatGroupModel) {
      return data;
    } else {
      throw "No Internet connection";
    }
  }

  @override
  Future<void> saveGroup(ChatGroupModel chatGroupModel) async {
    await chatGroupBox.put(chatGroupModel.id, chatGroupModel);
  }
}
