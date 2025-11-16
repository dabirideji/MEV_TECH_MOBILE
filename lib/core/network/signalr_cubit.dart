import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/iretry_policy.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:template/core/network/notification_service.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/chat/data/repository/chat_repository.dart';
import 'package:template/features/user/data/models/transaction_model.dart';

enum ConnectionStatus {
  initial,
  connecting,
  connected,
  disconnected,
  error,
}

class SignalRState extends Equatable {
  const SignalRState({
    this.chatStatus = ConnectionStatus.initial,
    this.transactionStatus = ConnectionStatus.initial,
    this.notificationStatus = ConnectionStatus.initial,
    this.message,
  });
  final ConnectionStatus chatStatus;
  final ConnectionStatus transactionStatus;
  final ConnectionStatus notificationStatus;
  final String? message;

  @override
  List<Object?> get props =>
      [chatStatus, transactionStatus, notificationStatus, message];

  // A getter to determine the overall app status
  ConnectionStatus get overallStatus {
    if (chatStatus == ConnectionStatus.error ||
        transactionStatus == ConnectionStatus.error ||
        notificationStatus == ConnectionStatus.error) {
      return ConnectionStatus.error;
    }
    if (chatStatus == ConnectionStatus.connected &&
        transactionStatus == ConnectionStatus.connected &&
        notificationStatus == ConnectionStatus.connected) {
      return ConnectionStatus.connected;
    }
    if (chatStatus == ConnectionStatus.disconnected ||
        transactionStatus == ConnectionStatus.disconnected ||
        notificationStatus == ConnectionStatus.disconnected) {
      return ConnectionStatus.disconnected;
    }
    if (chatStatus == ConnectionStatus.connecting ||
        transactionStatus == ConnectionStatus.connecting ||
        notificationStatus == ConnectionStatus.connecting) {
      return ConnectionStatus.connecting;
    }
    return ConnectionStatus.initial;
  }

  SignalRState copyWith({
    ConnectionStatus? chatStatus,
    ConnectionStatus? transactionStatus,
    ConnectionStatus? notificationStatus,
    String? message,
  }) {
    return SignalRState(
      chatStatus: chatStatus ?? this.chatStatus,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      message: message ?? this.message,
    );
  }
}

// existing SignalR State and Cubit definitions

@lazySingleton
class SignalRCubit extends Cubit<SignalRState> {
  SignalRCubit(this.authCubit, this.notificationService, this.chatRepository)
      : super(const SignalRState());

  final AuthCubit authCubit;
  final NotificationService notificationService;
  final ChatRepository chatRepository;

  HubConnection? _chatHubConnection;
  HubConnection? _transactionHubConnection;
  HubConnection? _notificationHubConnection;

  bool get chatHubStatus =>
      chatHubConnection?.state == HubConnectionState.Connected;

  HubConnection? get chatHubConnection => _chatHubConnection;
  HubConnection? get transactionHubConnection => _transactionHubConnection;
  HubConnection? get notificationHubConnection => _notificationHubConnection;

  final String baseUrl = 'https://mev-tech-api.onrender.com';
  final Logger _hubLogger = Logger('SignalR.Hub');

  String? _disconnectReason;

  // ignore: use_setters_to_change_properties
  void setDisconnectReason(String reason) {
    _disconnectReason = reason;
  }

  // A method to start the connection with a new user ID and token
  Future<void> connect({required String userId, required String token}) async {
    // Check if we are already connected or connecting
    if (state.overallStatus == ConnectionStatus.connecting ||
        state.overallStatus == ConnectionStatus.connected) {
      // If the overall status is healthy, don't do anything
      return;
    }

    emit(const SignalRState(
      chatStatus: ConnectionStatus.connecting,
      transactionStatus: ConnectionStatus.connecting,
      notificationStatus: ConnectionStatus.connecting,
    ));

    try {
      // Attempt to start the connections

      // Connect to the chat hub only if it's not already connected
      if (_chatHubConnection?.state != HubConnectionState.Connected) {
        await _startChatHubConnection(
          hubName: 'chat',
          userId: userId,
          token: token,
        );
      } else {
        // If it's already connected, just update the state
        emit(state.copyWith(chatStatus: ConnectionStatus.connected));
      }

      // Connect to the notification hub only if it's not already connected
      if (_transactionHubConnection?.state != HubConnectionState.Connected) {
        await _startTransactionHubConnection(
          hubName: 'transactionNotification',
          userId: userId,
          token: token,
        );
      } else {
        // If it's already connected, just update the state
        emit(state.copyWith(transactionStatus: ConnectionStatus.connected));
      }

      // Connect to User notification hub only if it's not already connected
      if (_notificationHubConnection?.state != HubConnectionState.Connected) {
        await _startNotificationHubConnection(
          hubName: 'Notification',
          userId: userId,
          token: token,
        );
      } else {
        // If it's already connected, just update the state
        emit(state.copyWith(notificationStatus: ConnectionStatus.connected));
      }
    } catch (e) {
      _hubLogger.severe('💥 Failed to connect to SignalR hubs: $e');
    }
  }

  Future<void> _startTransactionHubConnection({
    required String hubName,
    required String userId,
    required String token,
  }) async {
    if (_transactionHubConnection?.state == HubConnectionState.Connected ||
        _transactionHubConnection?.state == HubConnectionState.Connecting) {
      _hubLogger.info(
          '🟡 $hubName hub is already connected or connecting. Skipping start.');
      return;
    }

    try {
      _transactionHubConnection =
          _buildHubConnection(hubName: hubName, userId: userId, token: token);

      if (_transactionHubConnection == null) return;

      // Listen for when the connection gets successfully reconnected
      _transactionHubConnection?.onreconnected(({connectionId}) {
        _hubLogger.info(
            '✅ Reconnected to $hubName hub. Connection ID: $connectionId');
        emit(state.copyWith(transactionStatus: ConnectionStatus.connected));
      });

      // Listen for when the client starts the reconnection process
      _transactionHubConnection?.onreconnecting(({error}) {
        _hubLogger.info('🟡 Reconnecting to $hubName hub...');
        emit(state.copyWith(
            transactionStatus: ConnectionStatus.connecting,
            message: 'Reconnecting...'));
      });

      // Listen for when the connection is closed
      _transactionHubConnection?.onclose(({error}) {
        _hubLogger.severe('🔴 $hubName hub closed. Reason: $error');

        String? disconnectionMessage;
        if (error != null) {
          disconnectionMessage = error.toString();
        } else if (_disconnectReason != null) {
          disconnectionMessage = _disconnectReason;
        }

        emit(state.copyWith(
          transactionStatus: ConnectionStatus.disconnected,
          message: disconnectionMessage,
        ));

        _disconnectReason = null;
      });

      _transactionHubConnection?.on('ReceiveConnectionId', (data) {});

      // Listen for 'transactionReceived' from the 'notification' hub
      _transactionHubConnection?.on('incomingTransaction', (data) {
        if (data != null && data.isNotEmpty) {
          final transData = data[0]! as Map<String, dynamic>;
          _hubLogger
            ..info("🔔 transaction received: ${transData['transaction']}")
            ..info("🔔 transaction received: ${transData['subscription']}");
          final transModel = Transaction.fromJson(
              transData['transaction'] as Map<String, dynamic>);
          final subModel = Subscription.fromJson(
              transData['subscription'] as Map<String, dynamic>);
          // log(transModel.toString());
          // log(subModel.toString());
          _hubLogger
              .info('🔔 Payment Successful\n Account updated to premium!');
          authCubit.showNotification(
              id: 1,
              title: '🔔 Payment Successful',
              body: 'Account updated to premium!');
        }
      });

      await _transactionHubConnection?.start();
      _hubLogger.info(
          '✅ Connected to $hubName hub. Connection ID: ${_transactionHubConnection?.connectionId}');
    } catch (e) {
      _hubLogger.severe('💥 Failed to connect to $hubName hub initially: $e');
      emit(state.copyWith(
          transactionStatus: ConnectionStatus.error, message: e.toString()));
    }
  }

  Future<void> _startNotificationHubConnection({
    required String hubName,
    required String userId,
    required String token,
  }) async {
    if (_notificationHubConnection?.state == HubConnectionState.Connected ||
        _notificationHubConnection?.state == HubConnectionState.Connecting) {
      _hubLogger.info(
          '🟡 $hubName hub is already connected or connecting. Skipping start.');
      return;
    }

    try {
      _notificationHubConnection =
          _buildHubConnection(hubName: hubName, userId: userId, token: token);

      if (_notificationHubConnection == null) return;

      // Listen for when the connection gets successfully reconnected
      _notificationHubConnection?.onreconnected(({connectionId}) {
        _hubLogger.info(
            '✅ Reconnected to $hubName hub. Connection ID: $connectionId');
        emit(state.copyWith(notificationStatus: ConnectionStatus.connected));
      });

      // Listen for when the client starts the reconnection process
      _notificationHubConnection?.onreconnecting(({error}) {
        _hubLogger.info('🟡 Reconnecting to $hubName hub...');
        emit(state.copyWith(
            notificationStatus: ConnectionStatus.connecting,
            message: 'Reconnecting...'));
      });

      // Listen for when the connection is closed

      _notificationHubConnection?.onclose(({error}) {
        _hubLogger.severe('🔴 $hubName hub closed. Reason: $error');

        String? disconnectionMessage;
        if (error != null) {
          disconnectionMessage = error.toString();
        } else if (_disconnectReason != null) {
          disconnectionMessage = _disconnectReason;
        }

        emit(state.copyWith(
          notificationStatus: ConnectionStatus.disconnected,
          message: disconnectionMessage,
        ));

        _disconnectReason = null;
      });

      // Register specific handlers

      _notificationHubConnection?.on('ReceiveConnectionId', (data) {
        if (data != null && data.isNotEmpty) {
          authCubit.fetchNotifications();
        }
      });

      // Listen for 'user general notification' from the 'notification' hub
      _notificationHubConnection?.on('incomingNotification', (data) {
        if (data != null && data.isNotEmpty) {
          authCubit.fetchNotifications(shouldShowNotif: true);
        }
      });

      await _notificationHubConnection?.start();
      _hubLogger.info(
          '✅ Connected to $hubName hub. Connection ID: ${_notificationHubConnection?.connectionId}');
    } catch (e) {
      _hubLogger.severe('💥 Failed to connect to $hubName hub initially: $e');
      emit(state.copyWith(
          notificationStatus: ConnectionStatus.error, message: e.toString()));
    }
  }

  Future<void> _startChatHubConnection({
    required String hubName,
    required String userId,
    required String token,
  }) async {
    if (_chatHubConnection?.state == HubConnectionState.Connected ||
        _chatHubConnection?.state == HubConnectionState.Connecting) {
      _hubLogger.info(
          '🟡 $hubName hub is already connected or connecting. Skipping start.');
      return;
    }

    try {
      _chatHubConnection =
          _buildHubConnection(hubName: hubName, userId: userId, token: token);

      if (_chatHubConnection == null) return;

      // Listen for when the connection gets successfully reconnected
      _chatHubConnection?.onreconnected(({connectionId}) {
        _hubLogger.info(
            '✅ Reconnected to $hubName hub. Connection ID: $connectionId');
        emit(state.copyWith(chatStatus: ConnectionStatus.connected));
      });

      // Listen for when the client starts the reconnection process
      _chatHubConnection?.onreconnecting(({error}) {
        _hubLogger.info('🟡 Reconnecting to $hubName hub...');
        emit(state.copyWith(
            chatStatus: ConnectionStatus.connecting,
            message: 'Reconnecting...'));
      });

      // Listen for when the connection is closed
      _chatHubConnection?.onclose(({error}) {
        _hubLogger.severe('🔴 $hubName hub closed. Reason: $error');
        String? disconnectionMessage;
        if (error != null) {
          disconnectionMessage = error.toString();
        } else if (_disconnectReason != null) {
          disconnectionMessage = _disconnectReason;
        }

        emit(state.copyWith(
          transactionStatus: ConnectionStatus.disconnected,
          message: disconnectionMessage,
        ));

        _disconnectReason = null;
      });

      // Register specific handlers
      // _chatHubConnection?.on('ReceiveConnectionId', (data) {});

      // // Listen for 'newMessage' from the 'chat' hub
      // _chatHubConnection?.on('newMessage', (message) {
      //   // The 'message' is a list of arguments from the server
      //   if (message != null && message.isNotEmpty) {
      //     final msgData = message[0]!
      //         as Map<String, dynamic>; // Assuming the message is a JSON object
      //     _hubLogger.info("💬 New chat message: ${msgData['text']}");
      //   }
      // });

      // _chatHubConnection?.on('MyRooms', (data) {
      //   log(data.toString());
      // });

      chatRepository.registerEventHandlers(_chatHubConnection!);

      await _chatHubConnection?.start();
      _hubLogger.info(
          '✅ Connected to $hubName hub. Connection ID: ${_chatHubConnection?.connectionId}');
    } catch (e) {
      _hubLogger.severe('💥 Failed to connect to $hubName hub initially: $e');
      emit(state.copyWith(
          chatStatus: ConnectionStatus.error, message: e.toString()));
    }
  }

  HubConnection _buildHubConnection({
    required String hubName,
    required String userId,
    required String token,
  }) {
    final hubUrl = Uri.parse('$baseUrl/hubs/$hubName?userId=$userId');
    return HubConnectionBuilder()
        .withUrl(
          hubUrl.toString(),
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
            requestTimeout: 5000,
            // transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect(reconnectPolicy: _CustomRetryPolicy(this))
        .configureLogging(_hubLogger)
        .build();
  }

  Future<void> disconnect() async {
    await _chatHubConnection?.stop();
    await _transactionHubConnection?.stop();
    await _notificationHubConnection?.stop();
    emit(const SignalRState(
      chatStatus: ConnectionStatus.disconnected,
      transactionStatus: ConnectionStatus.disconnected,
      notificationStatus: ConnectionStatus.disconnected,
    ));
  }
}

/// A custom retry policy to retry indefinitely after a short delay.
class _CustomRetryPolicy implements IRetryPolicy {
  _CustomRetryPolicy(this.signalRCubit);

  final SignalRCubit signalRCubit;

  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    final error = retryContext.retryReason.toString();
    final count = retryContext.previousRetryCount;

    if (error.contains('400')) {
      // throw Exception('SignalR connection closed due to 400 Bad Request.');
      signalRCubit.setDisconnectReason(error);
      return null;
    }

    if (error.contains('404') && count > 30) {
      signalRCubit.setDisconnectReason('404: Not Found');
      return null;
    }

    // if (error.contains('Failed host lookup') && count > 100) {
    //   // signalRCubit.setDisconnectReason('404: Not Found');
    //   return null;
    // }

    return 5000;
  }
}
