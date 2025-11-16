import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:template/core/error/failure_response.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/core/storages/DatabaseHandler.dart';
import 'package:template/features/chat/data/chat-data/chat_data_cubit.dart';
import 'package:template/features/chat/data/models/chat_message_model.dart';
import 'package:template/features/chat/data/models/room_model.dart';
import 'package:template/features/chat/data/signalr-model/chat_message.dart';
import 'package:template/features/chat/data/signalr-model/room.dart';
import 'package:template/features/chat/data/signalr-model/user_status.dart';

@singleton
class ChatRepository {
  ChatRepository(this.apiService, this._chatDataCubit);

  final ApiService apiService;
  final ChatDataCubit _chatDataCubit;

  final db = DatabaseHandler();

  final _newMessageController = StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get onNewMessage => _newMessageController.stream;

  Future<void> handleMessageReceived(MessageModel message) async {
    // 1. CRITICAL: Save the message to the local DB immediately
    await saveSingleMessageToDb(message);

    // 2. Broadcast the message to all listening Cubits (i.e., the SingleChatCubits)
    _newMessageController.add(message);
  }

  Future<void> handleMessageEdited(MessageModel message) async {
    await saveEditedMessageToDb(message);
    _newMessageController.add(message);
  }

  Future<void> handleMessageDeleted(MessageModel message) async {
    await deleteMessageFromToDb(message);
    _newMessageController.add(message);
  }

  // =============== Recurrent methods to fetch messages for the rooms ======

  // Future<void> pullMessagesFromRooms(List<RoomMain> rooms) async {
  //   for (var i = 0; i < rooms.length; i++) {
  //     final messages = await getChatMessages(chatRoomId: rooms[i].id);
  //     _chatDataCubit.getMessages(messages);
  //   }
  // }

  // ====================================================================
  // 2. PRIVATE: REGISTRATION METHOD
  // ====================================================================

  void registerEventHandlers(HubConnection chatHubConnection) {
    // Helper to extract the first argument and cast to Map
    Map<String, dynamic>? safeParse(List<Object?>? data) {
      if (data == null || data.isEmpty) return null;
      return data[0]! as Map<String, dynamic>;
    }

    // 1. Connection & Status
    chatHubConnection
      //  -- ChatConnected
      ..on('ReceiveConnectionId', (data) {
        getMyRooms(chatHubConnection);
      })
      //  UserStatusChanged
      ..on('USER_PRESENCE_UPDATED', (data) {
        try {
          // getMyRooms(chatHubConnection);
          final json = safeParse(data);
          if (json != null) {
            _chatDataCubit.getUserStatus(UserStatus.fromJson(json));
          }
        } catch (e) {
          log(e.toString());
        }
      })

      // // 2. Room Management
      //  JoinedRoom
      ..on('USER_JOINED_ROOM', (data) {
        if (data != null) {
          try {
            final dataMap = (data[0] ?? {}) as Map<String, dynamic>;
            final joinedRoomModel = JoinedRoom.fromJson(dataMap);
            // final room = dataMap['room'] as Map<String, dynamic>;
            log(joinedRoomModel.toString());
          } catch (e) {
            log(e.toString());
          }
        }
      })
      //  LeftRoom
      ..on('USER_LEFT_ROOM', (data) {
        if (data != null) {
          try {
            final dataMap = (data[0] ?? {}) as Map<String, dynamic>;
            final leftRoom = LeftRoom.fromJson(dataMap);
            log(leftRoom.roomId);
            log(leftRoom.success.toString());
          } catch (e) {
            log(e.toString());
          }
        }
      })
      //  -- MyRooms
      ..on('FETCHED_MY_ROOMS', (data) {
        if (data != null) {
          try {
            final item = data.first;
            final result = item != null ? item as List<dynamic> : <dynamic>[];
            final myRooms = result
                .map((room) => RoomMain.fromJson(room! as Map<String, dynamic>))
                .toList();

            _chatDataCubit.getMyRooms(myRooms);
            // pullMessagesFromRooms(myRooms);
          } catch (e) {
            log(e.toString());
          }
        }
      })
      ..on(
        'PublicRooms',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      //  RoomUsers
      ..on(
        'ROOM_USERS',
        (data) {
          if (data != null) {
            try {
              final dataMap = (data[0] ?? {}) as Map<String, dynamic>;
              final roomUsers = RoomUsers.fromJson(dataMap);
              log(roomUsers.roomId);
              log(roomUsers.users.toString());
            } catch (e) {
              log(e.toString());
            }
          }
        },
      )
      ..on(
        'RoomUsersError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      ) // Sending room errors to general error stream

      // 3. Messaging
      //  ReceiveMessage

      ..on('RECEIVE_DIRECT_MESSAGE', (data) {
        final json = safeParse(data);
        if (json != null) {
          // _chatDataCubit.getMessages([MessageModel.fromJson(json)]);
          handleMessageReceived(MessageModel.fromJson(json));
        }
      })
      //  MentionReceived
      ..on('RECEIVE_MENTION', (data) {
        final json = safeParse(data);
        if (json != null) {
          _chatDataCubit.getMessages([MessageModel.fromJson(json)]);
        }
      })
      ..on('MESSAGE_EDITED', (data) {
        final json = safeParse(data);
        if (json != null) {
          handleMessageEdited(MessageModel.fromJson(json));
        }
      })
      ..on('MESSAGE_DELETED', (data) {
        final json = safeParse(data);
        if (json != null) {
          handleMessageDeleted(MessageModel.fromJson(json));
        }
      })

      //  UserTyping
      ..on('USER_TYPING', (data) {
        final json = safeParse(data);

        if (json != null) {
          // log(json.toString());
          // final d = TypingIndicator.fromJson(json);
          // final s = d;
          _chatDataCubit.getUsersTyping(TypingIndicator.fromJson(json));
        }
      })
      ..on(
        'SearchResults',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'SearchError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )

      // 4. Unread Messages & Read Receipts
      ..on(
        'UnreadMessages',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'UnreadMessagesError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      //  UnreadCount
      ..on(
        'UNREAD_COUNT_UPDATED',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'UnreadCountError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'AllUnreadCounts',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'AllUnreadCountsError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      //  ReadStatusUpdated
      ..on(
        'USER_ROOM_READ_UPDATED', //here
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'MarkAsReadError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )

      // 5. Statistics
      //  RoomStats
      ..on(
        'ROOM_STATS',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'RoomStatsError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'GlobalStats',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on(
        'GlobalStatsError',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )

      // 6. Error Handling
      //  GeneralError
      ..on(
        'ERROR',
        (data) {
          log('Event triggered ${data?.length ?? -1}');
        },
      )
      ..on('ReceiveConnectionId', (data) {});
  }

  // Public method to send a message
  Future<void> sendMessage(HubConnection chatHubConnection, String text) {
    return chatHubConnection.invoke('SendMessage', args: [text]);
  }

  /// ============================ Public methods starts ====================//

  // In ChatRepository
// NOTE: Assume chatHubConnection is available and connected

// 1. Connection & Status
  Future<void> updateStatus(
    HubConnection chatHubConnection,
    UserOnlineStatus status,
  ) async {
    final statusString =
        status.name; // Converts enum to string (e.g., 'online')
    await chatHubConnection.invoke('UpdateStatus', args: [statusString]);
  }

// 2. Room Management
  Future<void> joinRoom({
    required String roomId,
    required HubConnection chatHubConnection,
    String roomName = '',
    String password = '',
  }) async {
    await chatHubConnection
        .invoke('JoinRoom', args: [roomId, roomName, password]);
  }

  Future<void> leaveRoom(HubConnection chatHubConnection, String roomId) async {
    await chatHubConnection.invoke('LeaveRoom', args: [roomId]);
  }

  Future<void> getMyRooms(HubConnection chatHubConnection) async {
    // Server will respond with the 'MyRooms' event
    try {
      await chatHubConnection.invoke('GetMyRooms');
    } catch (e) {
      log('$e');
    }
  }

  Future<void> getRoomUsers(
    HubConnection chatHubConnection,
    String roomId,
  ) async {
    // Server will respond with the 'RoomUsers' or 'RoomUsersError' event
    await chatHubConnection.invoke('GetRoomUsers', args: [roomId]);
  }

// 3. Messaging
  Future<void> getRoomMessages({
    required HubConnection chatHubConnection,
    required String roomId,
    String? fromMessageId,
    int count = 50,
  }) async {
    // Server will respond with the 'ReceiveMessage' event stream
    final result = await chatHubConnection.invoke(
      'GetRoomMessages',
      args: [roomId, fromMessageId ?? '', count],
    );
  }

  Future<void> searchMessages({
    required HubConnection chatHubConnection,
    required String roomId,
    required String searchTerm,
    int count = 20,
  }) async {
    // Server will respond with the 'SearchResults' or 'SearchError' event
    await chatHubConnection
        .invoke('SearchMessages', args: [roomId, searchTerm, count]);
  }

  Future<void> setTyping({
    required HubConnection chatHubConnection,
    required String roomId,
    bool isTyping = false,
  }) async {
    // Server broadcasts 'IsTyping' event
    try {
      await chatHubConnection.invoke('SetTyping', args: [roomId, isTyping]);
    } catch (e) {
      log(e.toString());
    }
  }

// 4. Unread Messages & Read Receipts
  Future<void> getUnreadMessages(
    HubConnection chatHubConnection,
    String roomId,
  ) async {
    // Server responds with 'UnreadMessages' or 'UnreadMessagesError'
    await chatHubConnection.invoke('GetUnreadMessages', args: [roomId]);
  }

  Future<void> getUnreadCount(
    HubConnection chatHubConnection,
    String roomId,
  ) async {
    // Server responds with 'UnreadCount' or 'UnreadCountError'
    final res =
        await chatHubConnection.invoke('GetUnreadCount', args: [roomId]);
  }

  Future<void> getAllUnreadCounts(
    HubConnection chatHubConnection,
  ) async {
    // Server responds with 'AllUnreadCounts' or 'AllUnreadCountsError'
    await chatHubConnection.invoke('GetAllUnreadCounts');
  }

  Future<void> markAsRead(
    HubConnection chatHubConnection,
    String roomId,
    String lastMessageId,
  ) async {
    // Server responds with 'ReadStatusUpdated' or 'MarkAsReadError'
    try {
      await chatHubConnection
          .invoke('MarkRoomAsRead', args: [roomId]); //  MarkAsRead
    } catch (e) {
      log(e.toString());
    }
  }

// 5. Statistics
  Future<void> getRoomStats(
    HubConnection chatHubConnection,
    String roomId,
  ) async {
    // Server responds with 'RoomStats' or 'RoomStatsError'
    await chatHubConnection.invoke('GetRoomStats', args: [roomId]);
  }

  Future<void> getGlobalStats(
    HubConnection chatHubConnection,
  ) async {
    // Server responds with 'GlobalStats' or 'GlobalStatsError'
    await chatHubConnection.invoke('GetGlobalStats');
  }

  // ============================== Public methods ends ==================== //

  // ====================================================================
  // 3. LIFECYCLE: DISPOSE METHOD (CRITICAL)
  // ====================================================================

  void dispose() {
    _newMessageController.close();
  }

  // REGULAR ENDPOINT below, signalr above

  Future<List<MessageModel>> getLocalMessages(String roomId) async {
    final messages = await db.getMessages(roomId);
    if (messages.isNotEmpty) {
      return messages;
    }
    return [];
  }

  Future<void> saveMessagesToDb(List<MessageModel> messages) async {
    await db.insertMessage(messages);
  }

  Future<void> saveSingleMessageToDb(MessageModel messages) async {
    await db.insertSingleMessage(messages);
  }

  Future<void> saveEditedMessageToDb(MessageModel messages) async {
    await db.updateMessage(messages);
  }

  Future<void> deleteMessageFromToDb(MessageModel messages) async {
    await db.deleteMessage(messages);
  }

  Future<String> createRoomGroup(CreateRoomGroup request) async {
    final result = await apiService.postJsonRequest(
        request.toJson(), 'v1/chat/rooms/group');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<RoomMain>> getChatRooms() async {
    final result = await apiService.getJsonRequest('v1/chat/rooms/my-rooms');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => RoomMain.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> createChatMessage(ChatMessageRequest requestModel) async {
    final result = await apiService.chatMultipartRequestCreate(
      'v1/chat/messages/send',
      requestModel,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }

    // response

//     {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "messageId": "bacb6ec8-0199-0000-0100-01001bcbf90e",
//     "success": true,
//     "mediaUrl": null,
//     "messageType": "Text"
//   }
// }
  }

  Future<String> editChatMessage(Map<String, dynamic> jsonData) async {
    final result = await apiService.updateJsonRequest(
      jsonData,
      'v1/chat/messages/{messageId}/edit',
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // /api/v1/chat/messages/{messageId}/edit

  Future<List<MessageModel>> getChatMessages({
    required String chatRoomId,
    Map<String, dynamic>? queryParams,
  }) async {
    final result =
        await apiService.getJsonRequest('v1/chat/messages/$chatRoomId');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }
}
