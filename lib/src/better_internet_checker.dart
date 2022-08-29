import 'dart:async';

import 'package:better_internet_checker/src/better_internet_config.dart';
import 'package:http/http.dart' as http;

/// {@template better_internet_checker}
/// Internet checker that uses the gstatic.com domain to check for internet
/// {@endtemplate}
class BetterInternetChecker {
  /// {@macro better_internet_checker}

  factory BetterInternetChecker({
    BetterInternetConfig config = const BetterInternetConfig(),
  }) =>
      _instance ??= BetterInternetChecker._(
        config,
      );

  /// {@macro better_internet_checker}
  BetterInternetChecker._(this.config) {
    _init();
  }

  static BetterInternetChecker? _instance;

  /// The config
  final BetterInternetConfig config;

  /// The stream of connection status

  final _streamController = StreamController<ConnectionStatus>.broadcast();

  /// The stream of connection status

  var _currentStatus = ConnectionStatus.connected;

  late Timer _timer;

  /// Get method to return the stream from stream controller
  Stream<ConnectionStatus> get onConnectivityChanged => _streamController.stream;

  void _init() {
    _streamController
      ..onListen = _createTimer
      ..onCancel = () => _timer.cancel();
  }

  void _createTimer() {
    final interval = _currentStatus == ConnectionStatus.disconnected
        ? config.offlineInterval
        : config.onlineInterval;
    _timer = Timer.periodic(
      interval,
      (timer) async {
        if (!_streamController.hasListener) return;
        await _checkAndBroadcast();

        _timer.cancel();
        _createTimer();
      },
    );
  }

  /// Check for internet and broadcast the result
  Future<void> _checkAndBroadcast() async {
    final status = await hasConnection;
    _streamController.add(status);
  }

  /// send a request to the gstatic.com domain to check for internet
  Future<ConnectionStatus> get hasConnection async {
    try {
      final uri = Uri.parse(config.url);
      final response = await http.get(uri).timeout(
            config.timeout,
          );

      if (response.statusCode == config.httpSuccessCode) {
        return _currentStatus = ConnectionStatus.connected;
      }

      return _currentStatus = ConnectionStatus.disconnected;
    } catch (e) {
      return _currentStatus = ConnectionStatus.disconnected;
    }
  }

  /// Dispose the stream controller
  Future<void> dispose() async {
    await _streamController.close();
  }
}

/// The status of the connection
enum ConnectionStatus {
  /// The device is connected to the internet
  connected,

  /// The device is not connected to the internet
  disconnected,
}
