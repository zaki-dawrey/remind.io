class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final String priority;
  final String userId; // Add userId field

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
    required this.userId, // Initialize userId
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'priority': priority,
      'userId': userId, // Include userId in JSON
    };
  }

  static Reminder fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: DateTime.parse(json['time']),
      priority: json['priority'],
      userId: json['userId'], // Parse userId from JSON
    );
  }
}
