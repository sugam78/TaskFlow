import 'package:hive/hive.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';

abstract class ChatMessagesLocalDataSource {
  Future<MessagesList> getMessages(String groupId, int page, int limit);
  Future<void> saveMessages(String groupId, MessagesList messagesList);
}

class ChatMessagesLocalDataSourceImpl extends ChatMessagesLocalDataSource {
  final _box = Hive.box('Messages');

  @override
  Future<MessagesList> getMessages(String groupId, int page, int limit) async {
    final allMessagesList = _box.get(groupId);
    if (allMessagesList != null && allMessagesList is MessagesList) {
      final start = (page - 1) * limit;
      final end = start + limit;
      final paginatedMessages = allMessagesList.messages.sublist(
        start,
        end > allMessagesList.messages.length
            ? allMessagesList.messages.length
            : end,
      );
      return MessagesList(messages: paginatedMessages);
    } else {
      throw "No Internet connection";
    }
  }

  @override
  Future<void> saveMessages(String groupId, MessagesList messagesList) async {
      await _box.put(groupId, messagesList);
  }
}
