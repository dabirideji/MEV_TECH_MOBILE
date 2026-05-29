import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/chat/data/signalr-model/user_status.dart';

part 'chat_data_state.dart';

@injectable
class ChatDataCubit extends Cubit<ChatDataState> {
  ChatDataCubit() : super(const ChatDataState());

  void getMyRooms(List<RoomMain> rooms) {
    if (rooms.isNotEmpty) {
      final finalRooms = rooms
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.copyWith(roomsMain: finalRooms, selectedChatRoom: rooms.first),
      );
    }
  }

  void getPrivateRooms(List<RoomMain> rooms) {
    emit(state.copyWith(privateRooms: rooms));
  }

  void getMessages(List<MessageModel> messages) {
    emit(state.copyWith(messages: messages));
  }

  void getUserStatus(UserStatus? userStatus) {
    emit(state.copyWith(userStatus: userStatus));
  }

  // void getUsersTyping(TypingIndicator indicator) {
  //   final updatedMap = {...state.typingUsersByRoom};
  //   final currentTypistsInRoom =
  //       (updatedMap[indicator.roomId] ?? <String>{}).toSet();

  //   if (indicator.isTyping) {
  //     currentTypistsInRoom.add(indicator.userId);
  //   } else {
  //     currentTypistsInRoom.remove(indicator.userId);
  //   }

  //   if (currentTypistsInRoom.isEmpty) {
  //     updatedMap.remove(indicator.roomId);
  //   } else {
  //     updatedMap[indicator.roomId] = currentTypistsInRoom;
  //   }

  //   emit(state.copyWith(typingUsersByRoom: updatedMap));
  // }

  void getUsersTyping(TypingIndicator indicator) {
    // 1. Update the TYPING USERS (IDs) Map
    final updatedTypingMap = {...state.typingUsersByRoom};
    final currentTypistsInRoom =
        (updatedTypingMap[indicator.roomId] ?? <String>{}).toSet();

    if (indicator.isTyping) {
      currentTypistsInRoom.add(indicator.userId);
    } else {
      currentTypistsInRoom.remove(indicator.userId);
    }

    if (currentTypistsInRoom.isEmpty) {
      updatedTypingMap.remove(indicator.roomId);
    } else {
      updatedTypingMap[indicator.roomId] = currentTypistsInRoom;
    }

    // 2. Update the USERNAME Lookup Map
    final updatedUsernameMap = Map<String, String>.from(
      state.userIdToUsernameMap,
    );
    // Always store/update the current username for this ID
    updatedUsernameMap[indicator.userId] = indicator.username;

    // 3. Emit the new state
    emit(
      state.copyWith(
        typingUsersByRoom: updatedTypingMap,
        userIdToUsernameMap: updatedUsernameMap,
      ),
    );
  }

  //

  // create

  void createRooms(List<MyRoom> rooms) {
    emit(state.copyWith(myRooms: rooms));
  }
}
