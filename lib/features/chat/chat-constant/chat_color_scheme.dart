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
