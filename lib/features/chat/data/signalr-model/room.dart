import 'dart:convert';
import 'dart:developer';

import 'package:mevtech/core/utils/constants.dart';

class Room {
  Room({
    required this.roomId,
    required this.roomName,
    this.unreadCount,
    this.memberCount,
    this.lastMessage,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomld'] as String,
      roomName: json['roomName'] as String,
      unreadCount: json['unreadCount'] as int?,
      memberCount: json['memberCount'] as int?,
      lastMessage: json['lastMessage'] as Map<String, dynamic>?,
    );
  }
  final String roomId;
  final String roomName;
  final int? unreadCount; // Present in MyRooms
  final int? memberCount; // Present in PublicRooms
  final Map<String, dynamic>? lastMessage; // Placeholder for object structure
}

class MyRoom {
  MyRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.isPrivate,
    required this.unreadCount,
    this.lastMessageAt,
  });

  factory MyRoom.fromJson(Map<String, dynamic> json) {
    return MyRoom(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isPrivate: json['isPrivate'] as bool,
      unreadCount: json['unreadCount'] as int,
      lastMessageAt: checkNullString(json['lastMessageAt']),
    );
  }
  final String id;
  final String name;
  final String description;
  final bool isPrivate;
  final String? lastMessageAt;
  final int unreadCount;
}

class RoomMain {
  const RoomMain({
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

  factory RoomMain.fromJson(Map<String, dynamic> json) {
    return RoomMain(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      createdBy: (json['createdBy'] ?? '') as String,
      members: (json['members'] ?? <dynamic>[]) as List<dynamic>,
      settings: Setting.fromJson(json['settings'] as Map<String, dynamic>),
      isPrivate: (json['isPrivate'] ?? false) as bool,
      password: json['password'] as String?,
      lastMessageAt: json['lastMessageAt'] as String?,
      maxMembers: (json['maxMembers'] ?? 0) as int,
      isArchived: (json['isArchived'] ?? false) as bool,
      createdAt: normalizeApiTimestamp((json['createdAt'] ?? '') as String),
      updatedAt: normalizeApiTimestamp((json['updatedAt'] ?? '') as String),
    );
  }

  factory RoomMain.fromMap(Map<String, dynamic> map) {
    return RoomMain(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdBy: map['createdBy'] as String,

      members: listFromDbMap(map['members']),

      settings: Setting.fromMap(
        jsonDecode(map['settings'] as String) as Map<String, dynamic>,
      ),

      isPrivate: map['isPrivate'] == 1,
      password: map['password'] as String?,
      lastMessageAt: map['lastMessageAt'] as String?,
      maxMembers: map['maxMembers'] as int,
      isArchived: map['isArchived'] == 1,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': jsonEncode(members),
      'settings': jsonEncode(settings.toMap()),
      'isPrivate': isPrivate ? 1 : 0,
      'password': password,
      'lastMessageAt': lastMessageAt,
      'maxMembers': maxMembers,
      'isArchived': isArchived ? 1 : 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  //   {
  //   "id": "group_elite_club_638970821999777481",
  //   "name": "👥 Elite Club",
  //   "description": "",
  //   "createdBy": "a1d238c7-286f-4dfe-3caa-08de13e02cfa",
  //   "members": [],
  //   "settings": {
  //     "memberCount": 1,
  //     "otherRoomMembers": [],
  //     "mostRecentMessage": null,
  //     "unreadRoomMessagesCount": 0
  //   },
  //   "isPrivate": false,
  //   "password": null,
  //   "lastMessageAt": null,
  //   "maxMembers": 1000,
  //   "createdAt": "2025-10-26T13:30:00.2776357",
  //   "updatedAt": "2025-10-26T13:30:00.27759",
  //   "rowVersion": "AAAAAAAAGzo=",
  //   "updatedBy": null,
  //   "isDeleted": false,
  //   "deletedAt": null,
  //   "deletedBy": null,
  //   "isArchived": false,
  //   "archivedAt": null,
  //   "archivedBy": null,
  //   "physicallyArchivedAt": null,
  //   "archiveReason": null
  // }

  final String id;
  final String name;
  final String description;
  final String createdBy;
  final List<dynamic> members;
  final Setting settings;
  final bool isPrivate;
  final String? password;
  final int maxMembers;
  final bool isArchived;
  final String createdAt;
  final String updatedAt;
  final String? lastMessageAt;
}

class Setting {
  const Setting({
    this.memberCount = 0,
    this.otherRoomMembers = const [],
    this.mostRecentMessage,
    this.unreadRoomMessagesCount = 0,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    // if (json.isNotEmpty) log(json['otherRoomMembers'].toString());
    // var otherRoomMembers = <dynamic>[];
    // Map<String, dynamic>? mostRecentMessage;
    // if (json.isNotEmpty && json['otherRoomMembers'] is String) {
    //   otherRoomMembers =
    //       jsonDecode(json['otherRoomMembers'] as String) as List<dynamic>;
    // } else if (json.isNotEmpty) {
    //   otherRoomMembers =
    //       (json['otherRoomMembers'] ?? <dynamic>[]) as List<dynamic>;
    // }
    // if (json.isNotEmpty &&
    //     json['mostRecentMessage'] != null &&
    //     json['mostRecentMessage'] is String) {
    //   mostRecentMessage =
    //       jsonDecode(json['mostRecentMessage'] as String)
    //           as Map<String, dynamic>;
    // } else if (json.isNotEmpty && json['mostRecentMessage'] != null) {
    //   mostRecentMessage = (json['mostRecentMessage']) as Map<String, dynamic>;
    // }

    return Setting(
      memberCount: json.isNotEmpty ? (json['memberCount'] ?? 0) as int : 0,
      otherRoomMembers: json.isNotEmpty
          ? (json['otherRoomMembers'] ?? <dynamic>[]) as List<dynamic>
          : [],
      mostRecentMessage: json.isNotEmpty
          ? checkNullMap(json['mostRecentMessage'])
          : null,
      unreadRoomMessagesCount: json.isNotEmpty
          ? (json['unreadRoomMessagesCount'] ?? 0) as int
          : 0,
    );
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      memberCount: map.isNotEmpty ? (map['memberCount'] ?? 0) as int : 0,
      otherRoomMembers: map.isNotEmpty
          ? listFromDbMap(map['otherRoomMembers'])
          : [],
      mostRecentMessage: map.isNotEmpty
          ? mapFromDbMap(map['mostRecentMessage'])
          : null,
      unreadRoomMessagesCount: map.isNotEmpty
          ? (map['unreadRoomMessagesCount'] ?? 0) as int
          : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberCount': memberCount,
      'otherRoomMembers': jsonEncode(otherRoomMembers),
      'mostRecentMessage': jsonEncode(mostRecentMessage ?? {}),
      'unreadRoomMessagesCount': unreadRoomMessagesCount,
    };
  }

  final int memberCount;
  final List<dynamic> otherRoomMembers;
  final Map<String, dynamic>? mostRecentMessage;
  final int unreadRoomMessagesCount;
}

// "settings": {
//   "memberCount": 1,
//   "otherRoomMembers": [],
//   "mostRecentMessage": null,
//   "unreadRoomMessagesCount": 0
// },

class JoinedRoom {
  JoinedRoom({
    required this.userId,
    required this.username,
    required this.roomId,
    required this.timestamp,
  });

  factory JoinedRoom.fromJson(Map<String, dynamic> json) {
    return JoinedRoom(
      userId: (json['userId'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      roomId: (json['roomId'] ?? '') as String,
      timestamp: (json['timestamp'] ?? '') as String,
    );
  }

  final String userId;
  final String username;
  final String roomId;
  final String timestamp;

  @override
  String toString() {
    return 'time: $timestamp, rooms: $roomId, userId: $userId, userName: $username';
  }
}

class LeftRoom {
  LeftRoom({required this.roomId, required this.success});

  factory LeftRoom.fromJson(Map<String, dynamic> json) {
    return LeftRoom(
      roomId: json['roomId'] as String,
      success: json['success'] as bool,
    );
  }
  final String roomId;
  final bool success;
}

class RoomUsers {
  RoomUsers({required this.roomId, required this.users});

  factory RoomUsers.fromJson(Map<String, dynamic> json) {
    return RoomUsers(
      roomId: json['roomId'] as String,
      users: json['users'] as List,
    );
  }

  final String roomId;
  final List<dynamic> users;
}

// {
//   "id": "group_elite_club_638970821999777481",
//   "name": "👥 Elite Club",
//   "description": "",
//   "createdBy": "a1d238c7-286f-4dfe-3caa-08de13e02cfa",
//   "members": [],
//   "settings": {
//     "memberCount": 1,
//     "otherRoomMembers": [],
//     "mostRecentMessage": null,
//     "unreadRoomMessagesCount": 0
//   },
//   "isPrivate": false,
//   "password": null,
//   "lastMessageAt": null,
//   "maxMembers": 1000,
//   "createdAt": "2025-10-26T13:30:00.2776357",
//   "updatedAt": "2025-10-26T13:30:00.27759",
//   "rowVersion": "AAAAAAAAGzo=",
//   "updatedBy": null,
//   "isDeleted": false,
//   "deletedAt": null,
//   "deletedBy": null,
//   "isArchived": false,
//   "archivedAt": null,
//   "archivedBy": null,
//   "physicallyArchivedAt": null,
//   "archiveReason": null
// }
