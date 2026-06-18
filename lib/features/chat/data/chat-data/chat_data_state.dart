part of 'chat_data_cubit.dart';

class ChatDataState extends Equatable {
  const ChatDataState(
      {this.myRooms = const [],
      this.roomsMain = const [],
      this.privateRooms = const [],
      this.messages = const [],
      this.selectedChatRoom,
      this.userStatus,
      this.typingUsersByRoom = const {},
      this.userIdToUsernameMap = const {}});

  final List<MyRoom> myRooms;
  final List<RoomMain> roomsMain;
  final List<RoomMain> privateRooms;
  final List<MessageModel> messages;
  final RoomMain? selectedChatRoom;
  final UserStatus? userStatus;
  final Map<String, Set<String>> typingUsersByRoom;
  final Map<String, String> userIdToUsernameMap;

  ChatDataState copyWith({
    List<MyRoom>? myRooms,
    List<RoomMain>? roomsMain,
    List<RoomMain>? privateRooms,
    List<MessageModel>? messages,
    RoomMain? selectedChatRoom,
    UserStatus? userStatus,
    Map<String, Set<String>>? typingUsersByRoom,
    Map<String, String>? userIdToUsernameMap,
  }) {
    return ChatDataState(
      myRooms: myRooms ?? this.myRooms,
      roomsMain: roomsMain ?? this.roomsMain,
      messages: messages ?? this.messages,
      selectedChatRoom: selectedChatRoom ?? this.selectedChatRoom,
      userStatus: userStatus ?? this.userStatus,
      typingUsersByRoom: typingUsersByRoom ?? this.typingUsersByRoom,
      privateRooms: privateRooms ?? this.privateRooms,
      userIdToUsernameMap: userIdToUsernameMap ?? this.userIdToUsernameMap,
    );
  }

  @override
  List<Object?> get props => [
        myRooms,
        roomsMain,
        privateRooms,
        messages,
        selectedChatRoom,
        userStatus,
        typingUsersByRoom,
        userIdToUsernameMap,
      ];
}
