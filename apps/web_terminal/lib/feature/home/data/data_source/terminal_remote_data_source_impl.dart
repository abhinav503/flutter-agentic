import 'dart:convert';

import 'package:core/core/network/http_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:web_terminal/constants/api_constants.dart';
import '../models/terminal_message_model.dart';
import 'terminal_remote_data_source.dart';

/// Not `const` (unlike the request/response data sources) — a shell is a duplex
/// connection, so this holds the live [WebSocketChannel] that
/// [sendInput]/[resize]/[disconnect] act on.
class TerminalRemoteDataSourceImpl implements TerminalRemoteDataSource {
  TerminalRemoteDataSourceImpl();

  WebSocketChannel? _channel;

  @override
  Stream<TerminalMessageModel> connect() async* {
    await disconnect(); // ensure a clean slate on reconnect

    final config = await _resolveConfig();
    final channel = WebSocketChannel.connect(Uri.parse(config.wsUrl));
    _channel = channel;
    await channel.ready;

    yield* channel.stream.map((raw) {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      return TerminalMessageModel.fromJson(json);
    });
  }

  @override
  void sendInput(String data) =>
      _channel?.sink.add(jsonEncode({'type': 'input', 'data': data}));

  @override
  void resize(int cols, int rows) => _channel?.sink
      .add(jsonEncode({'type': 'resize', 'cols': cols, 'rows': rows}));

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  // `/config.json` from the serving origin first, then the default bridge
  // address (dev fallback).
  Future<({String wsUrl})> _resolveConfig() async {
    final candidates = <String>{
      if (Uri.base.scheme.startsWith('http')) Uri.base.origin,
      ApiConstants.defaultBridgeOrigin,
    };

    Object? lastError;
    for (final origin in candidates) {
      try {
        final response = await HttpService.instance
            .get<Map<String, dynamic>>('$origin${ApiConstants.configPath}');
        final body = response.data!;
        final wsPort = body['wsPort'] as int;
        final token = body['token'] as String;
        final base = Uri.parse(origin);
        final wsScheme = base.scheme == 'https' ? 'wss' : 'ws';
        final wsUrl =
            '$wsScheme://${base.host}:$wsPort${ApiConstants.wsPath}?token=$token';
        return (wsUrl: wsUrl);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Could not reach the local terminal bridge. $lastError');
  }
}
