// channel_list.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/extensions/string_extension.dart';
import 'package:mevtech/features/chat/data/models/room_model.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/chat/logic/chat_cubit.dart';
import 'package:mevtech/features/chat/mock/mock_models.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({
    this.selectedChannelId,
    required this.myRooms,
    super.key,
    this.onTapChannel,
    this.isSelected = false,
    this.isPersonalRoom = false,
    this.currentUser,
  });
  final String? selectedChannelId;
  final List<RoomMain> myRooms;
  final void Function(String)? onTapChannel;
  final bool isSelected;
  final bool isPersonalRoom;
  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    final rooms = isPersonalRoom
        ? myRooms.where((room) => room.isPrivate).toList()
        : myRooms.where((room) => !room.isPrivate).toList();

    return Container(
      color: Theme.of(context).cardColor, // EFEFEF
      child: Column(
        children: [
          // Server Name Header
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).scaffoldBackgroundColor, // F7F8FA (Lighter header for focus)
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat Community',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
              ],
            ),
          ),

          // Channels
          _ChannelCategory(
            name: rooms.isNotEmpty && isPersonalRoom
                ? 'Private Rooms (${rooms.length})'
                : rooms.isNotEmpty && !isPersonalRoom
                ? 'My ROOMS (${rooms.length})'
                : 'NO ROOM FOUND',
          ),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final myRoom = rooms[index];

                return _ChannelItem(
                  icon: Icons.tag,
                  name: myRoom.name,
                  memberCount: myRoom.settings.memberCount,
                  isSelected: selectedChannelId == myRoom.id,
                  onTap: () => onTapChannel?.call(myRoom.id),
                );
              },
            ),
          ),
          // User Panel
          Container(
            height: 50,
            color: const Color(0xFFDCDDE1), // Very light grey for contrast
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.username.capitalize() ?? 'NA',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentUser?.email ?? '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon(Icons.mic, color: Colors.grey.shade700, size: 20),
                // const SizedBox(width: 8),
                // Icon(Icons.settings, color: Colors.grey.shade700, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelCategory extends StatelessWidget {
  const _ChannelCategory({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        name,
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

class _ChannelItem extends StatelessWidget {
  const _ChannelItem({
    required this.icon,
    required this.name,
    required this.memberCount,
    this.isSelected = false,
    this.isVoice = false,
    this.onTap,
  });
  final IconData icon;
  final String name;
  final int memberCount;
  final bool isSelected;
  final bool isVoice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withOpacity(0.1)
            : Colors.transparent, // Light blue tint on selection
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: accentColor, width: 1.5) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent.shade700 : Colors.black45,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white60,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: isSelected ? accentColor : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          memberCount == 1
              ? '$memberCount member'
              : memberCount > 1
              ? '$memberCount members'
              : '',
          style: TextStyle(
            color: isSelected ? accentColor : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        trailing: isVoice
            ? Icon(Icons.people, color: Colors.grey.shade600, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }
}
