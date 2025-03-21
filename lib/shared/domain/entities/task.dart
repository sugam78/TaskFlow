class Task {
  final String id;
  final String title;
  final String? description;
  final String assignedTo;
  final String status;
  final DateTime? dueDate;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    required this.status,
    this.dueDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}