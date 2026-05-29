import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatColor {
  static const Color lightPrimary =
      Color(0xFFF7F8FA); // Main background (soft white)
  static const Color lightSecondary =
      Color(0xFFEFEFEF); // Panel/Channel List background (light grey)
  static const Color lightTertiary =
      Color(0xFFFFFFFF); // Chat Area background (pure white)
  static const Color accentColor = Color(0xFF04654a);
  // static const Color accentColor =
  //     Color(0xFF4C75D8); // Professional Blue for accents/buttons
}

const _uuid = Uuid();

// Use this helper when creating a message locally
String generateTemporaryId() {
  // Generates a client-side unique ID (e.g., '12345678-abcd-...')
  return _uuid.v4();
}

Color getColorForUser(String userId) {
  if (userId.isEmpty) {
    return Colors.black; // Default color for empty ID
  }

  final userColorPalette = [
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  // 1. Get the integer hash code of the userId
  final hash = userId.hashCode;

  // 2. Ensure the hash is non-negative and wrap it using the modulo operator.
  // The result will be an index from 0 up to (userColorPalette.length - 1).
  final index = hash.abs() % userColorPalette.length;

  // 3. Return the color at that deterministic index.
  return userColorPalette[index];
}
