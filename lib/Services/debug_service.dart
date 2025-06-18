import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Log levels
enum LogLevel { debug, info, warning, error, critical }

class DebugService {
  static final DebugService _instance = DebugService._internal();
  factory DebugService() => _instance;
  DebugService._internal();

  // Debug configuration
  static const bool _isDebugMode = kDebugMode;
  static const bool _enableFirebaseLogging = true;
  static const bool _enablePerformanceLogging = true;
  static const bool _enableNetworkLogging = true;
  static const bool _enableUserActionLogging = true;

  // Performance tracking
  final Map<String, DateTime> _performanceStartTimes = {};
  final List<Map<String, dynamic>> _performanceLogs = [];

  // Error tracking
  final List<Map<String, dynamic>> _errorLogs = [];

  // User action tracking
  final List<Map<String, dynamic>> _userActionLogs = [];

  // Network request tracking
  final List<Map<String, dynamic>> _networkLogs = [];

  // Initialize debug service
  static Future<void> initialize() async {
    if (!_isDebugMode) return;

    DebugService().log('Debug Service initialized', LogLevel.info);

    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      DebugService().logError(
        'Flutter Error',
        details.exception,
        details.stack,
        additionalData: {
          'library': details.library,
          'context': details.context?.toString(),
        },
      );
    };
  }

  // Main logging method
  void log(
    String message,
    LogLevel level, {
    String? tag,
    Map<String, dynamic>? additionalData,
    bool forceLog = false,
  }) {
    if (!_isDebugMode && !forceLog) return;

    final timestamp = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss.SSS').format(timestamp);
    final logTag = tag ?? 'MAO_DEBUG';
    final levelString = level.toString().split('.').last.toUpperCase();

    // Console logging
    final logMessage = '[$formattedTime] [$levelString] [$logTag] $message';
    developer.log(logMessage, name: logTag, level: _getLogLevelValue(level));

    // Debug console output with colors (if supported)
    if (kDebugMode) {
      print('${_getColorCode(level)}$logMessage${_getResetCode()}');
    }

    // Store log for potential Firebase upload
    if (_enableFirebaseLogging) {
      _storeLogForFirebase(message, level, tag, additionalData, timestamp);
    }
  }

  // Error logging
  void logError(
    String title,
    dynamic error,
    StackTrace? stackTrace, {
    String? tag,
    Map<String, dynamic>? additionalData,
  }) {
    final errorData = {
      'title': title,
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'additionalData': additionalData,
    };

    _errorLogs.add(errorData);

    log('ERROR: $title - $error', LogLevel.error,
        tag: tag, additionalData: errorData);

    // Upload critical errors immediately
    if (_enableFirebaseLogging) {
      _uploadErrorToFirebase(errorData);
    }
  }

  // Performance monitoring
  void startPerformanceTimer(String operationName) {
    if (!_enablePerformanceLogging) return;
    _performanceStartTimes[operationName] = DateTime.now();
    log('Started performance timer: $operationName', LogLevel.debug,
        tag: 'PERFORMANCE');
  }

  void endPerformanceTimer(String operationName,
      {Map<String, dynamic>? additionalData}) {
    if (!_enablePerformanceLogging) return;

    final startTime = _performanceStartTimes[operationName];
    if (startTime == null) {
      log('Performance timer not found: $operationName', LogLevel.warning,
          tag: 'PERFORMANCE');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    final performanceData = {
      'operation': operationName,
      'duration_ms': duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
      'additionalData': additionalData,
    };

    _performanceLogs.add(performanceData);
    _performanceStartTimes.remove(operationName);

    log('Performance: $operationName took ${duration.inMilliseconds}ms',
        LogLevel.info,
        tag: 'PERFORMANCE', additionalData: performanceData);

    // Log slow operations
    if (duration.inMilliseconds > 1000) {
      log('SLOW OPERATION: $operationName took ${duration.inMilliseconds}ms',
          LogLevel.warning,
          tag: 'PERFORMANCE');
    }
  }

  // User action logging
  void logUserAction(
    String action, {
    String? screen,
    Map<String, dynamic>? parameters,
  }) {
    if (!_enableUserActionLogging) return;

    final actionData = {
      'action': action,
      'screen': screen,
      'parameters': parameters,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    };

    _userActionLogs.add(actionData);
    log('User Action: $action${screen != null ? ' on $screen' : ''}',
        LogLevel.info,
        tag: 'USER_ACTION', additionalData: actionData);
  }

  // Network request logging
  void logNetworkRequest(
    String method,
    String url, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? responseData,
    String? error,
  }) {
    if (!_enableNetworkLogging) return;

    final networkData = {
      'method': method,
      'url': url,
      'statusCode': statusCode,
      'duration_ms': duration?.inMilliseconds,
      'requestData': requestData,
      'responseData': responseData,
      'error': error,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _networkLogs.add(networkData);

    final statusText = statusCode != null ? ' ($statusCode)' : '';
    final durationText =
        duration != null ? ' in ${duration.inMilliseconds}ms' : '';
    log('Network: $method $url$statusText$durationText', LogLevel.info,
        tag: 'NETWORK', additionalData: networkData);

    if (error != null) {
      log('Network Error: $method $url - $error', LogLevel.error,
          tag: 'NETWORK');
    }
  }

  // Firebase-specific logging
  void logFirebaseOperation(
    String operation, {
    String? collection,
    String? documentId,
    bool success = true,
    String? error,
    Duration? duration,
  }) {
    final fbData = {
      'operation': operation,
      'collection': collection,
      'documentId': documentId,
      'success': success,
      'error': error,
      'duration_ms': duration?.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    };

    final message =
        'Firebase $operation${collection != null ? ' on $collection' : ''}${success ? ' SUCCESS' : ' FAILED'}';
    log(message, success ? LogLevel.info : LogLevel.error,
        tag: 'FIREBASE', additionalData: fbData);
  }

  // Widget lifecycle logging
  void logWidgetLifecycle(String widgetName, String lifecycle) {
    log('Widget $widgetName: $lifecycle', LogLevel.debug,
        tag: 'WIDGET_LIFECYCLE');
  }

  // Navigation logging
  void logNavigation(String fromScreen, String toScreen,
      {Map<String, dynamic>? parameters}) {
    logUserAction('navigate',
        screen: fromScreen,
        parameters: {'to': toScreen, 'parameters': parameters});
  }

  // Debug utilities
  void printDebugInfo() {
    if (!_isDebugMode) return;

    log('=== DEBUG INFO ===', LogLevel.info, tag: 'DEBUG_INFO');
    log('Performance logs: ${_performanceLogs.length}', LogLevel.info,
        tag: 'DEBUG_INFO');
    log('Error logs: ${_errorLogs.length}', LogLevel.info, tag: 'DEBUG_INFO');
    log('User action logs: ${_userActionLogs.length}', LogLevel.info,
        tag: 'DEBUG_INFO');
    log('Network logs: ${_networkLogs.length}', LogLevel.info,
        tag: 'DEBUG_INFO');
    log('Active performance timers: ${_performanceStartTimes.length}',
        LogLevel.info,
        tag: 'DEBUG_INFO');
  }

  // Get device info for debugging
  Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'isDebugMode': kDebugMode,
      'isProfileMode': kProfileMode,
      'isReleaseMode': kReleaseMode,
    };
  }

  // Export logs for debugging
  Map<String, dynamic> exportLogs() {
    return {
      'deviceInfo': getDeviceInfo(),
      'performanceLogs': _performanceLogs,
      'errorLogs': _errorLogs,
      'userActionLogs': _userActionLogs,
      'networkLogs': _networkLogs,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  // Clear logs
  void clearLogs() {
    _performanceLogs.clear();
    _errorLogs.clear();
    _userActionLogs.clear();
    _networkLogs.clear();
    _performanceStartTimes.clear();
    log('All logs cleared', LogLevel.info, tag: 'DEBUG_SERVICE');
  }

  // Private helper methods
  int _getLogLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  String _getColorCode(LogLevel level) {
    if (!kDebugMode) return '';
    switch (level) {
      case LogLevel.debug:
        return '\x1B[36m'; // Cyan
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.critical:
        return '\x1B[35m'; // Magenta
    }
  }

  String _getResetCode() => kDebugMode ? '\x1B[0m' : '';

  void _storeLogForFirebase(String message, LogLevel level, String? tag,
      Map<String, dynamic>? additionalData, DateTime timestamp) {
    // Store logs for batch upload to Firebase (implementation depends on requirements)
    // This could be implemented to periodically upload logs to Firestore
  }

  Future<void> _uploadErrorToFirebase(Map<String, dynamic> errorData) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseFirestore.instance
            .collection('debug_logs')
            .doc('errors')
            .collection('error_logs')
            .add(errorData);
      }
    } catch (e) {
      developer.log('Failed to upload error to Firebase: $e',
          name: 'DEBUG_SERVICE');
    }
  }
}

// Debug widget wrapper for performance monitoring
class DebugWidgetWrapper extends StatefulWidget {
  final Widget child;
  final String widgetName;

  const DebugWidgetWrapper({
    Key? key,
    required this.child,
    required this.widgetName,
  }) : super(key: key);

  @override
  State<DebugWidgetWrapper> createState() => _DebugWidgetWrapperState();
}

class _DebugWidgetWrapperState extends State<DebugWidgetWrapper> {
  @override
  void initState() {
    super.initState();
    DebugService().logWidgetLifecycle(widget.widgetName, 'initState');
  }

  @override
  void dispose() {
    DebugService().logWidgetLifecycle(widget.widgetName, 'dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugService().logWidgetLifecycle(widget.widgetName, 'build');
    return widget.child;
  }
}

// Extension for easy debugging
extension DebugExtension on Widget {
  Widget debugWrap(String widgetName) {
    return DebugWidgetWrapper(
      widgetName: widgetName,
      child: this,
    );
  }
}
