import 'dart:convert';

import 'package:template/features/chat/chat-constant/chat_color_scheme.dart';

class ChatMessage {
  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.timestamp,
    this.roomId,
    this.recipientId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageld'] as String,
      roomId: json['roomld'] as String?,
      senderId: json['senderld'] as String,
      senderUsername: json['senderUsername'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      recipientId: json['recipientld'] as String?,
    );
  }
  final String messageId;
  final String? roomId; // Null for Direct Messages
  final String senderId;
  final String senderUsername;
  final String content;
  final DateTime timestamp;
  final String? recipientId; // Only for Direct Messages
}

class TypingIndicator {
  TypingIndicator({
    required this.roomId,
    required this.userId,
    required this.username,
    required this.isTyping,
    required this.timestamp,
  });

  factory TypingIndicator.fromJson(Map<String, dynamic> json) {
    return TypingIndicator(
      roomId: json['roomId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      isTyping: json['isTyping'] as bool,
      timestamp: json['timestamp'] as String,
    );
  }
  final String roomId;
  final String userId;
  final String username;
  final bool isTyping;
  final String timestamp;
}

class MessageModel {
  MessageModel({
    required this.roomId,
    required this.userId,
    required this.username,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.metadata,
    required this.isEdited,
    required this.replyToMessageId,
    required this.replyToMessage,
    required this.mentions,
    required this.mediaId,
    required this.readStatuses,
    required this.media,
    required this.editedAt,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.rowVersion,
    required this.createdBy,
    required this.updatedBy,
    required this.isDeleted,
    required this.deletedAt,
    required this.deletedBy,
    required this.isArchived,
    required this.archivedAt,
    required this.archivedBy,
    required this.physicallyArchivedAt,
    required this.archiveReason,
    this.isSending = false,
    this.isFailed = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      roomId: (json['roomId'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      timestamp: (json['timestamp'] ?? '') as String,
      metadata:
          (json['metadata'] ?? <String, dynamic>{}) as Map<String, dynamic>?,
      isEdited: (json['isEdited'] ?? false) as bool,
      replyToMessageId: json['replyToMessageId'] as String?,
      replyToMessage: json['replyToMessage'] as String?,
      mentions: (json['mentions'] ?? <dynamic>[]) as List<dynamic>,
      mediaId: json['mediaId'] as String?,
      readStatuses: (json['readStatuses'] ?? <dynamic>[]) as List<dynamic>,
      media: json['media'],
      editedAt: json['editedAt'] as String?,
      id: (json['id'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
      rowVersion: (json['rowVersion'] ?? '') as String,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      isDeleted: (json['isDeleted'] ?? false) as bool,
      deletedAt: json['deletedAt'] as String?,
      deletedBy: json['deletedBy'] as String?,
      isArchived: (json['isArchived'] ?? false) as bool,
      archivedAt: json['archivedAt'] as String?,
      archivedBy: json['archivedBy'] as String?,
      physicallyArchivedAt: json['physicallyArchivedAt'] as String?,
      archiveReason: json['archiveReason'] as String?,
    );
  }
  final String roomId;
  final String userId;
  final String username;
  final String content;
  final String type;
  final String timestamp;
  final Map<String, dynamic>? metadata;
  final bool isEdited;
  final String? replyToMessageId;
  final String? replyToMessage;
  final List<dynamic> mentions;
  final String? mediaId;
  final List<dynamic> readStatuses;
  final dynamic media;
  final String? editedAt;
  final String id;
  final String createdAt;
  final String updatedAt;
  final String rowVersion;
  final String? createdBy;
  final String? updatedBy;
  final bool isDeleted;
  final String? deletedAt;
  final String? deletedBy;
  final bool isArchived;
  final String? archivedAt;
  final String? archivedBy;
  final String? physicallyArchivedAt;
  final String? archiveReason;
  final bool isSending;
  final bool isFailed;

  // ignore: sort_constructors_first
  factory MessageModel.createSending({
    required String id,
    required String content,
    required String userId,
    required String username,
    required String roomId,
  }) {
    return MessageModel(
      roomId: roomId,
      userId: userId,
      username: username,
      content: content,
      type: 'Text',
      timestamp: DateTime.now().toLocal().toIso8601String(),
      metadata: {},
      isEdited: false,
      replyToMessageId: null,
      replyToMessage: null,
      mentions: [],
      mediaId: null,
      readStatuses: [],
      media: <dynamic>{},
      editedAt: null,
      id: id,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      rowVersion: '',
      createdBy: null,
      updatedBy: null,
      isDeleted: false,
      deletedAt: null,
      deletedBy: null,
      isArchived: false,
      archivedAt: null,
      archivedBy: null,
      physicallyArchivedAt: null,
      archiveReason: null,
      isSending: true,
    );
  }

  MessageModel copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? username,
    String? content,
    String? type,
    String? timestamp,
    Map<String, dynamic>? metadata,
    bool? isEdited,
    String? replyToMessageId,
    String? replyToMessage,
    List<dynamic>? mentions,
    String? mediaId,
    List<dynamic>? readStatuses,
    dynamic media,
    String? editedAt,
    String? createdAt,
    String? updatedAt,
    String? rowVersion,
    String? createdBy,
    String? updatedBy,
    bool? isDeleted,
    String? deletedAt,
    String? deletedBy,
    bool? isArchived,
    String? archivedAt,
    String? archivedBy,
    String? physicallyArchivedAt,
    String? archiveReason,
    bool? isSending, // Crucial for Optimistic UI updates
    bool? isFailed, // Crucial for failure status updates
  }) {
    return MessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      isEdited: isEdited ?? this.isEdited,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      mentions: mentions ?? this.mentions,
      mediaId: mediaId ?? this.mediaId,
      readStatuses: readStatuses ?? this.readStatuses,
      media: media ?? this.media,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowVersion: rowVersion ?? this.rowVersion,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      archivedBy: archivedBy ?? this.archivedBy,
      physicallyArchivedAt: physicallyArchivedAt ?? this.physicallyArchivedAt,
      archiveReason: archiveReason ?? this.archiveReason,
      // Update the flags using the null-aware coalescing operator (??)
      isSending: isSending ?? this.isSending,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}

extension MessageModelMapper on MessageModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'username': username,
      'content': content,
      'type': type,
      'timestamp': timestamp,
      'metadata': jsonEncode(metadata ?? {}),
      'isEdited': isEdited ? 1 : 0,
      'replyToMessageId': replyToMessageId,
      'replyToMessage': replyToMessage,
      'mentions': jsonEncode(mentions),
      'mediaId': mediaId,
      'readStatuses': jsonEncode(readStatuses),
      'media': jsonEncode(media),
      'editedAt': editedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isDeleted': isDeleted ? 1 : 0,
      'deletedAt': deletedAt,
      'deletedBy': deletedBy,
      'isArchived': isArchived ? 1 : 0,
      'archivedAt': archivedAt,
      'archivedBy': archivedBy,
      'physicallyArchivedAt': physicallyArchivedAt,
      'archiveReason': archiveReason,
    };
  }

  static MessageModel fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: (map['id'] ?? '') as String,
      roomId: (map['roomId'] ?? '') as String,
      userId: (map['userId'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      content: (map['content'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      timestamp: (map['timestamp'] ?? '') as String,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : <String, dynamic>{},
      isEdited: (map['isEdited'] ?? 0) == 1,
      replyToMessageId: map['replyToMessageId'] as String?,
      replyToMessage: map['replyToMessage'] as String?,
      mentions:
          map['mentions'] != null && (map['mentions'] as String).isNotEmpty
              ? (jsonDecode(map['mentions'] as String) as List<dynamic>)
              : <dynamic>[],
      mediaId: map['mediaId'] as String?,
      readStatuses: (map['readStatuses'] != null) &&
              (map['readStatuses'] as String).isNotEmpty
          ? (jsonDecode(map['readStatuses'] as String) as List<dynamic>)
          : <dynamic>[],
      media: (map['media'] != null) ? jsonDecode(map['media'] as String) : null,
      editedAt: map['editedAt'] as String?,
      createdAt: (map['createdAt'] ?? '') as String,
      updatedAt: (map['updatedAt'] ?? '') as String,
      rowVersion: (map['rowVersion'] ?? '') as String,
      createdBy: map['createdBy'] as String?,
      updatedBy: map['updatedBy'] as String?,
      isDeleted: (map['isDeleted'] ?? 0) == 1,
      deletedAt: map['deletedAt'] as String?,
      deletedBy: map['deletedBy'] as String?,
      isArchived: (map['isArchived'] ?? 0) == 1,
      archivedAt: map['archivedAt'] as String?,
      archivedBy: map['archivedBy'] as String?,
      physicallyArchivedAt: map['physicallyArchivedAt'] as String?,
      archiveReason: map['archiveReason'] as String?,
    );
  }
}

// message sent, and received response

// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "messageId": "3f5e0c31-019a-0000-0100-010004fa4202",
//     "content": "this is me kunle, am trying to do a test message on the Elite group",
//     "messageType": "Text",
//     "mediaUrl": null,
//     "timestamp": "2025-11-01T12:21:59.8387334+00:00",
//     "replyToMessage": null
//   }
// }
