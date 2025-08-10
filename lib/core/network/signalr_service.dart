// lib/signalr_service.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRService {
  final String baseUrl = 'https://mev-tech-api.onrender.com';
  final String userId = '3a3dfce3-ac47-4526-0218-08ddb94398df';
  final String targetUserId = '70c4e4f6-cba1-4635-5e92-08ddb88cec3b';

  HubConnection? _chatHubConnection;
  HubConnection? _notificationHubConnection;

  final Logger _logger = Logger('SignalR.Hub');

  // Method to initialize and connect to all hubs
  Future<void> initSignalR() async {
    // 1. Initialize Chat Hub
    _chatHubConnection = _buildHubConnection('chat');
    _registerChatHubHandlers();
    await _startHubConnection(_chatHubConnection, 'Chat');

    // 2. Initialize Notification Hub
    _notificationHubConnection = _buildHubConnection('notification');
    _registerNotificationHubHandlers();
    await _startHubConnection(_notificationHubConnection, 'Notification');
  }

  // Helper to build a HubConnection
  HubConnection _buildHubConnection(String hubName) {
    final hubUrl = Uri.parse('$baseUrl/hubs/$hubName?userId=$userId');

    return HubConnectionBuilder()
        .withUrl(
          hubUrl.toString(),
          options: HttpConnectionOptions(
            logger: _logger, // F
          ),
        )
        .withAutomaticReconnect() // Handles reconnects automatically!
        .configureLogging(_logger)
        .build();
  }

  // Helper to start a connection
  Future<void> _startHubConnection(
      HubConnection? hubConnection, String hubName) async {
    if (hubConnection == null) return;
    try {
      await hubConnection.start();

      _logger.info(
          '✅ Connected to $hubName hub. Connection ID: ${hubConnection.connectionId}');
    } catch (e) {
      _logger.info('💥 Could not connect to $hubName hub: $e');
    }
  }

  // ===== HANDLERS (Listening for server messages) =====

  void _registerChatHubHandlers() {
    // Listen for 'newMessage' from the 'chat' hub
    _chatHubConnection?.on('newMessage', (message) {
      // The 'message' is a list of arguments from the server
      if (message != null && message.isNotEmpty) {
        final msgData = message[0]!
            as Map<String, dynamic>; // Assuming the message is a JSON object
        _logger.info("💬 New chat message: ${msgData['text']}");
      }
    });
  }

  void _registerNotificationHubHandlers() {
    // Listen for 'notificationReceived' from the 'notification' hub
    _notificationHubConnection?.on('notificationReceived', (notification) {
      if (notification != null && notification.isNotEmpty) {
        final notifData = notification[0]! as Map<String, dynamic>;
        _logger.info("🔔 Notification received: ${notifData['title']}");
      }
    });

    // Listen for 'systemPing'
    _notificationHubConnection?.on('systemPing', (arguments) {
      _logger.info('✅ System ping received.');
    });
  }

  // ===== INVOKING (Sending messages to the server) =====

  Future<void> sendChatMessage(String targetUserId, String text) async {
    if (_chatHubConnection?.state == HubConnectionState.Connected) {
      // Call the 'SendMessage' method on the server's 'chat' hub
      await _chatHubConnection
          ?.invoke('SendMessage', args: <Object>[targetUserId, text]);
      _logger.info('🚀 Sent message to $targetUserId');
    } else {
      _logger.info('⚠️ Cannot send message. Chat hub is not connected.');
    }
  }
}

//  // Method to stop all connections when no longer needed
//   Future<void> dispose() async {
//     await _chatHubConnection?.stop();
//     await _notificationHubConnection?.stop();
//     log('🔴 SignalR connections stopped.');
//   }

// // In your main widget file, e.g., lib/main.dart

// // import 'signalr_service.dart'; // Import your new service

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SignalRService _signalRService = SignalRService();
  final String targetUserId = '70c4e4f6-cba1-4635-5e92-08ddb88cec3b';

  @override
  void initState() {
    super.initState();
    // Connect to SignalR when the widget is first created
    _signalRService.initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SignalR'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of sending a message
            _signalRService.sendChatMessage(
              targetUserId,
              'Hello from Austinero, this is a test message to kunle! 👋',
            );
          },
          child: const Text('Send Test Message'),
        ),
      ),
    );
  }
}

// incase there is a connection bug in the latest version
// this is a manual retry logic after downgrading

// import 'dart:async';
// import 'dart:math';
// import 'package:signalr_netcore/signalr_netcore.dart';

// class SignalRService {
//   HubConnection? _hubConnection;
//   final String serverUrl = "YOUR_SERVER_URL/hub"; // Replace this

//   Future<void> connect() async {
//     _hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

//     // Attach the onclose handler BEFORE starting the connection
//     _hubConnection!.onclose((error) {
//       log("🔌 Connection Closed: $error. Attempting to reconnect...");
//       _reconnect();
//     });

//     try {
//       await _hubConnection!.start();
//       log("✅ SignalR Connected!");
//     } catch (e) {
//       log("💥 Initial connection failed: $e");
//       _reconnect(); // Also try to reconnect if the very first attempt fails
//     }
//   }

//   // Our manual reconnect logic
//   Future<void> _reconnect() async {
//     // A list of delays for retries (in milliseconds)
//     // This is a simple backoff strategy: 2s, 5s, 10s, 20s
//     final retryDelays = [2000, 5000, 10000, 20000];

//     for (final delay in retryDelays) {
//       // Don't try to reconnect if the connection is already active
//       if (_hubConnection?.state == HubConnectionState.connected) {
//         return;
//       }
      
//       log("...retrying in ${delay / 1000} seconds");
//       await Future.delayed(Duration(milliseconds: delay));

//       try {
//         await _hubConnection!.start();
//         log("✅ Reconnection successful!");
//         return; // Exit the loop on success
//       } catch (e) {
//         log("💥 Reconnection attempt failed: $e");
//       }
//     }
    
//     log("💔 Could not reconnect after all retries.");
//   }

//   // Your other methods...
//   Future<void> dispose() async {
//     await _hubConnection?.stop();
//   }
// }