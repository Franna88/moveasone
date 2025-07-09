import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkConnectivityService {
  static final NetworkConnectivityService _instance =
      NetworkConnectivityService._internal();
  factory NetworkConnectivityService() => _instance;
  NetworkConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .asyncMap((results) => _checkInternetConnectivity(results));

  /// Check if device has internet connectivity
  Future<bool> get isConnected async {
    try {
      debugPrint('NetworkConnectivityService: Starting connectivity check...');
      final connectivityResults = await _connectivity.checkConnectivity();
      debugPrint(
          'NetworkConnectivityService: Connectivity results: $connectivityResults');
      return await _checkInternetConnectivity(connectivityResults);
    } catch (e) {
      debugPrint('NetworkConnectivityService: Error checking connectivity: $e');
      return false;
    }
  }

  /// Check actual internet connectivity (not just network connection)
  Future<bool> _checkInternetConnectivity(
      List<ConnectivityResult> results) async {
    debugPrint(
        'NetworkConnectivityService: Checking internet connectivity with results: $results');

    if (results.isEmpty ||
        results.every((result) => result == ConnectivityResult.none)) {
      debugPrint('NetworkConnectivityService: No network connection detected');
      _isConnected = false;
      return false;
    }

    try {
      debugPrint(
          'NetworkConnectivityService: Attempting to reach google.com...');
      // Try to reach a reliable server with shorter timeout
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint(
            'NetworkConnectivityService: Successfully reached google.com');
        _isConnected = true;
        return true;
      }
    } catch (e) {
      debugPrint('NetworkConnectivityService: Failed to reach google.com: $e');

      // Try alternative hosts as backup
      try {
        debugPrint(
            'NetworkConnectivityService: Trying alternative host (8.8.8.8)...');
        final result = await InternetAddress.lookup('8.8.8.8')
            .timeout(const Duration(seconds: 5));

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          debugPrint(
              'NetworkConnectivityService: Successfully reached 8.8.8.8');
          _isConnected = true;
          return true;
        }
      } catch (e2) {
        debugPrint('NetworkConnectivityService: Failed to reach 8.8.8.8: $e2');
      }
    }

    debugPrint('NetworkConnectivityService: No internet connectivity detected');
    _isConnected = false;
    return false;
  }

  /// Check if a specific URL is reachable
  Future<bool> isUrlReachable(String url) async {
    try {
      debugPrint(
          'NetworkConnectivityService: Checking URL reachability for: $url');
      final uri = Uri.parse(url);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5); // Reduced timeout
      client.idleTimeout = const Duration(seconds: 5);

      final request = await client.openUrl('HEAD', uri);
      request.headers.add('User-Agent', 'Flutter-MoveAsOne/1.0');

      final response = await request.close();
      final statusCode = response.statusCode;
      client.close();

      debugPrint('NetworkConnectivityService: URL check response: $statusCode');

      // Accept more status codes as "reachable"
      final isReachable = statusCode >= 200 && statusCode < 400;
      debugPrint(
          'NetworkConnectivityService: URL is ${isReachable ? 'reachable' : 'not reachable'}');

      return isReachable;
    } catch (e) {
      debugPrint('NetworkConnectivityService: URL check failed for $url: $e');
      return false;
    }
  }

  /// Get connectivity status message
  String getConnectivityStatusMessage() {
    return _isConnected
        ? 'Connected to internet'
        : 'No internet connection. Please check your network settings.';
  }

  /// Initialize connectivity monitoring
  void startMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _checkInternetConnectivity(results);
      },
    );
  }

  /// Stop monitoring connectivity
  void stopMonitoring() {
    _connectivitySubscription?.cancel();
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
  }
}
