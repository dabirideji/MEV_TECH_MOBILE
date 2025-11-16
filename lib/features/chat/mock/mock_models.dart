// models.dart
import 'package:flutter/material.dart';

class Message {
  Message({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamp,
    this.isPersonal = false,
  });
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime timestamp;
  final bool isPersonal;
}

class Channel {
  Channel({
    required this.id,
    required this.name,
    required this.icon,
    required this.messages,
    this.isVoice = false,
  });
  final String id;
  final String name;
  final IconData icon;
  final bool isVoice;
  final List<Message> messages;
}

class MockUtility {
  // --- Demo Chat Data ---

  static List<Channel> channels = [
    Channel(
      id: 'general-chat',
      name: 'general-chat',
      icon: Icons.tag,
      messages: [
        Message(
          id: 'm1',
          userId: 'bot',
          username: 'AI Assistant',
          content:
              'Welcome to the Professional Project server! Please check out the #development channel for project updates.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Message(
          id: 'm2',
          userId: 'user_2',
          username: 'Client Lead',
          content: 'The light theme is clean and mature. Great work!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ],
    ),
    Channel(
      id: 'development',
      name: 'development',
      icon: Icons.tag,
      messages: [
        Message(
          id: 'm3',
          userId: 'user_1',
          username: 'Developer',
          content:
              'I\'ve finalized the component designs. Review pending in the Figma link.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ],
    ),
    Channel(
      id: 'default',
      name: 'Default-Channel',
      icon: Icons.tag,
      messages: [
        Message(
          id: 'd',
          userId: 'default_user',
          username: 'MevTech',
          content: 'This is default message Test. this is to prevent crash.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ],
    ),
  ];
}
