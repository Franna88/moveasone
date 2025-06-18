# Debug System Documentation

## Overview

The Move as One app now includes a comprehensive debug system that provides logging, performance monitoring, error tracking, and debugging utilities. This system is only active in debug mode and is automatically disabled in release builds.

## Features

### 1. Debug Service (`lib/Services/debug_service.dart`)

The `DebugService` is a singleton service that handles all debugging functionality:

- **Logging**: Multiple log levels (debug, info, warning, error, critical)
- **Performance Monitoring**: Start/stop timers for operations
- **Error Tracking**: Automatic error logging with stack traces
- **User Action Tracking**: Log user interactions and navigation
- **Network Request Logging**: Track API calls and responses
- **Firebase Operation Logging**: Monitor Firestore operations
- **Widget Lifecycle Logging**: Track widget creation and disposal

### 2. Debug Panel (`lib/Services/debug_panel.dart`)

A floating debug panel that provides real-time access to debug information:

- **Collapsible Interface**: Minimizes to a bug icon when not in use
- **Tabbed Interface**: Organized into Logs, Performance, Errors, and Info tabs
- **Real-time Updates**: Shows live debugging information
- **Export Functionality**: Copy logs to clipboard
- **Clear Logs**: Reset all debugging data

### 3. Debug Overlay

The `DebugOverlay` widget wraps the entire app and adds the debug panel in debug mode only.

## Usage

### Basic Logging

```dart
import 'package:move_as_one/Services/debug_service.dart';

// Basic logging
DebugService().log('This is an info message', LogLevel.info);
DebugService().log('This is a warning', LogLevel.warning, tag: 'CUSTOM_TAG');

// Error logging
try {
  // Some operation
} catch (e, stackTrace) {
  DebugService().logError('Operation failed', e, stackTrace);
}
```

### Performance Monitoring

```dart
// Start a performance timer
DebugService().startPerformanceTimer('data_load');

// Your operation here
await loadData();

// End the timer
DebugService().endPerformanceTimer('data_load');
```

### User Action Tracking

```dart
// Log user actions
DebugService().logUserAction('button_tap', 
    screen: 'HomePage', 
    parameters: {'button_id': 'get_started'});

// Log navigation
DebugService().logNavigation('HomePage', 'LoginScreen');
```

### Firebase Operations

```dart
// Log Firebase operations
DebugService().logFirebaseOperation('read', 
    collection: 'users', 
    documentId: userId, 
    success: true);
```

### Widget Lifecycle

```dart
class MyWidget extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    DebugService().logWidgetLifecycle('MyWidget', 'initState');
  }

  @override
  void dispose() {
    DebugService().logWidgetLifecycle('MyWidget', 'dispose');
    super.dispose();
  }
}
```

## Debug Panel Usage

### Accessing the Debug Panel

1. The debug panel appears as a green bug icon in the top-right corner (debug mode only)
2. Tap the icon to expand the panel
3. Use the tabs to navigate between different types of information

### Panel Tabs

#### Logs Tab
- Shows user actions and network requests
- Color-coded by type (blue for user actions, orange for network)
- Sorted by timestamp (newest first)

#### Performance Tab
- Shows operation timings
- Color-coded by duration:
  - Green: < 500ms
  - Orange: 500ms - 1000ms
  - Red: > 1000ms

#### Errors Tab
- Shows all logged errors
- Includes error messages and timestamps
- Critical errors are automatically uploaded to Firebase

#### Info Tab
- Device and app information
- Debug actions (Print Info, Export Logs)
- Export functionality copies all logs to clipboard

## Implementation Details

### Files Modified

1. **`lib/main.dart`**: Added debug service initialization and debug overlay
2. **`lib/Services/UserState.dart`**: Added auth flow debugging
3. **`lib/Services/auth_services.dart`**: Added login/signup debugging
4. **`lib/HomePage.dart`**: Added home page interaction debugging
5. **`lib/userSide/LoginSighnUp/Login/Signin.dart`**: Added signin debugging
6. **`lib/userSide/Home/GetStarted.dart`**: Added shorts loading debugging

### New Files Created

1. **`lib/Services/debug_service.dart`**: Core debug service
2. **`lib/Services/debug_panel.dart`**: Debug UI panel
3. **`DEBUG_SYSTEM_README.md`**: This documentation

### Debug Configuration

The debug system is configured via constants in `debug_service.dart`:

```dart
static const bool _enableFirebaseLogging = true;
static const bool _enablePerformanceLogging = true;
static const bool _enableNetworkLogging = true;
static const bool _enableUserActionLogging = true;
```

## Debugging Workflow

### During Development

1. Run the app in debug mode
2. Use the debug panel to monitor real-time activity
3. Check performance timers for slow operations
4. Monitor error logs for issues
5. Export logs when needed for analysis

### Performance Optimization

1. Use performance timers around critical operations
2. Monitor the Performance tab for slow operations (>1000ms)
3. Optimize operations that consistently show high durations

### Error Debugging

1. All errors are automatically logged with stack traces
2. Critical errors are uploaded to Firebase for remote monitoring
3. Use the Errors tab to see recent issues

### User Behavior Analysis

1. User actions are logged with screen context and parameters
2. Navigation flow is tracked automatically
3. Use logs to understand user interaction patterns

## Best Practices

1. **Tag Your Logs**: Use meaningful tags for easier filtering
2. **Performance Timers**: Wrap expensive operations with timers
3. **Error Context**: Include relevant data when logging errors
4. **User Actions**: Log important user interactions with context
5. **Clean Up**: Use the clear logs function to reset during testing

## Troubleshooting

### Debug Panel Not Showing
- Ensure you're running in debug mode
- Check that `kDebugMode` is true
- Verify the debug overlay is properly wrapped around your app

### Logs Not Appearing
- Check debug configuration constants
- Ensure proper import of `debug_service.dart`
- Verify log calls are using correct syntax

### Performance Issues
- Monitor the Performance tab for slow operations
- Check for memory leaks in widget lifecycle logs
- Use performance timers to identify bottlenecks

## Security Notes

- Debug system is automatically disabled in release builds
- Sensitive data should not be logged in production
- Firebase error logging only occurs for authenticated users
- Debug panel UI is only compiled in debug mode

## Future Enhancements

Potential improvements to consider:

1. **Remote Debug Console**: Web-based debug interface
2. **Log Filtering**: Advanced filtering and search capabilities
3. **Performance Graphs**: Visual performance metrics
4. **Network Inspector**: Detailed network request/response viewer
5. **Crash Reporting**: Enhanced crash detection and reporting
6. **A/B Testing Integration**: Debug support for feature flags 