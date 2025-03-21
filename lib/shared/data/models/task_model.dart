class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String assignedTo;
  final String status;
  final DateTime? dueDate;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
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

  // Convert JSON to Task Object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assignedTo'],
      status: json['status'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert Task Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "assignedTo": assignedTo,
      "status": status,
      "dueDate": dueDate?.toIso8601String(),
      "createdBy": createdBy,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
