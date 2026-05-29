import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/core/network/signalr_cubit.dart';
import 'package:mevtech/core/utils/clipboard_manager.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/chat/data/models/status_state.dart';
import 'package:mevtech/features/chat/logic/chat_cubit.dart';
import 'package:mevtech/features/chat/widget/channel_list.dart';
import 'package:mevtech/features/chat/widget/chat_area.dart';
import 'package:mevtech/features/chat/widget/connection_status_widget.dart';
import 'package:mevtech/features/chat/widget/main_chat_layout.dart';
import 'package:mevtech/features/chat/widget/my_chat_theme.dart';
import 'package:mevtech/features/chat/widget/pop_message_menu.dart';
import 'package:mevtech/features/chat/widget/room_mangement.dart';
import 'package:mevtech/features/chat/widget/server_list.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({this.channelId, super.key});

  final String? channelId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final txtMessage = TextEditingController();
  final txtMessageFocus = FocusNode();
  String? _editingMessageId;
  String? _tempMessageContent;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    txtMessage.dispose();
    txtMessageFocus.dispose();

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

  void _showContextMenu({
    void Function()? onTapEdit,
    void Function()? onTapDelete,
  }) {
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
        const PopupMenuItem<String>(value: 'Copy', child: Text('Copy')),
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

    final chatCubit = context.read<ChatCubit>();
    _editingMessageId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatCubit.state.roomMain.isEmpty) {
        chatCubit.fetchChatRooms();
        // chatCubit.requestMyRooms();
      } else {
        final room = chatCubit.state.roomMain.firstWhereOrNull(
          (r) => r.id == chatCubit.state.selectedChatRoomId,
        );
        final unreadCount = room?.settings.unreadRoomMessagesCount ?? 0;

        chatCubit.loadInitialMessages(room?.id ?? '', unreadCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final chatStatus = context.watch<ChatCubit>().chatStatus;
    final chatCubit = context.read<ChatCubit>();

    // log(chatStatus?.name ?? 'no');
    return MyChatTheme(
      child: BlocConsumer<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          // if (state.actionStatus.isLoading) {
          //   MevTechUtilities.showProgressIndicator(context);
          // } else {
          //   MevTechUtilities.hideProgressIndicator(context);
          //   if (state.actionStatus.isSuccess &&
          //       state.actionMessage.isNotEmpty) {
          //     MevTechUtilities.successToast(context, state.actionMessage);
          //   }
          //   if (state.actionStatus.isFailure) {
          //     MevTechUtilities.errorToast(
          //         context, state.actionStatus.error ?? 'An error occured');
          //   }
          //   chatCubit.resetActionStatus();
          // }
        },
        builder: (context, state) {
          final roomName =
              state.roomMain
                  .firstWhereOrNull(
                    (room) => room.id == state.selectedChatRoomId,
                  )
                  ?.name ??
              'No Chatroom found';

          return Stack(
            children: [
              Scaffold(
                extendBody: true,
                // extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                backgroundColor: Colors.white60,

                appBar: AppBar(
                  title: state.selectedChatRoomId != null
                      ? Text(
                          '# $roomName',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary,
                          ),
                        )
                      : Text(
                          'No Chatroom Found',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary.withAlpha(150),
                          ),
                        ),
                  actions: [
                    // ElevatedButton(
                    //   // ignore: unnecessary_lambdas
                    //   onPressed: () {
                    //     chatCubit.deleteDb('messages');
                    //   },
                    //   child: Text('Test DB'),
                    // ),
                    ConnectionStatusWidget(chatStatus),
                    SizedBox(width: 5.w),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 5.w),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: PopupMenuButton(
                    //     color: Colors.white,
                    //     itemBuilder: (context) {
                    //       return [
                    //         PopupMenuItem<Widget>(
                    //           child: Column(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               // ListTile(
                    //               //     title: Text(
                    //               //       // 'Leave Room',
                    //               //       'load room messages',
                    //               //       style: TextStyle(
                    //               //         fontWeight: FontWeight.w500,
                    //               //         fontSize: 13.sp,
                    //               //       ),
                    //               //     ),
                    //               //     hoverColor: Colors.transparent,
                    //               //     onTap: () {
                    //               //       Navigator.pop(context);
                    //               //
                    //               //       // onClickLeaveRoom?.call(selectedChannelId);
                    //               //       // chatCubit.loadRoomMessages(roomId: roomId ?? '');
                    //               //     }),
                    //               ListTile(
                    //                 title: Text(
                    //                   'Close Chat',
                    //                   // 'Request My Room',
                    //                   style: TextStyle(
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 13.sp,
                    //                   ),
                    //                 ),
                    //                 hoverColor: Colors.transparent,
                    //                 onTap: () {
                    //                   Navigator.pop(context);
                    //                   Navigator.pop(context);
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ];
                    //     },
                    //     child: const Padding(
                    //       padding: EdgeInsets.only(right: 4),
                    //       child: Icon(
                    //         Icons.more_vert,
                    //         size: 30,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                            myRooms: state.roomMain
                                .where((room) => !room.isPrivate)
                                .toList(),
                            selectedChannelId: state.selectedChatRoomId,
                            onAddBtnClick: () {
                              RoomMangement.showAddRoomOption(
                                context: context,
                                onTapCreateGroup: () {
                                  Navigator.pop(context);
                                  RoomMangement.showCreateRoom(
                                    context: context,
                                    onConfirmGroup:
                                        ({
                                          bool? isPrivate,
                                          String? roomName,
                                          String? roomPass,
                                        }) {
                                          Navigator.pop(context);
                                          chatCubit.createRoom(
                                            groupName: roomName ?? '',
                                            roomPass: roomPass,
                                            isPrivate: isPrivate ?? false,
                                          );
                                        },
                                    onConfirmCommunity: (communityName) {
                                      Navigator.pop(context);
                                      chatCubit.createRoomCommunity(
                                        communityName,
                                      );
                                    },
                                  );
                                },
                                onTapCreatePrivateChat: () {
                                  Navigator.pop(context);
                                  RoomMangement.showCreatePrivateChat(
                                    context: context,
                                    notifier: chatCubit.bottomSheetNotifier,
                                    onSearch: chatCubit.fetchChatUser,
                                    onSelect: (targetUserId) {
                                      Navigator.pop(context);
                                      chatCubit.createPrivateChat(targetUserId);
                                    },
                                  );
                                },
                                onTapJoinGroup: () {},
                              );

                              // remove below
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
                          child: Builder(
                            builder: (context) {
                              if (state.chatRoomStatus.isLoading &&
                                  state.roomMain.isEmpty) {
                                return MevTechUtilities.customLoader();
                              }

                              // Timeout ended but still no rooms?
                              if (state.chatRoomStatus.isFailure &&
                                  state.roomMain.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.chatRoomStatus.error ??
                                            'Unable to load rooms.\nCheck your connection.',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: chatCubit.fetchChatRooms,
                                        // onPressed: chatCubit.requestMyRooms,
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ChannelList(
                                selectedChannelId: state.selectedChatRoomId,
                                myRooms: state.roomMain,
                                isPersonalRoom: state.isPersonalRoom,
                                currentUser: user,
                                // state.isPersonalRoom
                                //     ? state.roomMain
                                //         .where((room) => room.isPrivate)
                                //         .toList()
                                //     : state.roomMain
                                //         .where((room) => !room.isPrivate)
                                //         .toList(),
                                // isSelected: myRoom.id == selectedChannelId,,
                                onTapChannel: (id) {
                                  _scaffoldKey.currentState?.closeDrawer();
                                  chatCubit.selectChatRooms(
                                    id,
                                    currentUserId: user?.id,
                                  );
                                  txtMessage.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: BlocConsumer<ChatCubit, ChatState>(
                  // listenWhen: (previous, current) => previous != current,
                  listener: (context, state) {
                    // if (state.actionStatus.isLoading) {
                    //   MevTechUtilities.showProgressIndicator(context);
                    // } else {
                    //   MevTechUtilities.hideProgressIndicator(context);
                    //   if (state.actionStatus.isSuccess &&
                    //       state.actionMessage.isNotEmpty) {
                    //     MevTechUtilities.successToast(context, state.actionMessage);
                    //   }
                    //   if (state.actionStatus.isFailure) {
                    //     MevTechUtilities.errorToast(
                    //         context, state.actionStatus.error ?? 'An error occured');
                    //   }
                    //   chatCubit.resetActionStatus();
                    // }
                  },
                  builder: (context, state) {
                    final roomIndex = state.roomMain.indexWhere(
                      (r) => r.id == state.selectedChatRoomId,
                    );

                    if (roomIndex != -1) {
                      return IndexedStack(
                        index: roomIndex,
                        children: state.roomMain.map((room) {
                          return ChatArea(
                            messages: state.messages,
                            status: state.messageStatus,
                            isPrivateChat: room.isPrivate,
                            user: user,
                            currentTypistUsernames:
                                state.currentTypistUsernames,

                            // onLongPress: (message) {
                            //   _showContextMenu(
                            //     onTapEdit: () {
                            //       txtMessage.text = message.content;
                            //       // log(message.content);
                            //     },
                            //     onTapDelete: () {
                            //       log('Deleted');
                            //     },
                            //   );
                            // },
                            onMessageEdit: (message) {
                              // log('message Edited');
                              setState(() {
                                _editingMessageId = message.id;
                                _tempMessageContent = message.content;
                                txtMessage.text = message.content;
                                txtMessageFocus.requestFocus();
                              });
                            },
                            onMessageDelete: (message) {
                              MevTechUtilities.showAnimatedAlert(
                                context: context,
                                message:
                                    'Are you sure you want to delete this message?',
                                onConfirm: () {
                                  // log('confirmed pressed');
                                  chatCubit.deleteMessage(
                                    messageId: message.id,
                                    roomId: message.roomId,
                                  );
                                },
                              );
                            },
                            onMessagecopy: (content) {
                              // log('message Copied Succesfully');
                              ClipboardManager.copyToClipboard(
                                content,
                                context,
                              );
                            },
                            onMessageRefetch: () {
                              final chatRoomId = state.selectedChatRoomId;
                              chatCubit.refetchMessage(
                                chatRoomId,
                                currentUserId: user?.id,
                              );
                            },
                            onMessageResend: (message) {
                              final chatRoomId = state.selectedChatRoomId;
                              chatCubit.resendMessage(chatRoomId, message);
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Icon(
                              FIcons.user,
                              size: 40.sp,
                              color: Colors.black45,
                            ),
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  FIcons.user,
                                  size: 40.sp,
                                  color: Colors.black45,
                                ),
                                Icon(
                                  FIcons.users,
                                  size: 40.sp,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              textAlign: TextAlign.center,
                              'Opps! Room Not Found',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              textAlign: TextAlign.center,
                              'please select or create one from the menu above',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                bottomNavigationBar: state.selectedChatRoomId != null
                    ? SafeArea(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              SizedBox(height: 7.h),
                              if (_editingMessageId != null)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 0.6,
                                    ),
                                  ),
                                  child: Row(
                                    spacing: 10.w,
                                    children: [
                                      Icon(
                                        FIcons.pencil,
                                        size: 20.sp,
                                        color: AppColor.primary,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              'Edit Message',
                                              style: TextStyle(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                            Text(
                                              _tempMessageContent ??
                                                  'No Content',
                                              maxLines: 1,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: resetMessageEditState,
                                        icon: const Icon(FIcons.x),
                                        visualDensity: .compact,
                                      ),
                                    ],
                                  ),
                                ),
                              ChatInput(
                                // selectedChannelId: state.selectedChatRoomId,
                                controller: txtMessage,
                                focusNode: txtMessageFocus,
                                editingMessageId: _editingMessageId,
                                onSubmitted: (content, editId) {
                                  if (state.selectedChatRoomId != null) {
                                    final roomId = state.selectedChatRoomId;
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    if (editId != null) {
                                      // Reset the ID before submission
                                      setState(() {
                                        _editingMessageId = null;
                                        _tempMessageContent = null;
                                      });

                                      chatCubit.editMessage(
                                        messageId: editId,
                                        roomId: roomId,
                                        newContent: content,
                                      );
                                      // log('Edited Content: $content');
                                    } else {
                                      chatCubit.sendMessage(
                                        roomId,
                                        content,
                                        user: user,
                                      );
                                      // log('Original Content: $content');
                                    }
                                  }
                                },
                                onTextChange: (value) {
                                  chatCubit.onTextChanged(
                                    value,
                                    state.selectedChatRoomId ?? '',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
              // showStatus(chatCubit.statusState, context),
              ShowStatus(chatCubit.statusState),
            ],
          );
        },
      ),
    );
  }

  void resetMessageEditState() {
    txtMessage.clear();

    setState(() {
      _editingMessageId = null;
      _tempMessageContent = null;
    });
  }

  Widget showStatus(ValueNotifier<StatusState> notifier, BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (ctx, state, child) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          // MevTechUtilities.customToast(
          //   context,
          //   state.error ?? 'An error ocuured',
          //   isFailure: true,
          // );
          MevTechUtilities.errorToast(
            context,
            state.error ?? 'An error ocuured',
          );
          resetStatus(notifier);
          return const SizedBox.shrink();
        } else if (state.success.isNotEmpty) {
          // MevTechUtilities.customToast(context, state.success);
          MevTechUtilities.successToast(context, state.success);
          resetStatus(notifier);
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  void resetStatus(ValueNotifier<StatusState> notifier) {
    notifier.value = StatusState();
  }
}

// class ShowStatus extends StatefulWidget {
//   const ShowStatus(this.notifier, {super.key});
//   final ValueNotifier<StatusState> notifier;
//   @override
//   State<ShowStatus> createState() => _ShowStatusState();
// }
// class _ShowStatusState extends State<ShowStatus> {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: widget.notifier,
//       builder: (ctx, state, child) {
//         if (state.isLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state.error != null) {
//           MevTechUtilities.customToast(
//             context,
//             state.error ?? 'An error ocuured',
//             isFailure: true,
//           );
//           resetStatus(widget.notifier);
//           return const SizedBox.shrink();
//         } else if (state.success.isNotEmpty) {
//           MevTechUtilities.customToast(context, state.success);
//           resetStatus(widget.notifier);
//           return const SizedBox.shrink();
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
//   void resetStatus(ValueNotifier<StatusState> notifier) {
//     notifier.value = StatusState();
//   }
// }

class ShowStatus extends StatefulWidget {
  const ShowStatus(this.notifier, {super.key});

  final ValueNotifier<StatusState> notifier;

  @override
  State<ShowStatus> createState() => _ShowStatusState();
}

class _ShowStatusState extends State<ShowStatus> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (ctx, state, child) {
        // Show loading widget normally (safe)
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle errors & success using post-frame callback
        if (state.error != null || state.success.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            if (state.error != null) {
              MevTechUtilities.errorToast(context, state.error!);
            } else {
              MevTechUtilities.successToast(context, state.success);
            }

            resetStatus(widget.notifier);
          });

          // Return empty widget immediately
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  void resetStatus(ValueNotifier<StatusState> notifier) {
    notifier.value = StatusState();
  }
}
