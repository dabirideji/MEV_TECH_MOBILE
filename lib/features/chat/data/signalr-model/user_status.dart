enum UserOnlineStatus { online, offline, away }

class UserStatus {
  UserStatus({
    required this.userId,
    required this.username,
    required this.status,
    required this.lastSeen,
    required this.currentRoom,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      userId: json['userId'] as String,
      username: json['username'] as String,
      status: UserOnlineStatus.values.firstWhere((e) =>
          e.name.toLowerCase() == (json['status'] as String).toLowerCase()),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      currentRoom: json['currentRoom'] as String,
    );
  }
  final String userId;
  final String username;
  final UserOnlineStatus status;
  final DateTime lastSeen;
  final String currentRoom;
}
