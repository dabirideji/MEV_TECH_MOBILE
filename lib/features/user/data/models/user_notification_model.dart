class NotificationModel {
  NotificationModel({
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      userId: (json['userId'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      message: (json['message'] ?? '') as String,
      isRead: (json['isRead'] ?? false) as bool,
      readAt: json['readAt'] != null ? json['readAt'] as String : null,
      id: (json['id'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }
  final String userId;
  final String title;
  final String message;
  final bool isRead;
  final String? readAt;
  final String id;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'message': message,
        'isRead': isRead,
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'readAt': readAt,
      };
}
