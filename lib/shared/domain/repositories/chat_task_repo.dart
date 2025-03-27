abstract class ChatTaskRepository{
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId);
  Future<List<String>> updateTask(String taskId, String status);
}
