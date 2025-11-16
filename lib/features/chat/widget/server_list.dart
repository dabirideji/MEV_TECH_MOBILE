// server_list.dart

import 'package:flutter/material.dart';
import 'package:template/features/chat/data/models/room_model.dart';
import 'package:template/features/chat/data/signalr-model/room.dart';
import 'package:template/features/chat/mock/mock_models.dart';

class ServerList extends StatefulWidget {
  const ServerList({
    required this.myRooms,
    this.selectedChannelId,
    super.key,
    this.onTapServer,
    this.onAddBtnClick,
    this.onPersonalRoomClick,
  });
  final String? selectedChannelId;
  final List<RoomMain> myRooms;

  final void Function(String)? onTapServer;
  final void Function()? onAddBtnClick;
  final void Function()? onPersonalRoomClick;
  // isPersonalRoom

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  String? selectedId;

  static const String messageId = 'message';
  static const String exploreId = 'explore';

  void selectServer(String id) {
    setState(() {
      selectedId = id;
    });
  }

  String getFirstLetter(String name) {
    for (var i = 0; i < name.length; i++) {
      final char = name[i];
      if (RegExp('[a-zA-Z]').hasMatch(char)) {
        return char.toUpperCase();
      }
    }
    return 'NA'; // Fallback if no letter is found (customize as needed, e.g., return '' or '?')
  }

  @override
  void initState() {
    selectServer(widget.selectedChannelId ?? messageId);
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // F7F8FA
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _ServerIcon(
            icon: Icons.chat,
            isSelected: selectedId == messageId,
            color: accentColor,
            onTap: () {
              selectServer(messageId);
              widget.onPersonalRoomClick?.call();
            },
          ),
          Divider(
              indent: 20, endIndent: 20, color: Theme.of(context).dividerColor),
          Expanded(
            child: ListView.builder(
                itemCount: widget.myRooms.length,
                itemBuilder: (context, index) {
                  final myRoom = widget.myRooms[index];

                  return _ServerIcon(
                    text: getFirstLetter(myRoom.name),
                    isSelected: selectedId == myRoom.id,
                    onTap: () {
                      selectServer(myRoom.id);
                      widget.onTapServer?.call(myRoom.id);
                    },
                    // () => widget.onTapServer?.call(myRoom.id),
                  );
                }),
          ),
          //  _ServerIcon(text: 'P', isSelected: isSelected),
          //     _ServerIcon(text: 'D', isSelected: isSelected),
          IconButton(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onPressed: widget.onAddBtnClick,
              icon: const _ServerIcon(icon: Icons.add, isSelected: false)),
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {},
          //   style: IconButton.styleFrom(
          //     shape: CircleBorder(
          //       side: BorderSide(color: Colors.black),
          //     ),
          //   ),
          // ),
          _ServerIcon(
            icon: Icons.explore,
            isSelected: selectedId == exploreId,
          ),
        ],
      ),
    );
  }
}

class _ServerIcon extends StatelessWidget {
  const _ServerIcon({
    required this.isSelected,
    this.icon,
    this.text,
    this.color,
    this.onTap,
  });
  final IconData? icon;
  final String? text;
  final bool isSelected;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Selection Indicator (Visible on dark background)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isSelected ? 40 : 10,
              width: 4,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor
                    : Colors.transparent, // Blue indicator
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Server Icon Button
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor
                      : const Color(0xFFDCDDE1), // Light grey background
                  borderRadius: BorderRadius.circular(isSelected ? 15 : 25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 4)
                        ]
                      : null,
                ),
                child: icon != null
                    ? Icon(icon,
                        color: isSelected ? Colors.white : Colors.black87,
                        size: 28)
                    : Center(
                        child: Text(
                          text!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
