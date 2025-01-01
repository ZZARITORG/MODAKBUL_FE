class Notification {
  final String type;
  final String sourceUserId;
  final String sourceUserName;
  final DateTime createdAt;

  Notification({
    required this.type,
    required this.sourceUserId,
    required this.sourceUserName,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'] as String,
      sourceUserId: json['sourceUserId'] as String,
      sourceUserName: json['sourceUserName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sourceUserId': sourceUserId,
      'sourceUserName': sourceUserName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
