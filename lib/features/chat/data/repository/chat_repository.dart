import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:mevtech/core/error/failure_response.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/core/storages/DatabaseHandler.dart';
import 'package:mevtech/features/chat/data/chat-data/chat_data_cubit.dart';
import 'package:mevtech/features/chat/data/models/chat_message_model.dart';
import 'package:mevtech/features/chat/data/models/chat_user_model.dart';
import 'package:mevtech/features/chat/data/models/room_model.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/chat/data/signalr-model/user_status.dart';

@singleton
class ChatRepository {
  ChatRepository(this.apiService, this._chatDataCubit);

  final ApiService apiService;
  final ChatDataCubit _chatDataCubit;

  final db = DatabaseHandler();

  final _newMessageController = StreamController<MessageModel>.broadcast();
  final _editMessageController = StreamController<MessageEditModel>.broadcast();
  final _deleteMessageController =
      StreamController<MessageDeleteModel>.broadcast();

  Stream<MessageModel> get onNewMessage => _newMessageController.stream;
  Stream<MessageEditModel> get onEditMessage => _editMessageController.stream;
  Stream<MessageDeleteModel> get onDeleteMessage =>
      _deleteMessageController.stream;

  Future<void> deleteDbrecords(String tableName) async {
    await db.deleteDbRecords(tableName);
  }

  Future<void> handleMessageReceived(MessageModel message) async {
    // 1. CRITICAL: Save the message to the local DB immediately
    await saveSingleMessageToDb(message);

    // 2. Broadcast the message to all listening Cubits (i.e., the SingleChatCubits)
    _newMessageController.add(message);
  }

  Future<void> handleRoomReceived(List<RoomMain> rooms) async {
    // 1. CRITICAL: Save the Rooms to the local DB immediately
    await saveRoomsToDb(rooms);
    // 2. Broadcast the message to all listening Cubits (i.e., the ChatCubits)
    _chatDataCubit.getMyRooms(rooms);
  }

  Future<void> handleMessageEdited(MessageEditModel message) async {
    _editMessageController.add(message);
  }

  Future<void> handleMessageDeleted(MessageDeleteModel message) async {
    _deleteMessageController.add(message);
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
      //  -- ChatConnected ReceiveConnectionId
      ..on('ConnectionEstablished', (data) {
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
            final mapResult = item != null
                ? item as Map<String, dynamic>
                : <String, dynamic>{};
            final result =
                mapResult.isNotEmpty && mapResult.containsKey('rooms')
                ? mapResult['rooms'] as List<dynamic>
                : <dynamic>[];
            final myRooms = result
                .map((room) => RoomMain.fromJson(room! as Map<String, dynamic>))
                .toList();

            handleRoomReceived(myRooms);

            // pullMessagesFromRooms(myRooms);
          } catch (e) {
            log(e.toString());
          }
        }
      })
      ..on('PublicRooms', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      //  RoomUsers
      ..on('ROOM_USERS', (data) {
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
      })
      ..on('RoomUsersError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      }) // Sending room errors to general error stream
      // 3. Messaging
      //  ReceiveMessage
      ..on('RECEIVE_DIRECT_MESSAGE', (data) {
        final json = safeParse(data);
        if (json != null) {
          // _chatDataCubit.getMessages([MessageModel.fromJson(json)]);
          handleMessageReceived(MessageModel.fromJson(json));
        }
      })
      // RECEIVE_GENERAL_MESSAGE
      ..on('RECEIVE_GENERAL_MESSAGE', (data) {
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
          handleMessageEdited(MessageEditModel.fromJson(json));
        }
      })
      ..on('MESSAGE_DELETED', (data) {
        final json = safeParse(data);
        if (json != null) {
          handleMessageDeleted(MessageDeleteModel.fromJson(json));
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
      ..on('SearchResults', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('SearchError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      // 4. Unread Messages & Read Receipts
      ..on('UnreadMessages', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('UnreadMessagesError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      //  UnreadCount
      ..on('UNREAD_COUNT_UPDATED', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('UnreadCountError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('AllUnreadCounts', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('AllUnreadCountsError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      //  ReadStatusUpdated
      ..on(
        'USER_ROOM_READ_UPDATED', //here
        (data) {
          // do it now
          log('Event triggered ${data?.length ?? -1}');
          getMyRooms(chatHubConnection); // undo this
        },
      )
      ..on('MarkAsReadError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      // 5. Statistics
      //  RoomStats
      ..on('ROOM_STATS', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('RoomStatsError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('GlobalStats', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('GlobalStatsError', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      // 6. Error Handling
      //  GeneralError
      ..on('ERROR', (data) {
        log('Event triggered ${data?.length ?? -1}');
      })
      ..on('ReceiveConnectionId', (data) {});
  }

  // Public method to send a message
  Future<void> sendMessage(HubConnection chatHubConnection, String text) async {
    try {
      await chatHubConnection.invoke('SendMessage', args: [text]);
    } catch (e) {
      log(e.toString());
    }
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
    await chatHubConnection.invoke(
      'JoinRoom',
      args: [roomId, roomName, password],
    );
  }

  Future<void> leaveRoom(HubConnection chatHubConnection, String roomId) async {
    await chatHubConnection.invoke('LeaveRoom', args: [roomId]);
  }

  Future<void> getMyRooms(HubConnection chatHubConnection) async {
    // Server will respond with the 'MyRooms' event
    try {
      if (chatHubConnection.state == HubConnectionState.Connected) {
        await chatHubConnection.invoke('GetMyRooms');
      } else {
        return;
      }
    } catch (e, st) {
      log('$e\n$st');
      // throw Exception(e);
      // rethrow;
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
    await chatHubConnection.invoke(
      'SearchMessages',
      args: [roomId, searchTerm, count],
    );
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
    final res = await chatHubConnection.invoke(
      'GetUnreadCount',
      args: [roomId],
    );
  }

  Future<void> getAllUnreadCounts(HubConnection chatHubConnection) async {
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
      await chatHubConnection.invoke(
        'MarkRoomAsRead',
        args: [roomId],
      ); //  MarkAsRead
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

  Future<void> getGlobalStats(HubConnection chatHubConnection) async {
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

  Future<List<RoomMain>> getLocalRooms() async {
    final rooms = await db.getRooms();
    if (rooms.isNotEmpty) {
      return rooms;
    }
    return [];
  }

  Future<List<MessageModel>> getPaginatedLocalMessages({
    required String roomId,
    required String previousTimestamp,
    required int limit,
  }) async {
    final messages = await db.getPaginatedDBMessages(
      roomId: roomId,
      previousTimestamp: previousTimestamp,
      limit: limit,
    );
    if (messages.isNotEmpty) {
      return messages;
    }
    return [];
  }

  Future<List<RoomMain>> getPaginatedLocalRooms({
    required String previousTimestamp,
    required int limit,
  }) async {
    final rooms = await db.getPaginatedDBRooms(
      previousCreatedAt: previousTimestamp,
      limit: limit,
    );
    if (rooms.isNotEmpty) {
      return rooms;
    }
    return [];
  }

  Future<void> saveMessagesToDb(List<MessageModel> messages) async {
    await db.insertMessages(messages);
  }

  Future<void> saveRoomsToDb(List<RoomMain> rooms) async {
    await db.insertRooms(rooms);
  }

  Future<void> saveSingleMessageToDb(MessageModel messages) async {
    await db.insertSingleMessage(messages);
  }

  Future<void> saveSingleRoomsToDb(RoomMain room) async {
    await db.insertSingleRoom(room);
  }

  Future<void> saveEditedMessageToDb(MessageModel messages) async {
    await db.updateMessage(messages);
  }

  Future<void> softDeleteMessageInDb(MessageModel message) async {
    await db.softDeleteMessage(message);
  }

  Future<void> deleteRoomFromToDb(RoomMain room) async {
    await db.deleteRoom(room);
  }

  Future<String> createRoomPrivate(String targetUserId) async {
    final jsonData = <String, dynamic>{'targetUserId': targetUserId};
    final result = await apiService.postJsonRequest(
      jsonData,
      'v1/chat/rooms/private',
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

  Future<String> createRoomGroup(CreateRoomGroup request) async {
    final result = await apiService.postJsonRequest(
      request.toJson(),
      'v1/chat/rooms/group',
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

  Future<String> createRoomCommunity(String communityName) async {
    final jsonData = <String, dynamic>{'communityName': communityName};
    final result = await apiService.postJsonRequest(
      jsonData,
      'v1/chat/rooms/community',
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

  // /api/v1/chat/users/search

  Future<List<ChatUser>> getChatusers(String query) async {
    final queryParams = <String, dynamic>{
      'query': query,
      'skip': '0',
      'limit': '10',
    };
    final result = await apiService.getJsonRequest(
      'v1/chat/users/search',
      queryParams: queryParams,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final users = data['users'] as List<dynamic>;
        return users
            .map((user) => ChatUser.fromJson(user as Map<String, dynamic>))
            .toList();
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
        final data = result['data'] as Map<String, dynamic>;
        final roomData = data['rooms'] as List<dynamic>;
        // final rooms = result['data'] as List<dynamic>;

        return roomData
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

  Future<String> editChatMessage(
    String messageId,
    Map<String, dynamic> jsonData,
  ) async {
    final result = await apiService.updateJsonRequest(
      jsonData,
      'v1/chat/messages/$messageId/edit',
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

  Future<String> deleteChatMessage(String messageId, String roomId) async {
    final result = await apiService.deleteJsonRequest(
      'v1/chat/messages/$messageId',
      queryParams: {'roomId': roomId},
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
    final result = await apiService.getJsonRequest(
      'v1/chat/messages/$chatRoomId',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final messagesData = data['messages'] as List<dynamic>;

        return messagesData
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
