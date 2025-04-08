import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 6)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String assignedTo;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final String createdBy;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
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
