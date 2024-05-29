import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final String priority;
  final String userId;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
    required this.userId,
  });

  Reminder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        time = (json['time'] as Timestamp).toDate(),
        priority = json['priority'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'time': time,
        'priority': priority,
        'userId': userId,
      };
}
