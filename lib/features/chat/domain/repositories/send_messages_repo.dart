
abstract class SendMessagesRepository{
  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId);
}