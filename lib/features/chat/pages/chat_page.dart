import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/chat/logic/chat_cubit.dart';
import 'package:template/features/chat/widget/channel_list.dart';
import 'package:template/features/chat/widget/chat_area.dart';
import 'package:template/features/chat/widget/main_chat_layout.dart';
import 'package:template/features/chat/widget/my_chat_theme.dart';
import 'package:template/features/chat/widget/pop_message_menu.dart';
import 'package:template/features/chat/widget/room_mangement.dart';
import 'package:template/features/chat/widget/server_list.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({this.channelId, super.key});

  final String? channelId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // bool isShowSendButton = false;

  final txtMessage = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    txtMessage.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant ChatPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.channelId != widget.channelId) {
  //     // context.read<ChatCubit>().selectChannel(widget.channelId);
  //   }
  // }

  // Store the position of the tap down event.
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    // Get the global position of the tap.
    _tapPosition = details.globalPosition;
  }

  void _showContextMenu(
      {void Function()? onTapEdit, void Function()? onTapDelete}) {
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    showMenu(
      context: context,
      // The position determines where the pop-up menu will be displayed.
      position: RelativeRect.fromRect(
        _tapPosition &
            const Size(40, 40), // A small rectangle at the tap position.
        Offset.zero &
            overlay.size, // The size of the overlay, usually the whole screen.
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Edit',
          onTap: onTapEdit,
          child: const Text('Edit'),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          onTap: onTapDelete,
          child: const Text('Delete'),
        ),
        const PopupMenuItem<String>(
          value: 'Copy',
          child: Text('Copy'),
        ),
      ],
    );
    // .then((value) {
    //   if (value != null) {
    //     // Handle the selected value.
    //     debugPrint('Selected: $value');
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    // context.read<ChatCubit>().fetchChannels();
    // context.read<ChatCubit>().selectChannel(widget.channelId);
  }

  // firstWhereOrNull

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final chatCubit = context.read<ChatCubit>();
    return MyChatTheme(
      child: BlocConsumer<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.actionStatus.isLoading) {
            MevTechUtilities.showProgressIndicator(context);
          } else {
            MevTechUtilities.hideProgressIndicator(context);
            if (state.actionStatus.isSuccess &&
                state.actionMessage.isNotEmpty) {
              MevTechUtilities.successToast(context, state.actionMessage);
            }
            if (state.actionStatus.isFailure) {
              MevTechUtilities.errorToast(
                  context, state.actionStatus.error ?? 'An error occured');
            }
            chatCubit.resetActionStatus();
          }
        },
        builder: (context, state) {
          final roomName = state.roomMain
                  .firstWhereOrNull(
                      (room) => room.id == state.selectedChatRoomId)
                  ?.name ??
              'No Chatroom found';

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white60,
            appBar: AppBar(
              title: state.selectedChatRoomId != null
                  ? Text(
                      '# $roomName',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    )
                  : Text(
                      'No Chatroom selected\nselect one on the side panel',
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
                                  // onClickLeaveRoom?.call(selectedChannelId);
                                  // chatCubit.loadRoomMessages(roomId: roomId ?? '');
                                }),
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
                    child: Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
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
                        bottomRight: Radius.circular(8))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 72.w,
                      child: ServerList(
                        myRooms: state.roomMain,
                        selectedChannelId: state.selectedChatRoomId,
                        onAddBtnClick: () {
                          RoomMangement.showAddRoomOption(
                            context: context,
                            onTapCreateGroup: () {
                              Navigator.pop(context);
                              RoomMangement.showCreateRoom(
                                context: context,
                                // isPrivate: false,
                                onConfirm: (roomName, roomPassword,
                                    {bool? isPrivate}) {
                                  Navigator.pop(context);
                                  chatCubit.createRoom(
                                    groupName: roomName,
                                    roomPass: roomPassword,
                                    isPrivate: isPrivate ?? false,
                                  );
                                },
                              );
                            },
                            onTapCreatePrivateChat: () {
                              RoomMangement.showCreatePrivateChat(
                                context: context,
                                targetUserId: TextEditingController(),
                              );
                            },
                            onTapJoinGroup: () {},
                          );
                          // chatCubit.createRoom('Tech-Aspirant');
                        },
                        onTapServer: (id) {
                          chatCubit.toggleRoomType(isPersonalRoom: false);
                        },
                        onPersonalRoomClick: () {
                          chatCubit.toggleRoomType(isPersonalRoom: true);
                        },
                      ),
                    ),
                    Expanded(
                        child: ChannelList(
                      selectedChannelId: state.selectedChatRoomId,
                      myRooms: state.roomMain,
                      onTapChannel: (id) {
                        _scaffoldKey.currentState?.closeDrawer();
                        chatCubit.selectChatRooms(id, currentUserId: user?.id);
                        txtMessage.clear();
                      },
                    )),
                  ],
                ),
              ),
            ),
            body: IndexedStack(
              index: state.roomMain
                  .indexWhere((r) => r.id == state.selectedChatRoomId),
              children: state.roomMain.map((room) {
                return ChatArea(
                    messages: state.messages,
                    status: state.messageStatus,
                    user: user,
                    currentTypistUsernames: state.currentTypistUsernames,
                    onTapDown: _getTapPosition,
                    onLongPress: (message) {
                      _showContextMenu(onTapEdit: () {
                        txtMessage.text = message.content;
                        // log(message.content);
                      }, onTapDelete: () {
                        log('Deleted');
                      });
                    });
              }).toList(),
            ),

            // BlocConsumer<ChatCubit, ChatState>(
            //   listenWhen: (previous, current) => previous != current,
            //   listener: (context, state) {
            //     if (state.actionStatus.isLoading) {
            //       MevTechUtilities.showProgressIndicator(context);
            //     } else {
            //       MevTechUtilities.hideProgressIndicator(context);
            //       if (state.actionStatus.isSuccess &&
            //           state.actionMessage.isNotEmpty) {
            //         MevTechUtilities.successToast(context, state.actionMessage);
            //       }
            //       if (state.actionStatus.isFailure) {
            //         MevTechUtilities.errorToast(
            //             context, state.actionStatus.error ?? 'An error occured');
            //       }
            //       chatCubit.resetActionStatus();
            //     }
            //   },
            //   builder: (context, state) {
            //     return IndexedStack(
            //       index: state.roomMain
            //           .indexWhere((r) => r.id == state.selectedChatRoomId),
            //       children: state.roomMain.map((room) {
            //         return ChatArea(
            //           messages: state.messages,
            //           status: state.messageStatus,
            //           user: user,
            //           currentTypistUsernames: state.currentTypistUsernames,
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
            bottomNavigationBar: SafeArea(
              child: ChatInput(
                // selectedChannelId: state.selectedChatRoomId,
                controller: txtMessage,
                onSubmitted: (content) {
                  if (state.selectedChatRoomId != null) {
                    final roomId = state.selectedChatRoomId;
                    FocusManager.instance.primaryFocus?.unfocus();
                    chatCubit.sendMessage(roomId, content, user: user);
                  }
                },
                onTextChange: (value) {
                  chatCubit.onTextChanged(
                      value, state.selectedChatRoomId ?? '');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
