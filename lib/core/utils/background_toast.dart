import 'package:flutter/material.dart';

void showCustomToast({
  required BuildContext context,
  required Widget child,
  Duration duration = const Duration(seconds: 2),
  double bottomOffset = 100,
  AlignmentGeometry alignment = Alignment.bottomCenter,
}) {
  // final overlay = Overlay.of(context);
  final overlay = Navigator.of(context).overlay!;
  final overlayEntry = OverlayEntry(
    builder: (_) => Align(
      alignment: alignment,
      child: Padding(
        padding: alignment == Alignment.bottomCenter
            ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15)
            : alignment == Alignment.topCenter
            ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10)
            : const EdgeInsets.only(bottom: 0),
        child: Material(color: Colors.transparent, child: child),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future<void>.delayed(duration).then((_) => overlayEntry.remove());
}
