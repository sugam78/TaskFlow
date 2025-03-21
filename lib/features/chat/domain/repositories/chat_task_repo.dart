abstract class ChatTaskRepository{
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId);
  Future<void> updateTask(String taskId, String status);
}
