import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/network_connectivity_service.dart';
import '../Services/enhanced_video_service.dart';

class VideoPlayerDiagnostic extends StatefulWidget {
  const VideoPlayerDiagnostic({Key? key}) : super(key: key);

  @override
  _VideoPlayerDiagnosticState createState() => _VideoPlayerDiagnosticState();
}

class _VideoPlayerDiagnosticState extends State<VideoPlayerDiagnostic> {
  final TextEditingController _urlController = TextEditingController();
  VideoPlayerController? _controller;
  String _status = 'Ready to test';
  bool _isLoading = false;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    // Pre-populate with the problematic URL for testing
    _urlController.text =
        'https://firebasestorage.googleapis.com/v0/b/moveasone-1e3e5.appspot.com/o/shorts%2F1000000306.mp4?alt=media&token=3c51a62f-d059-4076-a241-f319905669c5';
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toIso8601String()}: $message');
    });
    print('DIAGNOSTIC: $message');
  }

  Future<void> _testVideo() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _addLog('ERROR: No URL provided');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Testing enhanced video loading...';
      _logs.clear();
    });

    _addLog('=== ENHANCED VIDEO LOADING TEST ===');
    _addLog('Starting enhanced video test for: $url');

    try {
      // Use EnhancedVideoService
      final videoService = EnhancedVideoService();
      _addLog('Created EnhancedVideoService instance');

      final result = await videoService.loadVideo(
        videoUrl: url,
        timeout: const Duration(seconds: 30),
        maxRetries: 3,
        checkConnectivity: true,
      );

      _addLog('Enhanced video service completed');
      _addLog('Result state: ${result.state}');
      _addLog('Error message: ${result.errorMessage ?? 'None'}');

      if (result.state == VideoLoadState.loaded && result.controller != null) {
        _controller = result.controller!;
        _addLog('Enhanced video loaded successfully!');
        _addLog('Video duration: ${_controller!.value.duration}');
        _addLog('Video size: ${_controller!.value.size}');

        setState(() {
          _status = 'Enhanced video loaded successfully';
          _isLoading = false;
        });
      } else {
        _addLog('Enhanced video loading failed');
        setState(() {
          _status = 'Enhanced loading failed: ${result.errorMessage}';
          _isLoading = false;
        });
      }
    } catch (e) {
      _addLog('Enhanced video test exception: $e');
      setState(() {
        _status = 'Enhanced test failed with exception';
        _isLoading = false;
      });
    }
  }

  Future<void> _testBasicVideo() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _addLog('ERROR: No URL provided');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Testing basic video loading...';
      _logs.clear();
    });

    _addLog('=== BASIC VIDEO LOADING TEST ===');
    _addLog('Starting basic video test for: $url');

    try {
      // Dispose previous controller if exists
      if (_controller != null) {
        _addLog('Disposing previous controller');
        _controller!.dispose();
      }

      _addLog('Creating basic VideoPlayerController...');
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));

      _addLog('Initializing video player...');
      await _controller!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Basic video initialization timeout',
              const Duration(seconds: 30));
        },
      );

      _addLog('Basic video loaded successfully!');
      _addLog('Video duration: ${_controller!.value.duration}');
      _addLog('Video size: ${_controller!.value.size}');

      setState(() {
        _status = 'Basic video loaded successfully';
        _isLoading = false;
      });
    } catch (e) {
      _addLog('Basic video loading failed: $e');
      _addLog('Error type: ${e.runtimeType}');

      if (e is PlatformException) {
        _addLog('Platform Exception Code: ${e.code}');
        _addLog('Platform Exception Message: ${e.message}');
      }

      setState(() {
        _status = 'Basic video loading failed';
        _isLoading = false;
      });
    }
  }

  Future<void> _testNetworkConnectivity() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing network connectivity...';
      _logs.clear();
    });

    _addLog('=== NETWORK CONNECTIVITY TEST ===');

    try {
      final networkService = NetworkConnectivityService();

      _addLog('Testing basic connectivity...');
      final isConnected = await networkService.isConnected;
      _addLog('Basic connectivity result: $isConnected');

      if (_urlController.text.trim().isNotEmpty) {
        _addLog('Testing URL reachability...');
        final isUrlReachable =
            await networkService.isUrlReachable(_urlController.text.trim());
        _addLog('URL reachability result: $isUrlReachable');
      }

      setState(() {
        _status = isConnected ? 'Network test passed' : 'Network test failed';
        _isLoading = false;
      });
    } catch (e) {
      _addLog('Network test error: $e');
      setState(() {
        _status = 'Network test error';
        _isLoading = false;
      });
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _status = 'Logs cleared';
    });
  }

  Future<void> _loadFromFirestore() async {
    _addLog('Loading video URLs from Firestore...');

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('shorts').limit(5).get();

      _addLog('Found ${snapshot.docs.length} videos in Firestore');

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final videoUrl = data['videoUrl'] as String?;
        final videoName = data['videoName'] as String?;

        _addLog('Video: $videoName');
        _addLog('URL: $videoUrl');
        _addLog('---');
      }

      if (snapshot.docs.isNotEmpty) {
        final firstVideo = snapshot.docs.first.data();
        final firstUrl = firstVideo['videoUrl'] as String?;
        if (firstUrl != null) {
          _urlController.text = firstUrl;
          _addLog('Set first video URL for testing');
        }
      }
    } catch (e) {
      _addLog('Error loading from Firestore: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Diagnostic'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Video URL',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testVideo,
                    child: Text(_isLoading
                        ? 'Testing...'
                        : 'Test Enhanced Video Loading'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testBasicVideo,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: Text(
                        _isLoading ? 'Testing...' : 'Test Basic Video Loading'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _testNetworkConnectivity,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Test Network Only'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearLogs,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Clear Logs'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: $_status',
                    style: TextStyle(
                      color: _status.contains('Success') ||
                              _status.contains('loaded')
                          ? Colors.green
                          : _status.contains('Failed') ||
                                  _status.contains('Error')
                              ? Colors.red
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _logs.join('\n'),
                    style: TextStyle(
                      color: Colors.green[300],
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_status.contains('Failed') || _status.contains('Error'))
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Fix Suggestions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Check your internet connection'),
                    Text('• Verify the video URL is accessible'),
                    Text('• Try a different video URL'),
                    Text('• Restart the app'),
                    Text('• Check device storage space'),
                    SizedBox(height: 8),
                    Text(
                      'Debugging Tips:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red[700]),
                    ),
                    Text(
                        '• Check the logs above for detailed error information'),
                    Text(
                        '• Test "Network Only" to isolate connectivity issues'),
                    Text('• Compare Enhanced vs Basic loading results'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
