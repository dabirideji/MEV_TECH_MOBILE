class ChatUser {
  ChatUser({
    required this.id,
    required this.username,
    required this.email,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: (json['id'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
    );
  }

  final String id;
  final String username;
  final String email;
}
