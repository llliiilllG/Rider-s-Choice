import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:injectable/injectable.dart';
import '../storage/local_storage.dart';

@injectable
class WebSocketService {
  WebSocketChannel? _channel;
  final LocalStorage _localStorage;
  final StreamController<WebSocketMessage> _messageController = StreamController<WebSocketMessage>.broadcast();
  final StreamController<ConnectionStatus> _statusController = StreamController<ConnectionStatus>.broadcast();
  
  Stream<WebSocketMessage> get messageStream => _messageController.stream;
  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  WebSocketService(this._localStorage);

  // Connect to WebSocket server
  Future<void> connect() async {
    if (_isConnecting || _channel != null) return;
    
    _isConnecting = true;
    _statusController.add(ConnectionStatus.connecting);

    try {
      final token = await _localStorage.getString('token');
      final uri = Uri.parse('ws://localhost:3000/ws?token=${token ?? ''}');
      
      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      _isConnecting = false;
      _reconnectAttempts = 0;
      _statusController.add(ConnectionStatus.connected);
      
      // Send initial connection message
      sendMessage(WebSocketMessage(
        type: 'connection',
        data: {'status': 'connected'},
      ));
      
    } catch (e) {
      _isConnecting = false;
      _statusController.add(ConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  // Disconnect from WebSocket server
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _statusController.add(ConnectionStatus.disconnected);
  }

  // Send message to server
  void sendMessage(WebSocketMessage message) {
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode(message.toJson()));
      } catch (e) {
        print('Error sending WebSocket message: $e');
      }
    }
  }

  // Handle incoming messages
  void _handleMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      final message = WebSocketMessage.fromJson(json);
      _messageController.add(message);
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  // Handle WebSocket errors
  void _handleError(error) {
    print('WebSocket error: $error');
    _statusController.add(ConnectionStatus.error);
    _scheduleReconnect();
  }

  // Handle WebSocket disconnection
  void _handleDisconnect() {
    _statusController.add(ConnectionStatus.disconnected);
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  // Schedule reconnection attempt
  void _scheduleReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      connect();
    });
  }

  // Send bike view event
  void sendBikeView(String bikeId) {
    sendMessage(WebSocketMessage(
      type: 'bike_view',
      data: {'bikeId': bikeId},
    ));
  }

  // Send add to cart event
  void sendAddToCart(String bikeId, int quantity) {
    sendMessage(WebSocketMessage(
      type: 'add_to_cart',
      data: {'bikeId': bikeId, 'quantity': quantity},
    ));
  }

  // Send remove from cart event
  void sendRemoveFromCart(String bikeId) {
    sendMessage(WebSocketMessage(
      type: 'remove_from_cart',
      data: {'bikeId': bikeId},
    ));
  }

  // Send wishlist toggle event
  void sendWishlistToggle(String bikeId, bool added) {
    sendMessage(WebSocketMessage(
      type: 'wishlist_toggle',
      data: {'bikeId': bikeId, 'added': added},
    ));
  }

  // Send order status update request
  void requestOrderStatus(String orderId) {
    sendMessage(WebSocketMessage(
      type: 'order_status',
      data: {'orderId': orderId},
    ));
  }

  // Send real-time chat message
  void sendChatMessage(String message) {
    sendMessage(WebSocketMessage(
      type: 'chat_message',
      data: {'message': message},
    ));
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _statusController.close();
  }
}

// WebSocket message model
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// Connection status enum
enum ConnectionStatus {
  connecting,
  connected,
  disconnected,
  error,
} 