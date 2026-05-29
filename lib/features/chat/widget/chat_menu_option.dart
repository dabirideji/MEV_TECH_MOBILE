import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ChatMenuOption extends StatefulWidget {
  const ChatMenuOption({
    required this.child,
    super.key,
    this.onMessageEdit,
    this.onMessageDelete,
    this.onMessagecopy,
    this.onToggle,
    this.isMe = false,
  });

  final Widget child;
  final void Function()? onMessageEdit;
  final void Function()? onMessageDelete;
  final void Function()? onMessagecopy;
  final void Function(FPopoverController)? onToggle;
  final bool isMe;

  @override
  State<ChatMenuOption> createState() => _ChatMenuOptionState();
}

class _ChatMenuOptionState extends State<ChatMenuOption>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowing =
        _controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward;
    return FPopoverMenu(
      control: .managed(controller: _controller),
      autofocus: true,

      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      menu: [
        FItemGroup(
          style: (style) => style.copyWith(spacing: 10),
          children: [
            if (widget.isMe)
              FItem(
                style: (style) =>
                    style.copyWith(margin: const EdgeInsets.only(bottom: 10)),
                prefix: const Icon(FIcons.squarePen),
                title: Text(
                  'Edit',
                  style: context.theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w400,
                    color: context.theme.colors.foreground,
                    height: 1,
                  ),
                ),
                // onPress: onMessageEdit,
                onPress: () {
                  _controller.hide();
                  widget.onMessageEdit?.call();
                },
              ),
            if (widget.isMe)
              FItem(
                style: (style) =>
                    style.copyWith(margin: const EdgeInsets.only(bottom: 10)),
                prefix: Icon(
                  FIcons.trash2,
                  color: context.theme.colors.destructive,
                ),
                title: Text(
                  'Delete',
                  style: context.theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w400,
                    color: context.theme.colors.foreground,
                    height: 1,
                  ),
                ),
                // onPress: onMessageDelete,
                onPress: () {
                  _controller.hide();
                  widget.onMessageDelete?.call();
                },
              ),

            FItem(
              style: (style) =>
                  style.copyWith(margin: const EdgeInsets.only(bottom: 10)),
              prefix: Icon(FIcons.copy, color: Colors.blue.shade600),
              title: Text(
                'Copy',
                style: context.theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.theme.colors.foreground,
                  height: 1,
                ),
              ),
              // onPress: onMessagecopy,
              onPress: () {
                _controller.hide();
                widget.onMessagecopy?.call();
              },
            ),
            FItem(
              prefix: Transform.scale(
                scale: 1.2,
                child: const Icon(FIcons.x, color: Colors.deepOrangeAccent),
              ),
              title: Text(
                'Cancel',
                style: context.theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.theme.colors.foreground,
                  height: 1,
                ),
              ),

              onPress: () {
                _controller.hide();
              },
            ),
          ],
        ),
      ],
      builder: (_, controller, _) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () {
          _controller.toggle();
        },
        onTap: () {
          _controller.hide();
        },
        // child: widget.child,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // 3. Apply the highlight style
          decoration: BoxDecoration(
            color: isShowing
                ? context.theme.colors.primary.withAlpha(30)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
