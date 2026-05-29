import 'package:mevtech/core/utils/constants.dart';

class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.settings,
    required this.isPrivate,
    required this.maxMembers,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.password,
    this.lastMessageAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      createdBy: (json['createdBy'] ?? '') as String,
      members: (json['members'] ?? <dynamic>[]) as List<dynamic>,
      settings: Settings.fromJson(json['settings'] as Map<String, dynamic>),
      isPrivate: (json['isPrivate'] ?? false) as bool,
      password: checkNullString(json['password']),
      maxMembers: (json['maxMembers'] ?? 0) as int,
      isArchived: (json['isArchived'] ?? false) as bool,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }

  final String id;
  final String name;
  final String description;
  final String createdBy;
  final List<dynamic> members;
  final Settings settings;
  final bool isPrivate;
  final String? password;
  final int maxMembers;
  final bool isArchived;
  final String createdAt;
  final String updatedAt;
  final String? lastMessageAt;
}

class CreateRoomGroup {
  const CreateRoomGroup({
    required this.groupName,
    this.password,
    this.isPrivate = false,
  });

  final String groupName;
  final String? password;
  final bool isPrivate;

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'password': password,
      'isPrivate': isPrivate,
    };
  }
}

class JoinRoom {
  const JoinRoom({
    required this.roomId,
    required this.roomName,
    this.password,
    this.isPrivate = false,
  });

  final String roomId;
  final String roomName;
  final String? password;
  final bool isPrivate;

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'password': password,
      'isPrivate': isPrivate
    };
  }
}

class CreateCommunityRoom {
  CreateCommunityRoom(this.communityName);

  final String communityName;
  Map<String, dynamic> toJson() {
    return {'communityName': 'string'};
  }
}

class Settings {
  const Settings({this.memberCount = 0});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      memberCount: json.isNotEmpty ? (json['memberCount'] ?? 0) as int : 0,
    );
  }

  final int memberCount;
}
