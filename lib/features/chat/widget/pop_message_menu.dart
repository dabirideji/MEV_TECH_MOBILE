import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopMessageMenu extends StatefulWidget {
  const PopMessageMenu({super.key});

  // List<PopupMenuEntry<Widget>> Function(BuildContext) itemBuilder;

  @override
  State<PopMessageMenu> createState() => _PopMessageMenuState();
}

class _PopMessageMenuState extends State<PopMessageMenu> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LongPressPopupMenu extends StatefulWidget {
  const LongPressPopupMenu({super.key});

  @override
  State<LongPressPopupMenu> createState() => _LongPressPopupMenuState();
}

class _LongPressPopupMenuState extends State<LongPressPopupMenu> {
  // Store the position of the tap down event.
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    // Get the global position of the tap.
    _tapPosition = details.globalPosition;
  }

  void _showContextMenu() {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
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
        const PopupMenuItem<String>(
          value: 'option1',
          child: Text('Option 1'),
        ),
        const PopupMenuItem<String>(
          value: 'option2',
          child: Text('Option 2'),
        ),
        const PopupMenuItem<String>(
          value: 'option3',
          child: Text('Option 3'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // Handle the selected value.
        debugPrint('Selected: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Use onTapDown to get the position before the onLongPress is triggered.
      onTapDown: _getTapPosition,
      onLongPress: _showContextMenu,
      child: Container(
        padding: const EdgeInsets.all(50),
        color: Colors.blue,
        child: const Text(
          'Long press me!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
