// channel_list.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/features/chat/data/models/room_model.dart';
import 'package:template/features/chat/data/signalr-model/room.dart';
import 'package:template/features/chat/logic/chat_cubit.dart';
import 'package:template/features/chat/mock/mock_models.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({
    this.selectedChannelId,
    required this.myRooms,
    super.key,
    this.onTapChannel,
  });
  final String? selectedChannelId;
  final List<RoomMain> myRooms;
  final void Function(String)? onTapChannel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor, // EFEFEF
      child: Column(
        children: [
          // Server Name Header
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .scaffoldBackgroundColor, // F7F8FA (Lighter header for focus)
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mevtech Project',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
              ],
            ),
          ),

          // Channels
          _ChannelCategory(
              name: myRooms.isNotEmpty
                  ? 'AVAILABLE CHANNELS'
                  : 'NO CHANNEL FOUND'),
          Expanded(
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8),
                itemCount: myRooms.length,
                itemBuilder: (context, index) {
                  final myRoom = myRooms[index];
                  return _ChannelItem(
                    icon: Icons.tag,
                    name: myRoom.name,
                    isSelected: myRoom.id == selectedChannelId,
                    onTap: () => onTapChannel?.call(myRoom.id),
                  );
                }),
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
                  child:
                      const Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Developer',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text('#1234',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Icon(Icons.mic, color: Colors.grey.shade700, size: 20),
                const SizedBox(width: 8),
                Icon(Icons.settings, color: Colors.grey.shade700, size: 20),
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
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ChannelItem extends StatelessWidget {
  const _ChannelItem({
    required this.icon,
    required this.name,
    this.isSelected = false,
    this.isVoice = false,
    this.onTap,
  });
  final IconData icon;
  final String name;
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
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(icon,
            color: isSelected ? accentColor : Colors.grey.shade600, size: 20),
        title: Text(
          name,
          style: TextStyle(
            color: isSelected ? accentColor : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
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
