// chat_area.dart

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mevtech/core/extensions/string_extension.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/core/utils/multiple_status_states.dart';
import 'package:mevtech/features/chat/chat-constant/chat_color_scheme.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/logic/chat_cubit.dart';
import 'package:mevtech/features/chat/mock/mock_models.dart';
import 'package:mevtech/features/chat/widget/chat_menu_option.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/user-widget/user_image.dart';

class ChatArea extends StatefulWidget {
  const ChatArea({
    required this.messages,
    required this.status,
    required this.isPrivateChat,

    super.key,
    this.user,
    this.currentTypistUsernames = const [],
    this.onLongPress,
    this.onMessageResend,
    this.onMessageRefetch,
    this.onMessageEdit,
    this.onMessageDelete,
    this.onMessagecopy,
  });

  final List<MessageModel> messages;
  final Status status;
  final UserModel? user;
  final List<String> currentTypistUsernames;
  final void Function(MessageModel)? onLongPress;

  final bool isPrivateChat;
  final void Function(MessageModel?)? onMessageResend;
  final void Function()? onMessageRefetch;
  final void Function(MessageModel)? onMessageEdit;
  final void Function(MessageModel)? onMessageDelete;
  final void Function(String)? onMessagecopy;

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  late final ScrollController _scrollController;
  // bool _isLoadingOlder = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels <= 100) {
      // if (_isLoadingOlder) return;

      // _isLoadingOlder = true;

      context.read<ChatCubit>().loadPaginatedLocalMessages();

      //     context
      //     .read<ChatCubit>()
      //     .loadPaginatedLocalMessages(widget.roomId)
      //     .whenComplete(() {
      //   // _isLoadingOlder = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicatorText = formatTypingIndicator(widget.currentTypistUsernames);

    final targetUser = widget.messages.firstWhereOrNull(
      (msg) => msg.userId != widget.user?.id,
    );

    return Container(
      // height: MediaQuery.sizeOf(context).height,
      width: double.maxFinite,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/chat-bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: widget.messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.status.isFetching)
                    MevTechUtilities.customLoader()
                  else if (widget.status.isFailure)
                    Column(
                      children: [
                        Icon(
                          widget.status.error != null &&
                                  widget.status.error!.contains(
                                    'Check your Internet Connection',
                                  )
                              ? FIcons.ban
                              : FIcons.ban,
                          size: 40,
                          color: Colors.red,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          widget.status.error ?? 'An Error Occured',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        FButton.icon(
                          style: FButtonStyle.destructive(),
                          onPress: widget.onMessageRefetch,
                          child: const Text(
                            '  Retry  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        const Icon(
                          FIcons.messageCircle,
                          size: 40,
                          color: Colors.black38,
                        ),
                        SizedBox(height: 20.h),
                        const Text(
                          'No Messages yet',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
          : Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isPrivateChat && targetUser != null)
                  Container(
                    margin: EdgeInsets.all(5.r),

                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      // border: Border.all(
                      //   color: AppColor.primaryLight1,
                      //   width: 2,
                      // ),
                      borderRadius: BorderRadius.circular(20.r),
                      // image: const DecorationImage(
                      //   image: AssetImage('assets/images/chat-bg.jpg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17.r,
                          backgroundColor: getColorForUser(targetUser.userId),
                          child:
                              // Text(username[0].toUpperCase(),
                              Text(
                                targetUser.username[0].toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          targetUser.username.capitalize(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontStyle: .italic,
                            fontSize: 15.sp,
                            color: getColorForUser(targetUser.userId),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (widget.status.isPaginating)
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
                    child: MevTechUtilities.customLoader(scale: 1.5),
                  ),
                // work here
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    reverse: true,

                    // itemCount: messages.length + (status.isFetching ? 1 : 0),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      // final message = messages[messages.length - 1 - index];
                      final message = widget.messages[index];

                      // Get the timestamp of the previous message, if available
                      final previousTimestamp = index > 0
                          ? widget.messages[index - 1].timestamp
                          : null;

                      // 1. Determine if a divider is needed before the current message
                      final needsDivider = isNewDay(
                        message.timestamp,
                        previousTimestamp,
                      );

                      // 2. Build the list of widgets for this index

                      // final message = messages[messages.length - 1 - index];

                      if (widget.isPrivateChat) {
                        return Column(
                          children: [
                            // if (needsDivider)
                            //   dateDividerWidget(
                            //     message.timestamp,
                            //   ),
                            ChatMenuOption(
                              isMe:
                                  widget.user != null &&
                                  widget.user?.id == message.userId,
                              onMessageEdit: () =>
                                  widget.onMessageEdit?.call(message),
                              onMessageDelete: () =>
                                  widget.onMessageDelete?.call(message),
                              onMessagecopy: () =>
                                  widget.onMessagecopy?.call(message.content),
                              child: _PrivateChatMessage(
                                userId: message.userId,
                                username: message.username,
                                timestamp: message.timestamp,
                                content: message.content,
                                user: widget.user,
                                isSending: message.isSending,
                                isFailed: message.isFailed,

                                onMessageResend: widget.onMessageResend,
                                messageModel: message,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          // if (needsDivider)
                          //   dateDividerWidget(
                          //     message.timestamp,
                          //   ),
                          ChatMenuOption(
                            isMe:
                                widget.user != null &&
                                widget.user?.id == message.userId,
                            onMessageEdit: () =>
                                widget.onMessageEdit?.call(message),
                            onMessageDelete: () =>
                                widget.onMessageDelete?.call(message),
                            onMessagecopy: () =>
                                widget.onMessagecopy?.call(message.content),
                            child: _ChatMessage(
                              userId: message.userId,
                              username: message.username,
                              timestamp: message.timestamp,
                              content: message.content,
                              user: widget.user,
                              isSending: message.isSending,
                              isFailed: message.isFailed,

                              onMessageResend: widget.onMessageResend,
                              messageModel: message,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (indicatorText.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      child: Text(
                        indicatorText,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                if (widget.status.isFetching)
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: MevTechUtilities.customLoader(scale: 1.5),
                  ),
              ],
            ),
    );
  }

  String formatTypingIndicator(List<String> usernames) {
    // 1. Filter out duplicates and ensure we have a working list
    final distinctUsernames = usernames.toSet().toList();
    final count = distinctUsernames.length;

    if (count == 0) {
      return ''; // No one is typing
    }

    // 2. Extract the first few names
    final firstName = distinctUsernames.elementAt(0);
    final secondName = count > 1 ? distinctUsernames.elementAt(1) : null;

    String baseString;

    if (count == 1) {
      // e.g., "kunle is typing..."
      baseString = '$firstName is typing...';
    } else if (count == 2) {
      // e.g., "kunle & yayo are typing..."
      baseString = '$firstName & $secondName are typing...';
    } else if (count == 3) {
      // e.g., "kunle, yayo & 1 other user are typing..."
      // The third user is the '1 other user'
      baseString = '$firstName, $secondName & 1 other user is typing...';
    } else {
      // count is 4 or more
      // e.g., "kunle, yayo & 2 other users are typing..." (if count == 4)
      final othersCount = count - 2;
      final otherText = othersCount == 1
          ? '1 other user'
          : '$othersCount other users';
      baseString = '$firstName, $secondName & $otherText are typing...';
    }

    return baseString;
  }

  bool isNewDay(String currentTime, String? previousTime) {
    try {
      final currentTimestamp = DateTime.parse(currentTime);
      final previousTimestamp = previousTime != null
          ? DateTime.tryParse(previousTime)
          : null;

      if (previousTimestamp == null) {
        return true; // Always show a divider before the very first message
      }

      // Strip time component for comparison
      final currentDate = DateTime(
        currentTimestamp.year,
        currentTimestamp.month,
        currentTimestamp.day,
      );
      final previousDate = DateTime(
        previousTimestamp.year,
        previousTimestamp.month,
        previousTimestamp.day,
      );

      // Returns true if the dates are not the same
      return !currentDate.isAtSameMomentAs(previousDate);
    } catch (e) {
      return false;
    }
  }

  Widget dateDividerWidget(String date) {
    return Row(
      children: [
        Container(height: 1, width: 70, color: Colors.black),
        Text(formatDateDivider(date)),
        Container(height: 1, width: 70, color: Colors.black),
      ],
    );
  }

  // Function to format the divider text (same as before)
  String formatDateDivider(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMMM d, yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    required this.userId,
    required this.username,
    required this.timestamp,
    required this.content,
    this.user,
    this.isSending = false,
    this.isFailed = false,

    this.onMessageResend,
    this.messageModel,
  });
  final String userId;
  final String username;
  final String timestamp;
  final String content;
  final UserModel? user;
  final bool isSending;
  final bool isFailed;

  final void Function(MessageModel?)? onMessageResend;
  final MessageModel? messageModel;

  @override
  Widget build(BuildContext context) {
    final userColor = getColorForUser(userId);

    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 16.w, right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null &&
              user?.profilePictureUrl != null &&
              user?.id == userId)
            SizedBox(
              width: 38.w,
              height: 38.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: UserImage(user?.profilePictureUrl ?? ''),
              ),
            )
          else
            CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFFDCDDE1),
              child: Text(
                username[0].toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, color: userColor),
              ),
            ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        spacing: 8.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              color: userColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            formatTimestamp(timestamp),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          if (messageModel?.isEdited ?? false)
                            Text(
                              'Edited',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          content,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (isSending)
                        Icon(
                          Icons.schedule,
                          size: 17,
                          color: Colors.blue.shade400,
                        )
                      else if (isFailed)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error,
                              size: 17,
                              color: Colors.red.shade400,
                            ),
                            TextButton(
                              onPressed: () =>
                                  onMessageResend?.call(messageModel),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                              ),
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // if (user != null && user?.id == userId)
                  //   Positioned(
                  //     bottom: -5,
                  //     right: -5,
                  //     child: Icon(
                  //       isSending
                  //           ? Icons.schedule
                  //           : isFailed
                  //               ? Icons.error
                  //               : Icons.check,
                  //       size: 17,
                  //       color: Colors.blue.shade400,
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Color> userColorPalette = [
    // A palette of visually distinct colors
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  Color getColorForUser(String userId) {
    if (userId.isEmpty) {
      return Colors.black; // Default color for empty ID
    }

    // 1. Get the integer hash code of the userId
    final hash = userId.hashCode;

    // 2. Ensure the hash is non-negative and wrap it using the modulo operator.
    // The result will be an index from 0 up to (userColorPalette.length - 1).
    final index = hash.abs() % userColorPalette.length;

    // 3. Return the color at that deterministic index.
    return userColorPalette[index];
  }

  String formatTimestamp(String timestampString) {
    // "2025-11-25T18:41:55.0699404"
    try {
      final timestamp = DateTime.parse(timestampString).toLocal();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      // Strip time component from the timestamp for easy comparison
      final dateOnly = DateTime(timestamp.year, timestamp.month, timestamp.day);

      // Helper for formatting time (e.g., "10:30 AM")

      final timeFormatter = DateFormat("h:mm 'at' a");

      if (dateOnly.isAtSameMomentAs(today)) {
        // 1. If Today: "Today at 10:30 AM"
        return 'Today at ${timeFormatter.format(timestamp)}';
      } else if (dateOnly.isAtSameMomentAs(yesterday)) {
        // 2. If Yesterday: "Yesterday at 11:00 AM"
        return 'Yesterday at ${timeFormatter.format(timestamp)}';
      } else if (now.difference(timestamp).inDays < 7) {
        // 3. If within the last 7 days: "Wednesday at 9:00 PM"
        // Use 'EEEE' for the full day name (e.g., Monday)

        final dayTimeFormatter = DateFormat("EEEE 'at' h:mm a");
        return dayTimeFormatter.format(timestamp);
      } else {
        // 4. If older than 7 days: "11/25/2025" or "Nov 25, 2025" (Choose your format)
        // Example: "MM/dd/yyyy"
        final fullDateFormatter = DateFormat('MM/dd/yyyy');
        return fullDateFormatter.format(timestamp);
      }
    } catch (e) {
      return timestampString;
    }
  }
}

class _PrivateChatMessage extends StatelessWidget {
  const _PrivateChatMessage({
    required this.userId,
    required this.username,
    required this.timestamp,
    required this.content,
    this.user,
    this.isSending = false,
    this.isFailed = false,

    this.onMessageResend,
    this.messageModel,
    g,
  });
  final String userId;
  final String username;
  final String timestamp;
  final String content;
  final UserModel? user;
  final bool isSending;
  final bool isFailed;

  final void Function(MessageModel?)? onMessageResend;
  final MessageModel? messageModel;

  @override
  Widget build(BuildContext context) {
    final userColor = getColorForUser(userId);

    final isMe = user != null && user?.id == userId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: isMe
            ? EdgeInsets.only(top: 5.h, bottom: 5.h, right: 16.w, left: 70.w)
            : EdgeInsets.only(top: 5.h, bottom: 5.h, left: 16.w, right: 70.w),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent.shade700 : Colors.white,
            // border:
            //     isMe ? null : Border.all(width: 2, color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isMe
                ? null
                : const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.grey.shade800,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisSize: .min,
                spacing: 5.w,
                children: [
                  Text(
                    formatTimestamp(timestamp),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  if (messageModel?.isEdited ?? false)
                    Text(
                      'Edited',
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.grey.shade400,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
              if (isSending)
                const Icon(Icons.schedule, size: 17, color: Colors.white70)
              else if (isFailed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, size: 17, color: Colors.red.shade400),
                    TextButton(
                      onPressed: () => onMessageResend?.call(messageModel),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                      ),
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ],
                ),

              // if (user != null && user?.id == userId)
              //   Positioned(
              //     bottom: 0,
              //     right: 2,
              //     child: Icon(
              //       isSending
              //           ? Icons.schedule
              //           : isFailed
              //               ? Icons.error
              //               : Icons.check,
              //       size: 17,
              //       color: Colors.blue.shade400,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  static List<Color> userColorPalette = [
    // A palette of visually distinct colors
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  Color getColorForUser(String userId) {
    if (userId.isEmpty) {
      return Colors.black; // Default color for empty ID
    }

    // 1. Get the integer hash code of the userId
    final hash = userId.hashCode;

    // 2. Ensure the hash is non-negative and wrap it using the modulo operator.
    // The result will be an index from 0 up to (userColorPalette.length - 1).
    final index = hash.abs() % userColorPalette.length;

    // 3. Return the color at that deterministic index.
    return userColorPalette[index];
  }

  String formatTimestamp(String timestampString) {
    try {
      final timestamp = DateTime.parse(timestampString).toLocal();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      // Strip time component from the timestamp for easy comparison
      final dateOnly = DateTime(timestamp.year, timestamp.month, timestamp.day);

      // Helper for formatting time (e.g., "10:30 AM")

      final timeFormatter = DateFormat("h:mm 'at' a");

      if (dateOnly.isAtSameMomentAs(today)) {
        // 1. If Today: "Today at 10:30 AM"
        return 'Today at ${timeFormatter.format(timestamp)}';
      } else if (dateOnly.isAtSameMomentAs(yesterday)) {
        // 2. If Yesterday: "Yesterday at 11:00 AM"
        return 'Yesterday at ${timeFormatter.format(timestamp)}';
      } else if (now.difference(timestamp).inDays < 7) {
        // 3. If within the last 7 days: "Wednesday at 9:00 PM"
        // Use 'EEEE' for the full day name (e.g., Monday)

        final dayTimeFormatter = DateFormat("EEEE 'at' h:mm a");
        return dayTimeFormatter.format(timestamp);
      } else {
        // 4. If older than 7 days: "11/25/2025" or "Nov 25, 2025" (Choose your format)
        // Example: "MM/dd/yyyy"
        final fullDateFormatter = DateFormat('MM/dd/yyyy');
        return fullDateFormatter.format(timestamp);
      }
    } catch (e) {
      return timestampString;
    }
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.controller,
    super.key,
    this.selectedChannelId,
    this.onSubmitted,
    this.onTextChange,
    this.editingMessageId,
    this.focusNode,
  });

  final void Function(String, String? id)? onSubmitted;
  final String? selectedChannelId;
  final void Function(String)? onTextChange;
  final TextEditingController controller;
  final String? editingMessageId;
  final FocusNode? focusNode;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  // final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _submitMessage() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text, widget.editingMessageId);
      widget.controller.clear();
      widget.onTextChange?.call('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 7),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.add,
          //       color: Theme.of(context).primaryColor,
          //       size: 24,
          //     ),
          //     onPressed: () {},
          //     style: IconButton.styleFrom(
          //       padding: const EdgeInsets.all(10),
          //       backgroundColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30),
          //         side: BorderSide(color: Colors.grey.shade300, width: 2),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.controller,
                minLines: 1,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: '# Message',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  // filled: true,
                  // fillColor: Colors.white,
                  // suffixIcon: Padding(
                  //   padding: EdgeInsets.all(5.r),
                  //   child: IconButton(
                  //     splashColor: Colors.white38,
                  //     padding: EdgeInsets.zero,
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.attach_file,
                  //       size: 25,
                  //       color: AppColor.primary,
                  //     ),
                  //     visualDensity: const VisualDensity(
                  //       horizontal: -4,
                  //       vertical: -4,
                  //     ),
                  //   ),
                  // ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      // width: 2.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: const BorderSide(
                      color: AppColor.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onSubmitted: (text) {
                  // Implement your sendMessage logic here
                },
                onChanged: (value) {
                  widget.onTextChange?.call(value);
                  setState(() {});
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 10),
            child: IconButton(
              icon: Icon(
                // widget.controller.text.isEmpty ? Icons.mic : Icons.send,
                widget.editingMessageId != null
                    ? FIcons.check
                    : FIcons.sendHorizontal,
                color: Colors.white,
                size: 22,
              ),
              onPressed: _submitMessage,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(13),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
