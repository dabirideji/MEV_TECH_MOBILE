// chat_area.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/core/utils/multiple_status_states.dart';
import 'package:template/features/chat/data/signalr-model/chat_message.dart';
import 'package:template/features/chat/logic/chat_cubit.dart';
import 'package:template/features/chat/mock/mock_models.dart';
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/user-widget/user_image.dart';

class ChatArea extends StatelessWidget {
  const ChatArea({
    required this.messages,
    required this.status,
    super.key,
    this.user,
    this.currentTypistUsernames = const [],
    this.onLongPress,
    this.onTapDown,
  });

  final List<MessageModel> messages;
  final Status status;
  final UserModel? user;
  final List<String> currentTypistUsernames;
  final void Function(MessageModel)? onLongPress;
  final void Function(TapDownDetails)? onTapDown;

  @override
  Widget build(BuildContext context) {
    final indicatorText = formatTypingIndicator(currentTypistUsernames);
    return Container(
      color: const Color(0xFFFFFFFF), // Pure White for content focus
      child: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.message),
                  SizedBox(height: 20.h),
                  const Text('No Messages found for the selected room'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    reverse: true,
                    // itemCount: messages.length + (status.isFetching ? 1 : 0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // if (index < messages.length) {
                      //   final message = messages[messages.length - 1 - index];
                      //   return _ChatMessage(
                      //     username: message.username,
                      //     timestamp: message.timestamp,
                      //     content: message.content,
                      //   );
                      // } else {
                      //   if (status.isFetching) {
                      //     return Padding(
                      //       padding: EdgeInsets.only(bottom: 5.h),
                      //       child: Center(
                      //         child: SizedBox(
                      //           height: 30.h,
                      //           width: 30.h,
                      //           child: const CircularProgressIndicator(
                      //             color: Colors.grey,
                      //             backgroundColor: AppColor.primary,
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // }

                      final message = messages[messages.length - 1 - index];

                      // Get the timestamp of the previous message, if available
                      final previousTimestamp =
                          index > 0 ? messages[index - 1].timestamp : null;

                      // 1. Determine if a divider is needed before the current message
                      final needsDivider =
                          isNewDay(message.timestamp, previousTimestamp);

                      // 2. Build the list of widgets for this index

                      // final message = messages[messages.length - 1 - index];
                      return Column(
                        children: [
                          // if (needsDivider)
                          //   dateDividerWidget(
                          //     message.timestamp,
                          //   ),
                          _ChatMessage(
                            userId: message.userId,
                            username: message.username,
                            timestamp: message.timestamp,
                            content: message.content,
                            user: user,
                            isSending: message.isSending,
                            isFailed: message.isFailed,
                            onLongPress: () => onLongPress?.call(message),
                            onTapDown: onTapDown,
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
                      padding:
                          EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
                      child: Text(
                        indicatorText,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                if (status.isFetching)
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Center(
                      child: SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: const CircularProgressIndicator(
                          color: Colors.grey,
                          backgroundColor: AppColor.primary,
                        ),
                      ),
                    ),
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
      final otherText =
          othersCount == 1 ? '1 other user' : '$othersCount other users';
      baseString = '$firstName, $secondName & $otherText are typing...';
    }

    return baseString;
  }

  bool isNewDay(String currentTime, String? previousTime) {
    try {
      final currentTimestamp = DateTime.parse(currentTime);
      final previousTimestamp =
          previousTime != null ? DateTime.tryParse(previousTime) : null;

      if (previousTimestamp == null) {
        return true; // Always show a divider before the very first message
      }

      // Strip time component for comparison
      final currentDate = DateTime(
          currentTimestamp.year, currentTimestamp.month, currentTimestamp.day);
      final previousDate = DateTime(previousTimestamp.year,
          previousTimestamp.month, previousTimestamp.day);

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
    this.onLongPress,
    this.onTapDown,
  });
  final String userId;
  final String username;
  final String timestamp;
  final String content;
  final UserModel? user;
  final bool isSending;
  final bool isFailed;
  final void Function()? onLongPress;
  final void Function(TapDownDetails)? onTapDown;

  @override
  Widget build(BuildContext context) {
    final isBot = username.contains('AI');

    final userColor = getColorForUser(userId);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
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
              backgroundColor: isBot
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFDCDDE1),
              child: Text(username[0].toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isBot ? Colors.white : userColor)),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    // splashColor: Colors.grey.shade200,
                    // highlightColor: AppColor.primaryFaint,
                    onLongPress: onLongPress,
                    onTapDown: onTapDown,

                    // padding: EdgeInsets.zero,
                    // visualDensity:
                    //     const VisualDensity(horizontal: -4, vertical: -4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                color: isBot
                                    ? Theme.of(context).primaryColor
                                    : userColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatTimestamp(timestamp),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.w),
                          child: Text(
                            content,
                            style: TextStyle(
                                color: Colors.grey.shade800, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (user != null && user?.id == userId)
                  Positioned(
                    bottom: 2,
                    right: 5,
                    child: Icon(
                      isSending
                          ? Icons.schedule
                          : isFailed
                              ? Icons.error
                              : Icons.check,
                      size: 17,
                      color: Colors.grey.shade400,
                    ),
                  ),
              ],
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
    try {
      final timestamp = DateTime.parse('${timestampString}Z').toLocal();

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
  });

  final void Function(String)? onSubmitted;
  final String? selectedChannelId;
  final void Function(String)? onTextChange;
  final TextEditingController controller;

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

  // void _submitMessage() {
  //   final text = _controller.text.trim();
  //   if (text.isNotEmpty) {
  //     widget.onSubmitted?.call(text);
  //     _controller.clear();
  //     widget.onTextChange?.call('');
  //   }
  // }

  void _submitMessage() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
      widget.controller.clear();
      widget.onTextChange?.call('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 7),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              onPressed: () {},
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: AppColor.primaryLight2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 0.2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: '# Message',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                filled: true,
                fillColor: AppColor.primaryLight2,
                suffixIcon: Padding(
                  padding: EdgeInsets.all(5.r),
                  child: IconButton(
                    splashColor: Colors.white38,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                      size: 25,
                      color: AppColor.primary,
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                ),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
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
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 10),
            child: IconButton(
              icon: Icon(
                widget.controller.text.isEmpty ? Icons.mic : Icons.send,
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
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
