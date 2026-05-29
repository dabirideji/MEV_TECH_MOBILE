import 'dart:io';

import 'package:mevtech/core/utils/constants.dart';

class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.username,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.metadata,
    required this.isEdited,
    required this.replyToMessageId,
    required this.mentions,
    required this.isDeleted,
    required this.media,
    required this.editedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: (json['id'] ?? '') as String,
      roomId: (json['roomId'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      timestamp: (json['timestamp'] ?? '') as String,
      metadata:
          (json['metadata'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      isEdited: (json['isEdited'] ?? false) as bool,
      replyToMessageId: checkNullString(json['replyToMessageId']),
      mentions: (json['mentions'] ?? <dynamic>[]) as List<dynamic>,
      isDeleted: (json['isDeleted'] ?? false) as bool,
      media: checkNullString(json['media']),
      editedAt: checkNullString(json['editedAt']),
      deletedAt: checkNullString(json['deletedAt']),
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }
  final String id;
  final String roomId;
  final String userId;
  final String username;
  final String content;
  final String type;
  final String timestamp;
  final Map<String, dynamic> metadata;
  final bool isEdited;
  final String? replyToMessageId;
  final List<dynamic> mentions;
  final bool isDeleted;
  final String? media;
  final String? editedAt;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'username': username,
      'content': content,
      'type': type,
      'timestamp': timestamp,
      'metadata': metadata,
      'isEdited': isEdited,
      'replyToMessageId': replyToMessageId,
      'mentions': mentions,
      'isDeleted': isDeleted,
      'media': media,
      'editedAt': editedAt,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ChatMessageRequest {
  const ChatMessageRequest({
    required this.roomId,
    required this.content,
    required this.replyToId,
    this.messageType = 'Text',
    this.mediaFile,
  });

  final String roomId;
  final String content;
  final File? mediaFile;
  final String messageType;
  final String replyToId;
}
