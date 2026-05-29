import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/core/network/signalr_cubit.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/core/utils/multiple_status_states.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/chat/chat-constant/chat_color_scheme.dart';
import 'package:mevtech/features/chat/data/chat-data/chat_data_cubit.dart';
import 'package:mevtech/features/chat/data/models/bottom_sheet_model.dart';
import 'package:mevtech/features/chat/data/models/chat_message_model.dart';
import 'package:mevtech/features/chat/data/models/chat_user_model.dart';
import 'package:mevtech/features/chat/data/models/room_model.dart';
import 'package:mevtech/features/chat/data/models/status_state.dart';
import 'package:mevtech/features/chat/data/repository/chat_repository.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/chat/data/signalr-model/user_status.dart';
import 'package:mevtech/features/chat/mock/mock_models.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/data/repository/user_repository.dart';
import 'package:signalr_netcore/hub_connection.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this._chatRepository,
    this._signalRCubit,
    this._dataCubit,
    this._userRepository,
  ) : super(
        ChatState(
          roomMain: _dataCubit.state.roomsMain,
          // messages: _dataCubit.state.messages,
          selectedChatRoomId: _dataCubit.state.selectedChatRoom?.id,
          userStatus: _dataCubit.state.userStatus,
          currentTypistUsernames: _getInitialTypingUsernames(
            _dataCubit.state.selectedChatRoom?.id,
            _dataCubit.state,
          ),
        ),
      ) {
    _initRootConnectionListener();
    _setChatDataListener();

    // final room = _dataCubit.state.roomsMain.firstWhereOrNull(
    //   (r) => r.id == state.selectedChatRoomId,
    // );
    // final unreadCount = room?.settings.unreadRoomMessagesCount ?? 0;

    _setChatMessageListener();
    _setChatEditMessageListener();
    _setChatDeleteMessageListener();

    // loadInitialMessages(room?.id ?? '', unreadCount);
  }

  final ChatRepository _chatRepository;
  final SignalRCubit _signalRCubit;
  final ChatDataCubit _dataCubit;
  final UserRepository _userRepository;

  late final StreamSubscription<SignalRState> _rootConnectionSubscription;
  late final StreamSubscription<MessageModel> _messageSubscription;
  late final StreamSubscription<MessageEditModel> _messageEditSub;
  late final StreamSubscription<MessageDeleteModel> _messageDeleteSub;
  Timer? _typingTimer;
  Timer? _roomsTimeout;
  bool _isTyping = false;
  final delay = const Duration(milliseconds: 2000);
  bool isLoading = false;
  String? error;

  HubConnectionState? get chatStatus => _signalRCubit.chatHubConnection?.state;

  // List<MessageModel> messages = [];

  bool isLoadingOlder = false;
  bool hasMore = true;

  String? oldestTimestamp;
  String? currentRoomId;

  Future<void> deleteDb(String tableName) async {
    try {
      await _chatRepository.deleteDbrecords(tableName);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadPaginatedLocalMessages() async {
    final roomId = state.selectedChatRoomId;
    if (roomId == null) return;
    if (isLoadingOlder || !hasMore || oldestTimestamp == null) return;

    try {
      isLoadingOlder = true;
      emit(
        state.copyWith(
          messageStatus: const Status.loading(CrudAction.paginate),
        ),
      );

      final olderMessages = await _chatRepository.getPaginatedLocalMessages(
        roomId: roomId,
        previousTimestamp: oldestTimestamp ?? '',
        limit: 50,
      );

      if (olderMessages.isNotEmpty) {
        oldestTimestamp = olderMessages.last.timestamp;
        emit(
          state.copyWith(
            messageStatus: const Status.success(CrudAction.paginate),
            messages: [...state.messages, ...olderMessages],
          ),
        );
      }

      if (olderMessages.length < 50) {
        hasMore = false;
      }

      isLoadingOlder = false;
      emit(
        state.copyWith(
          messageStatus: const Status.success(CrudAction.paginate),
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          messageStatus: Status.failure(
            action: CrudAction.paginate,
            error: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> selectChatRooms(
    String chatRoomId, {
    String? currentUserId,
  }) async {
    final room = state.roomMain.firstWhereOrNull((r) => r.id == chatRoomId);
    if (room == null || chatRoomId == state.selectedChatRoomId) return;
    final previousSelectedRoomId = state.selectedChatRoomId;
    onTextChanged('', previousSelectedRoomId ?? '');
    final unreadCount = room.settings.unreadRoomMessagesCount;

    emit(state.copyWith(selectedChatRoomId: chatRoomId));

    // RESET STATE
    isLoadingOlder = false;
    hasMore = true;
    oldestTimestamp = null;

    await loadInitialMessages(
      room.id,
      unreadCount,
      currentUserId: currentUserId,
    );
  }

  Future<void> refetchMessage(
    String? chatRoomId, {
    String? currentUserId,
  }) async {
    final room = state.roomMain.firstWhereOrNull((r) => r.id == chatRoomId);
    if (chatRoomId == null || room == null) return;
    final unreadCount = room.settings.unreadRoomMessagesCount;

    await loadInitialMessages(
      room.id,
      unreadCount,
      currentUserId: currentUserId,
    );
  }

  Future<void> loadInitialMessages(
    String roomId,
    int unreadCount, {
    String? currentUserId,
  }) async {
    // if(roomId.isEmpty)return;
    try {
      // 1. LOAD FROM LOCAL DATABASE FIRST
      // final localMessages = await _chatRepository.getLocalMessages(roomId);

      final currentTimestamp = DateTime.now().toUtc().toIso8601String();

      final localMessages = await _chatRepository.getPaginatedLocalMessages(
        roomId: roomId,
        previousTimestamp: currentTimestamp,
        limit: 50,
      );

      if (localMessages.isNotEmpty) {
        oldestTimestamp = localMessages.last.timestamp;
      }

      if (localMessages.length < 50) {
        hasMore = false;
      }

      emit(
        state.copyWith(
          messages: localMessages,
          messageStatus: const Status.loading(CrudAction.fetch),
          currentTypistUsernames: _getChangedroomTypingUsernames(
            roomId,
            _dataCubit.state,
          ),
        ),
      );

      var serverMessages = <MessageModel>[];

      // 2. CONDITIONAL FETCH FROM SERVER
      if (unreadCount > 0 || localMessages.isEmpty) {
        // Fetch if there are unread messages OR if the local DB is empty
        serverMessages = await _chatRepository.getChatMessages(
          chatRoomId: roomId,
        );
      }

      // await Future.delayed(Duration(seconds: 3), () {});

      // 3. MERGE, SAVE, AND EMIT
      if (serverMessages.isNotEmpty) {
        // Logic to merge local and server messages (handle duplicates by messageId)
        // The simplest way: use a Map to handle duplicates, keeping the latest version.
        final combinedMap = <String, MessageModel>{
          for (final msg in localMessages) msg.id: msg,
          for (final msg in serverMessages)
            msg.id: msg, // Server data overwrites local if ID matches
        };

        final finalMessages = combinedMap.values.toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by time

        // Save the new/updated messages to the database
        await _chatRepository.saveMessagesToDb(serverMessages);

        emit(
          state.copyWith(
            messages: finalMessages,
            messageStatus: const Status.success(CrudAction.fetch),
            // Reset unread count in your UI/state here
          ),
        );

        unawaited(
          reportLatestReadMessage(
            roomId: roomId,
            currentUserId: currentUserId ?? '',
            messages: finalMessages,
          ),
        );
      } else {
        // If no server fetch occurred or no new messages, just display local
        emit(
          state.copyWith(
            messages: localMessages,
            messageStatus: const Status.initial(CrudAction.fetch),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          messageStatus: Status.failure(
            action: CrudAction.fetch,
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void toggleRoomType({required bool isPersonalRoom}) {
    emit(state.copyWith(isPersonalRoom: isPersonalRoom));
  }

  void _initRootConnectionListener() {
    _rootConnectionSubscription = _signalRCubit.stream.listen((rootState) {
      // Check for the most critical status change: Disconnected
      if (rootState.overallStatus == ConnectionStatus.disconnected) {
        // 1. Update own state to reflect the failure
        if (!isClosed) {
          emit(
            state.copyWith(
              connectionStatus:
                  ChatConnectionStatus.connecting, // Transition state
              connectionError: 'Connection lost. Attempting reconnect...',
            ),
          );
        }

        // 2. Trigger the root cubit to re-establish connections for all hubs
        // The root cubit should expose a simple method to retry connection
        _signalRCubit.connect(
          userId: MevTechUtilities.id, // Pass necessary parameters
          token: MevTechUtilities.authKey,
        );
      }
    });
  }

  void _setChatMessageListener() {
    _messageSubscription = _chatRepository.onNewMessage.listen((newMessage) {
      if (newMessage.roomId == state.selectedChatRoomId) {
        // Filtering by the current room

        final currentMessages = List<MessageModel>.from(state.messages);

        final messageIndex = currentMessages.indexWhere(
          (m) =>
              m.content == newMessage.content &&
              m.userId == newMessage.userId &&
              m.isSending == true,
        );

        if (messageIndex != -1) {
          currentMessages[messageIndex] = newMessage;
          emit(state.copyWith(messages: currentMessages));
        } else {
          // currentMessages.add(newMessage);
          emit(state.copyWith(messages: [newMessage, ...currentMessages]));
        }

        // final updatedMessages = [...state.messages, newMessage];
        // emit(state.copyWith(messages: updatedMessages));
      }
    });
  }

  // _messageEditSub

  Future<void> _setChatEditMessageListener() async {
    _messageEditSub = _chatRepository.onEditMessage.listen((
      newEditedMessage,
    ) async {
      if (newEditedMessage.roomId == state.selectedChatRoomId) {
        // Filtering by the current room

        final currentMessages = List<MessageModel>.from(state.messages);

        final index = currentMessages.indexWhere(
          (m) => m.id == newEditedMessage.messageId,
        );
        if (index != -1) {
          final updated = state.messages[index].copyWith(
            content: newEditedMessage.newContent,
            editedAt: normalizeApiTimestamp(newEditedMessage.editedAt),
            updatedAt: normalizeApiTimestamp(newEditedMessage.editedAt),
            updatedBy: newEditedMessage.editedBy,
            isEdited: newEditedMessage.isEdited,
            isSending: false,
          );

          await _chatRepository.saveEditedMessageToDb(updated);

          final updatedMessages = List<MessageModel>.from(state.messages);
          updatedMessages[index] = updated;
          emit(state.copyWith(messages: updatedMessages));
        }
      }
    });
  }

  // _messageDeleteSub

  Future<void> _setChatDeleteMessageListener() async {
    _messageDeleteSub = _chatRepository.onDeleteMessage.listen((
      newDeletedMessage,
    ) async {
      if (newDeletedMessage.roomId == state.selectedChatRoomId) {
        // Filtering by the current room

        final currentMessages = List<MessageModel>.from(state.messages);

        final index = currentMessages.indexWhere(
          (m) => m.id == newDeletedMessage.messageId,
        );
        if (index != -1) {
          final updatedDeleted = state.messages[index].copyWith(
            deletedBy: newDeletedMessage.deletedBy,
            deletedAt: normalizeApiTimestamp(newDeletedMessage.deletedAt),
            isDeleted: newDeletedMessage.isDeleted,
            // isSending: false,
          );

          await _chatRepository.softDeleteMessageInDb(updatedDeleted);

          final updatedMessages = List<MessageModel>.from(state.messages);
          if (updatedMessages.isEmpty) return;
          updatedMessages[index] = updatedDeleted;

          final finalUpdatedMessages = updatedMessages
              .where((m) => !m.isDeleted)
              .toList();

          emit(state.copyWith(messages: finalUpdatedMessages));
        }
      }
    });
  }

  void _setChatDataListener() {
    _dataCubit.stream.listen((dataState) {
      final roomId = state.selectedChatRoomId;

      final typingUserIds = dataState.typingUsersByRoom[roomId] ?? {};
      if (typingUserIds.contains(MevTechUtilities.id)) {
        typingUserIds.removeWhere((id) => id == MevTechUtilities.id);
      }

      final userIdToUsernameMap = dataState.userIdToUsernameMap;

      final rawTypingUsernames = typingUserIds.map((userId) {
        // Look up the name using the ID; fall back if not found
        return userIdToUsernameMap[userId] ?? '';
      }).toList();

      final typingUsernamesList = rawTypingUsernames
          .where((name) => name.isNotEmpty)
          .toList();

      if (!isClosed) {
        if (dataState.roomsMain.isNotEmpty) {
          _roomsTimeout?.cancel(); // cancel timeout if data arrives

          final finalRooms = dataState.roomsMain;
          // ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          emit(
            state.copyWith(
              roomMain: finalRooms,
              userStatus: dataState.userStatus,
              currentTypistUsernames: typingUsernamesList,
              chatRoomStatus: const Status.success(CrudAction.fetch),
            ),
          );
        } else if (state.roomMain.isEmpty && !state.chatRoomStatus.isLoading) {
          emit(
            state.copyWith(
              chatRoomStatus: const Status.loading(CrudAction.fetch),
            ),
          );
          _startRoomsTimeout();
        }

        // emit(
        //   state.copyWith(
        //     roomMain: dataState.roomsMain,
        //     // messages: dataState.messages,
        //     userStatus: dataState.userStatus,
        //     currentTypistUsernames: typingUsernamesList,
        //   ),
        // );
      }
    });
  }

  static List<String> _getChangedroomTypingUsernames(
    String? channelId,
    ChatDataState chatDataState,
  ) {
    if (channelId == null) return [];
    final typingUserIds = chatDataState.typingUsersByRoom[channelId] ?? {};
    final userIdToUsernameMap = chatDataState.userIdToUsernameMap;
    final typingUsernamesList = typingUserIds
        .map((userId) {
          // Map IDs to names, falling back to '' if not found
          return userIdToUsernameMap[userId] ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList(); // Filter out empty strings
    return typingUsernamesList;
  }

  Future<void> sendMessage(
    String? chatRoomId,
    String content, {
    UserModel? user,
  }) async {
    final myRooms = state.roomMain;
    if (myRooms.isEmpty || content.isEmpty) return;

    if (chatRoomId != null) {
      final tempMessage = MessageModel.createSending(
        id: generateTemporaryId(),
        content: content,
        userId: user?.id ?? '',
        username: user?.username ?? '',
        roomId: chatRoomId,
      );

      // 1. OPTIMISTIC UI: Append the message immediately
      final updatedMessages = [tempMessage, ...state.messages];
      emit(state.copyWith(messages: updatedMessages));

      try {
        final newMessage = ChatMessageRequest(
          roomId: chatRoomId,
          content: content,
          replyToId: '',
        );

        await _chatRepository.createChatMessage(newMessage);
      } catch (e) {
        _updateMessageState(
          tempMessage.id, // Use the unique ID to target the message
          isSending: false, // Turn off the sending indicator
          isFailed: true, // Turn on the failure indicator
        );
      }
    }
  }

  Future<void> resendMessage(String? chatRoomId, MessageModel? message) async {
    final myRooms = state.roomMain;
    if (myRooms.isEmpty || message == null) return;

    if (chatRoomId != null) {
      // 1. change the state of the message immedialy to loading on resend

      _updateMessageState(
        message.id, // Use the unique ID to target the message
        isSending: true, // Turn on the sending indicator
        isFailed: false, // Turn off the failure indicator
      );

      try {
        final newMessage = ChatMessageRequest(
          roomId: chatRoomId,
          content: message.content,
          replyToId: '',
        );

        await _chatRepository.createChatMessage(newMessage);
      } catch (e) {
        _updateMessageState(
          message.id, // Use the unique ID to target the message
          isSending: false, // Turn off the sending indicator
          isFailed: true, // Turn on the failure indicator
        );
      }
    }
  }

  Future<void> editMessage({
    required String messageId,
    required String? roomId,
    required String newContent,
  }) async {
    if (roomId == null) return;
    final currentMessages = List<MessageModel>.from(state.messages);
    final messageIndex = currentMessages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      final originalMessage = currentMessages[messageIndex];
      // 1. OPTIMISTIC UI: Immediately update the message content in the local list
      _updateMessageStateForEdit(messageId, newContent);

      try {
        final jsonData = <String, dynamic>{
          'roomId': roomId,
          'newContent': newContent,
        };
        // 2. Call the repository to communicate with the server
        await _chatRepository.editChatMessage(messageId, jsonData);
        // Success will be handled by the MESSAGE_EDITED event (F)
      } catch (e) {
        // 3. ROLLBACK: If API fails, revert the UI change
        currentMessages[messageIndex] = originalMessage;
        emit(state.copyWith(messages: currentMessages));
      }
    }
  }

  Future<void> deleteMessage({
    required String messageId,
    required String roomId,
  }) async {
    final currentMessages = List<MessageModel>.from(state.messages);
    final messageIndex = currentMessages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      final originalMessage = currentMessages[messageIndex];
      // 1. OPTIMISTIC UI: Immediately update the message content in the local list

      currentMessages.removeAt(messageIndex);

      emit(state.copyWith(messages: currentMessages));

      try {
        // 2. Call the repository to communicate with the server
        await _chatRepository.deleteChatMessage(messageId, roomId);
        // Success will be handled by the MESSAGE_EDITED event (F)
      } catch (e) {
        // 3. ROLLBACK: If API fails, revert the UI change
        currentMessages[messageIndex] = originalMessage;
        emit(state.copyWith(messages: currentMessages));
      }
    }
  }

  void _updateMessageStateForEdit(String messageId, String newContent) {
    final currentMessages = List<MessageModel>.from(state.messages);
    final messageIndex = currentMessages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      final originalMessage = currentMessages[messageIndex];
      // Create a new instance with updated fields
      currentMessages[messageIndex] = originalMessage.copyWith(
        content: newContent,
        isEdited: true,
        editedAt: DateTime.now().toUtc().toIso8601String(),
        isSending: true,
        isFailed: false,
      );
      emit(state.copyWith(messages: currentMessages));
    }
  }

  Future<void> reportLatestReadMessage({
    required String roomId,
    required List<MessageModel> messages,
    String currentUserId = '',
  }) async {
    if (messages.isEmpty && currentUserId.isEmpty) return;

    String? latestReadMessageId;

    // Iterate backwards from the newest message
    for (var i = messages.length - 1; i >= 0; i--) {
      final message = messages[i];

      // Find the ID of the latest message that was NOT sent by the current user.
      if (message.userId != currentUserId) {
        latestReadMessageId = message.id;
        break;
      }
    }
    if (latestReadMessageId != null) {
      await markMessagesAsRead(roomId, latestReadMessageId);
    }
  }

  void _updateMessageState(
    String messageId, {
    bool? isSending,
    bool? isFailed,
  }) {
    final currentMessages = List<MessageModel>.from(state.messages);

    // Find the index of the message (identified by its temporary ID)
    final messageIndex = currentMessages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      // 1. Create a copy of the message with the new status
      final updatedMessage = currentMessages[messageIndex].copyWith(
        isSending: isSending, // e.g., turn OFF sending flag
        isFailed: isFailed, // e.g., turn ON failed flag
      );

      // 2. Replace the message in the list
      currentMessages[messageIndex] = updatedMessage;

      // 3. Emit the new state
      emit(state.copyWith(messages: currentMessages));
    }
  }

  static List<String> _getInitialTypingUsernames(
    String? channelId,
    ChatDataState chatDataState,
  ) {
    if (channelId == null) return [];
    final typingUserIds = chatDataState.typingUsersByRoom[channelId] ?? {};
    final userIdToUsernameMap = chatDataState.userIdToUsernameMap;

    final typingUsernamesList = typingUserIds
        .map((userId) {
          // Map IDs to names, falling back to '' if not found
          return userIdToUsernameMap[userId] ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList(); // Filter out empty strings

    return typingUsernamesList;
  }

  void onTextChanged(String text, String roomId) {
    // If text is empty -> immediately send false and cancel debounce
    if (roomId.isEmpty) return;

    if (text.trim().isEmpty) {
      _typingTimer?.cancel();
      _typingTimer = null;
      if (_isTyping) {
        _isTyping = false;
        setTypingStatus(roomId, isTyping: false);
      }
      return;
    }

    // If user typed something non-empty and we haven't signaled typing yet -> send true
    if (!_isTyping) {
      _isTyping = true;

      setTypingStatus(roomId, isTyping: true);
    }

    // Reset debounce to send false after delay of inactivity
    _typingTimer?.cancel();
    _typingTimer = Timer(delay, () {
      if (text.isNotEmpty && _isTyping) {
        // _isTyping = false;
        // setTypingStatus(roomId, isTyping: false);
      }
      _typingTimer = null;
    });
  }

  // set user typing test

  String usertypingText(Set<String> typingIds) {
    // 1. Get the list of IDs from the state

    if (typingIds.isNotEmpty) {
      // 2. Look up the Usernames (Assuming you have a function to get username by ID)
      final usernames =
          // ignore: unnecessary_lambdas
          typingIds.take(3).map((id) => getUserNameById(id)).toList();

      var typingText = '';
      if (usernames.length == 1) {
        typingText = '${usernames.first} is typing...';
      } else if (usernames.length == 2) {
        typingText = '${usernames[0]} and ${usernames[1]} are typing...';
      } else {
        // 3 or more users
        final othersCount = typingIds.length - 2;
        typingText =
            '${usernames[0]}, ${usernames[1]}, and $othersCount others are typing...';
      }

      // Display typingText in your UI
      return typingText;
    } else {
      // Hide the indicator
      return '';
    }
  }

  String getUserNameById(String id) {
    return '';
  }

  // ==========

  // ======================== public methods =====================================

  // ====================================================================
  // 1. Connection & Status
  // ====================================================================

  Future<void> updateUserStatus(UserOnlineStatus status) async {
    try {
      final chatHub = _signalRCubit.chatHubConnection;

      if (chatHub != null) {
        await _chatRepository.updateStatus(chatHub, status);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
    } catch (e) {
      emit(state.copyWith(connectionError: 'Failed to update status: $e'));
    }
  }

  // ====================================================================
  // 2. Room Management
  // ====================================================================

  Future<void> joinRoom(
    String roomId, {
    String roomName = '',
    String password = '',
  }) async {
    // Optional: Set a loading state before the request
    // emit(state.copyWith(status: ChatStatus.joiningRoom));
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        await _chatRepository.joinRoom(
          chatHubConnection: chatHub,
          roomId: roomId,
          roomName: roomName,
          password: password,
        );
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }

      // The 'JoinedRoom' event will confirm success and clear the loading state.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to join room: $e', status: ChatStatus.idle));
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        await _chatRepository.leaveRoom(chatHub, roomId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }

      // The 'LeftRoom' event will confirm success.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to leave room: $e'));
    }
  }

  void _startRoomsTimeout() {
    _roomsTimeout?.cancel();
    _roomsTimeout = Timer(const Duration(seconds: 15), () {
      // No response received from server

      if (!isClosed) {
        emit(
          state.copyWith(
            chatRoomStatus: const Status.failure(
              action: CrudAction.fetch,
              error:
                  'Connection Timeout!\ncheck your network connection and try again.',
            ),
          ),
        );
      }
    });
  }

  Future<void> requestMyRooms() async {
    try {
      if (!isClosed) {
        emit(
          state.copyWith(
            chatRoomStatus: const Status.loading(CrudAction.fetch),
          ),
        );
      }

      _startRoomsTimeout();

      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null && chatHub.state == HubConnectionState.Connected) {
        // _chatRepository.getMyRooms(chatHub);
        await chatHub.invoke('GetMyRooms');
        // log(chatHub.state?.name ?? 'it is null');
      } else {
        if (!isClosed) {
          emit(
            state.copyWith(
              connectionError: 'Chat connection is not active.',
              chatRoomStatus: const Status.failure(
                action: CrudAction.fetch,
                error:
                    'Failed to fetch chat rooms\nChat connection is not active',
              ),
            ),
          );
        }
      }
      // The 'MyRooms' event will populate the state.
    } catch (e) {
      _roomsTimeout?.cancel();
      if (!isClosed) {
        emit(
          state.copyWith(
            chatRoomStatus: Status.failure(
              action: CrudAction.fetch,
              error: 'Failed to fetch chat rooms: $e',
            ),
          ),
        );
      }
    }
  }

  void requestRoomUsers(String roomId) {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getRoomUsers(chatHub, roomId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
      // The 'RoomUsers' or 'RoomUsersError' events will update the state.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to request room users: $e'));
    }
  }

  // ====================================================================
  // 3. Messaging
  // ====================================================================

  Future<void> loadRoomMessages({
    required String roomId,
    String? fromMessageId,
    int count = 50,
  }) async {
    //  emit(state.copyWith(status: ChatStatus.loadingMessages));
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        await _chatRepository.getRoomMessages(
          chatHubConnection: chatHub,
          roomId: roomId,
          fromMessageId: fromMessageId,
          count: count,
        );
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
      // The 'ReceiveMessage' event stream (from the initial load) will update the state.
    } catch (e) {
      //    emit(state.copyWith(error: 'Failed to load messages: $e', status: ChatStatus.idle));
    }
  }

  Future<void> searchMessages(String roomId, String searchTerm) async {
    //  emit(state.copyWith(status: ChatStatus.searching));
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        await _chatRepository.searchMessages(
          chatHubConnection: chatHub,
          roomId: roomId,
          searchTerm: searchTerm,
          count: 20,
        );
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
      // The 'SearchResults' or 'SearchError' events will update the state.
    } catch (e) {
      //  emit(state.copyWith(error: 'Failed to search messages: $e', status: ChatStatus.idle));
    }
  }

  void setTypingStatus(String roomId, {required bool isTyping}) {
    // This is a fire-and-forget event. We don't typically await it.
    final chatHub = _signalRCubit.chatHubConnection;
    final status = _signalRCubit.chatHubStatus;
    if (chatHub != null && status == true) {
      _chatRepository.setTyping(
        chatHubConnection: chatHub,
        roomId: roomId,
        isTyping: isTyping,
      );
    } else {
      emit(state.copyWith(connectionError: 'Chat connection is not active.'));
    }
  }

  // ====================================================================
  // 4. Unread Messages & Read Receipts
  // ====================================================================

  void requestUnreadMessages(String roomId) {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getUnreadMessages(chatHub, roomId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
    } catch (e) {
      //    emit(state.copyWith(error: 'Failed to request unread messages: $e'));
    }
  }

  void requestUnreadCount(String roomId) {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getUnreadCount(chatHub, roomId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
    } catch (e) {
      //    emit(state.copyWith(error: 'Failed to request unread count: $e'));
    }
  }

  void requestAllUnreadCounts() {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getAllUnreadCounts(chatHub);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
    } catch (e) {
      //  emit(state.copyWith(error: 'Failed to request all unread counts: $e'));
    }
  }

  Future<void> markMessagesAsRead(String roomId, String lastMessageId) async {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        await _chatRepository.markAsRead(chatHub, roomId, lastMessageId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }

      // The 'ReadStatusUpdated' event will confirm success.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to mark as read: $e'));
    }
  }

  // ====================================================================
  // 5. Statistics
  // ====================================================================

  void requestRoomStats(String roomId) {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getRoomStats(chatHub, roomId);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
      // The 'RoomStats' or 'RoomStatsError' events will update the state.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to request room stats: $e'));
    }
  }

  void requestGlobalStats() {
    try {
      final chatHub = _signalRCubit.chatHubConnection;
      if (chatHub != null) {
        _chatRepository.getGlobalStats(chatHub);
      } else {
        emit(state.copyWith(connectionError: 'Chat connection is not active.'));
      }
      // The 'GlobalStats' or 'GlobalStatsError' events will update the state.
    } catch (e) {
      // emit(state.copyWith(error: 'Failed to request global stats: $e'));
    }
  }

  // ======================== public methods ends ================================

  final ValueNotifier<BottomSheetState<ChatUser>> bottomSheetNotifier =
      ValueNotifier(BottomSheetState());

  final ValueNotifier<StatusState> statusState = ValueNotifier(StatusState());

  void resetActionStatus() {
    emit(
      state.copyWith(actionMessage: '', actionStatus: const Status.initial()),
    );
  }

  // Future<void> createRoom({
  //   required String groupName,
  //   required bool isPrivate,
  //   String? roomPass,
  // }) async {
  //   try {
  //     final jsonData = CreateRoomGroup(
  //       groupName: groupName,
  //       password: roomPass != null && roomPass.isEmpty ? null : roomPass,
  //       isPrivate: isPrivate,
  //     );
  //     emit(state.copyWith(
  //         actionStatus: const Status.loading(CrudAction.create)));
  //     final result = await _chatRepository.createRoomGroup(jsonData);
  //     emit(state.copyWith(
  //         actionMessage: result,
  //         actionStatus: const Status.success(CrudAction.create)));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         actionStatus:
  //             Status.failure(action: CrudAction.create, error: e.toString())));
  //   }
  // }

  Future<void> createRoom({
    required String groupName,
    required bool isPrivate,
    String? roomPass,
  }) async {
    statusState.value = StatusState();
    try {
      final jsonData = CreateRoomGroup(
        groupName: groupName,
        password: roomPass != null && roomPass.isEmpty ? null : roomPass,
        isPrivate: isPrivate,
      );

      statusState.value = statusState.value.copyWith(isLoading: true);

      final result = await _chatRepository.createRoomGroup(jsonData);

      statusState.value = statusState.value.copyWith(
        isLoading: false,
        success: result,
      );
      // await requestMyRooms();
      await fetchChatRooms();
    } catch (e) {
      statusState.value = statusState.value.copyWith(error: e.toString());
    } finally {
      statusState.value = statusState.value.copyWith(isLoading: false);
    }
  }

  Future<void> createPrivateChat(String targetUserId) async {
    statusState.value = StatusState();
    try {
      statusState.value = statusState.value.copyWith(isLoading: true);

      final result = await _chatRepository.createRoomPrivate(targetUserId);

      statusState.value = statusState.value.copyWith(
        isLoading: false,
        success: result,
      );
      // await requestMyRooms();
      await fetchChatRooms();
    } catch (e) {
      statusState.value = statusState.value.copyWith(error: e.toString());
    } finally {
      statusState.value = statusState.value.copyWith(isLoading: false);
    }
  }

  Future<void> createRoomCommunity(String communityName) async {
    statusState.value = StatusState();
    try {
      statusState.value = statusState.value.copyWith(isLoading: true);

      final result = await _chatRepository.createRoomCommunity(communityName);

      statusState.value = statusState.value.copyWith(
        isLoading: false,
        success: result,
      );
      // await requestMyRooms();
      await fetchChatRooms();
    } catch (e) {
      statusState.value = statusState.value.copyWith(error: e.toString());
    } finally {
      statusState.value = statusState.value.copyWith(isLoading: false);
    }
  }

  Future<void> fetchChatUser(String query) async {
    bottomSheetNotifier.value = BottomSheetState();
    if (query.isEmpty) return;

    try {
      bottomSheetNotifier.value = bottomSheetNotifier.value.copyWith(
        isLoading: true,
      );

      final result = await _chatRepository.getChatusers(query);

      if (result.isNotEmpty) {
        bottomSheetNotifier.value = bottomSheetNotifier.value.copyWith(
          isLoading: false,
          chatUsers: result,
        );
      } else {
        bottomSheetNotifier.value = bottomSheetNotifier.value.copyWith(
          isLoading: false,
          error: ' No users found matching $query',
        );
      }
    } catch (e) {
      bottomSheetNotifier.value = bottomSheetNotifier.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    } finally {
      // isLoading = false;
      // emit(state.copyWith());
      bottomSheetNotifier.value = bottomSheetNotifier.value.copyWith(
        isLoading: false,
      );
    }
  }

  void resetToDefault() {
    isLoading = false;
    error = null;
  }

  Future<void> fetchChatRooms() async {
    try {
      final localRooms = await _chatRepository.getLocalRooms();

      emit(
        state.copyWith(
          chatRoomStatus: const Status.loading(CrudAction.fetch),
          roomMain: localRooms,
        ),
      );

      final rooms = await _chatRepository.getChatRooms();

      if (rooms.isNotEmpty) {
        final combinedMap = <String, RoomMain>{
          for (final room in localRooms) room.id: room,
          for (final room in rooms)
            room.id: room, // Server data overwrites local if ID matches
        };

        final finalRooms = combinedMap.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by time

        // Save the new/updated messages to the database

        await _chatRepository.saveRoomsToDb(rooms);

        emit(
          state.copyWith(
            chatRoomStatus: const Status.success(CrudAction.fetch),
            roomMain: finalRooms,
          ),
        );
      } else {
        emit(
          state.copyWith(
            chatRoomStatus: const Status.initial(CrudAction.fetch),
            roomMain: localRooms,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          chatRoomStatus: Status.failure(
            action: CrudAction.fetch,
            error: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _rootConnectionSubscription.cancel();
    _messageSubscription.cancel();
    _messageEditSub.cancel();
    _messageDeleteSub.cancel();
    _typingTimer?.cancel();
    _roomsTimeout?.cancel();
    bottomSheetNotifier.dispose();
    return super.close();
  }

  final List<ChatUser> users = [];

  void fetchUser() {
    final res = [
      ChatUser(id: 'a', username: 'Nero', email: 'nero@gmail.com'),
      ChatUser(id: 'b', username: 'Yayo', email: 'yayo@gmail.com'),
      ChatUser(id: 'c', username: 'Kunle', email: 'kunle@gmail.com'),
      ChatUser(id: 'd', username: 'Samson', email: 'samson@gmail.com'),
      ChatUser(id: 'e', username: 'Kerry', email: 'kerry@gmail.com'),
      ChatUser(id: 'f', username: 'greg', email: 'greg@gmail.com'),
      ChatUser(id: 'g', username: 'trey', email: 'trey@gmail.com'),
      ChatUser(id: 'h', username: 'friday', email: 'friday@gmail.com'),
    ];
    users.addAll(res);
  }
}
