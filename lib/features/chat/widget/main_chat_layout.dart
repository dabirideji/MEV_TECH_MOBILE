import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/core/utils/multiple_status_states.dart';
import 'package:mevtech/features/chat/data/models/room_model.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/chat/mock/mock_models.dart';
import 'package:mevtech/features/chat/widget/channel_list.dart';
import 'package:mevtech/features/chat/widget/chat_area.dart';
import 'package:mevtech/features/chat/widget/server_list.dart';

class MainChatLayout extends StatelessWidget {
  const MainChatLayout({
    required this.messages,
    required this.myRooms,
    required this.myServerRooms,
    required this.scaffoldKey,
    this.selectedChannelId,
    super.key,
    this.onMessageSend,
    this.onTapChannel,
    this.onClickLeaveRoom,
    this.onTextChange,
    this.onPersonalRoomClick,
    this.onAddBtnClick,
    this.onTapServer,
    required this.messageStatus,
  });
  final String? selectedChannelId;
  final List<MessageModel> messages;
  final List<RoomMain> myRooms;
  final void Function(String?, String)? onMessageSend;
  final void Function(String)? onTapChannel;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(String?)? onClickLeaveRoom;
  final void Function(String, String?)? onTextChange;
  final void Function()? onPersonalRoomClick;
  final void Function()? onAddBtnClick;
  final void Function(String)? onTapServer;
  final List<RoomMain> myServerRooms;
  final Status messageStatus;

  // = GlobalKey<ScaffoldState>();
  // scaffoldKey.currentState?.openEndDrawer();

  @override
  Widget build(BuildContext context) {
    // final isMobile = MediaQuery.of(context).size.width < 600;

    final roomName =
        myRooms
            .firstWhereOrNull((room) => room.id == selectedChannelId)
            ?.name ??
        'No Chatroom found';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: selectedChannelId != null
            ? Text(
                '# $roomName',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              )
            : Text(
                'No Chatroom found\ncreate one on the side panel',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) {
              return [
                PopupMenuItem<Widget>(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          // 'Leave Room',
                          'load room messages',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          onClickLeaveRoom?.call(selectedChannelId);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Close Chat',
                          // 'Request My Room',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ];
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.more_vert, size: 30),
            ),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72.w,
                child: ServerList(
                  myRooms: myServerRooms,
                  selectedChannelId: selectedChannelId,
                  onAddBtnClick: onAddBtnClick,
                  onTapServer: onTapServer,
                  onPersonalRoomClick: onPersonalRoomClick,
                ),
              ),
              Expanded(
                child: ChannelList(
                  selectedChannelId: selectedChannelId,
                  myRooms: myRooms,
                  onTapChannel: onTapChannel,
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: myRooms.indexWhere((r) => r.id == selectedChannelId),
        children: myRooms.map((room) {
          return ChatArea(
            isPrivateChat: room.isPrivate,
            messages: messages,
            status: messageStatus,
          );
        }).toList(),
      ),
    );
  }
}
