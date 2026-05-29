part of 'chat_cubit.dart';

enum ChatConnectionStatus {
  // Initial state, or after a manual disconnect
  disconnected,

  // Actively trying to connect (initial attempt or reconnecting)
  connecting,

  // Connection is fully established and ready for use
  connected,
}

class ChatState extends Equatable {
  const ChatState({
    this.isPersonalRoom = false,
    this.myRooms = const [],
    this.roomMain = const [],
    this.privateRooms = const [],
    this.messages = const [],
    this.selectedChatRoomId,
    this.chatRoomStatus = const Status.initial(),
    this.messageStatus = const Status.initial(),
    this.connectionStatus = ChatConnectionStatus.disconnected,
    this.connectionError = '',
    this.userStatus,
    this.currentTypistUsernames = const [],
    this.actionStatus = const Status.initial(),
    this.actionMessage = '',
  });

  final bool isPersonalRoom;
  final List<MyRoom> myRooms;
  final List<RoomMain> roomMain;
  final List<MyRoom> privateRooms;
  final List<MessageModel> messages;
  final String? selectedChatRoomId;
  final Status chatRoomStatus;
  final Status messageStatus;
  final ChatConnectionStatus connectionStatus;
  final String connectionError;
  final UserStatus? userStatus;
  final List<String> currentTypistUsernames;
  final Status actionStatus;
  final String actionMessage;

  ChatState copyWith({
    bool? isPersonalRoom,
    List<MyRoom>? myRooms,
    List<RoomMain>? roomMain,
    List<MyRoom>? privateRooms,
    List<MessageModel>? messages,
    String? selectedChatRoomId,
    Status? chatRoomStatus,
    Status? messageStatus,
    ChatConnectionStatus? connectionStatus,
    String? connectionError,
    UserStatus? userStatus,
    List<String>? currentTypistUsernames,
    Status? actionStatus,
    String? actionMessage,
  }) {
    return ChatState(
      isPersonalRoom: isPersonalRoom ?? this.isPersonalRoom,
      myRooms: myRooms ?? this.myRooms,
      roomMain: roomMain ?? this.roomMain,
      privateRooms: privateRooms ?? this.privateRooms,
      messages: messages ?? this.messages,
      messageStatus: messageStatus ?? this.messageStatus,
      chatRoomStatus: chatRoomStatus ?? this.chatRoomStatus,
      selectedChatRoomId: selectedChatRoomId ?? this.selectedChatRoomId,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      connectionError: connectionError ?? this.connectionError,
      userStatus: userStatus ?? this.userStatus,
      currentTypistUsernames:
          currentTypistUsernames ?? this.currentTypistUsernames,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
        isPersonalRoom,
        myRooms,
        roomMain,
        privateRooms,
        messages,
        selectedChatRoomId,
        chatRoomStatus,
        messageStatus,
        connectionStatus,
        connectionError,
        userStatus,
        currentTypistUsernames,
        actionStatus,
        actionMessage,
      ];
}

final defaultRoom = MyRoom(
  id: 'Default',
  name: 'Default Room',
  description: 'Thia is a default room',
  isPrivate: false,
  unreadCount: 0,
);
