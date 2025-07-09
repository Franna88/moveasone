import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/video_models.dart';
import 'services/video_upload_service.dart';
import 'widgets/enhanced_upload_dialog.dart';

class Useraddgridview extends StatefulWidget {
  const Useraddgridview({super.key});

  @override
  State<Useraddgridview> createState() => _UseraddgridviewState();

  static _UseraddgridviewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_UseraddgridviewState>();
  }
}

class _UseraddgridviewState extends State<Useraddgridview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ImagePicker _picker = ImagePicker();
  final VideoUploadService _uploadService = VideoUploadService();

  List<UserVideo> userVideos = [];
  bool isLoading = false;
  double progress = 0.0;
  String progressText = '';

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF7FB2DE);
  final Color accentColor = const Color(0xFFA3E1DB);
  final Color subtleColor = const Color(0xFFE5F9E0);
  final Color backgroundColor = const Color(0xFFF8FFFA);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectAndUploadVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File videoFile = File(pickedFile.path);

    // Validate file size (100MB limit)
    final fileSize = await videoFile.length();
    const maxSize = 100 * 1024 * 1024; // 100MB

    if (fileSize > maxSize) {
      _showErrorDialog(
          'File too large', 'Please select a video smaller than 100MB');
      return;
    }

    // Show enhanced upload dialog
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnhancedUploadDialog(
        onUpload: (videoName, videoType, workoutType, description, tags) {
          _uploadVideo(
              videoFile, videoName, videoType, workoutType, description, tags);
        },
      ),
    );
  }

  Future<void> _uploadVideo(
    File videoFile,
    String videoName,
    VideoType videoType,
    WorkoutType workoutType,
    String description,
    List<String> tags,
  ) async {
    setState(() {
      isLoading = true;
      progress = 0.0;
      progressText = 'Preparing upload...';
    });

    try {
      final userVideo = await _uploadService.uploadUserVideo(
        videoFile: videoFile,
        videoName: videoName,
        videoType: videoType,
        workoutType: workoutType,
        description: description,
        tags: tags,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              this.progress = progress;
              if (progress < 0.3) {
                progressText = 'Processing video...';
              } else if (progress < 0.8) {
                progressText = 'Uploading video...';
              } else if (progress < 0.9) {
                progressText = 'Uploading thumbnail...';
              } else {
                progressText = 'Finalizing...';
              }
            });
          }
        },
      );

      setState(() {
        userVideos.add(userVideo);
      });

      _showSuccessMessage('Video uploaded successfully!');
    } catch (e) {
      _showErrorDialog(
          'Upload Failed', 'Failed to upload video: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
        progress = 0.0;
        progressText = '';
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400]),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // uploadImage function for backward compatibility
  Future<void> uploadImage() async {
    return _selectAndUploadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor,
                  Colors.white,
                  subtleColor.withOpacity(0.3),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with enhanced styling
                  _buildHeader(),

                  SizedBox(height: 24),

                  // Quick stats
                  _buildQuickStats(),

                  SizedBox(height: 24),

                  // Video grid
                  Expanded(
                    child: userVideos.isEmpty
                        ? _buildEmptyState()
                        : _buildVideoGrid(),
                  ),
                ],
              ),
            ),
          ),
          builder: (context, child) => FadeTransition(
            opacity: _animationController,
            child: child,
          ),
        ),

        // Enhanced upload progress overlay
        if (isLoading) _buildProgressOverlay(),

        // Enhanced FAB (only show when there are videos)
        if (!isLoading && userVideos.isNotEmpty) _buildFloatingActionButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Videos',
              style: TextStyle(
                color: primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Share your fitness journey',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.fitness_center,
            color: primaryColor,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
              'Videos', userVideos.length.toString(), Icons.videocam),
          SizedBox(width: 24),
          _buildStatItem('Types', _getUniqueTypes().toString(), Icons.category),
          SizedBox(width: 24),
          _buildStatItem('Total Time', _formatTotalDuration(), Icons.timer),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: secondaryColor, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  int _getUniqueTypes() {
    return userVideos.map((v) => v.videoType).toSet().length;
  }

  String _formatTotalDuration() {
    final total = userVideos.fold<int>(0, (sum, video) => sum + video.duration);
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Widget _buildVideoGrid() {
    return GridView.builder(
      itemCount: userVideos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final video = userVideos[index];
        final delay = 0.2 + (index * 0.1);
        final delayedAnimation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay.clamp(0.0, 1.0), 1.0, curve: Curves.easeOut),
        );

        return AnimatedBuilder(
          animation: delayedAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - delayedAnimation.value), 0),
              child: Opacity(
                opacity: delayedAnimation.value,
                child: child,
              ),
            );
          },
          child: _buildVideoCard(video),
        );
      },
    );
  }

  Widget _buildVideoCard(UserVideo video) {
    return Card(
      elevation: 4,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                // Video type badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getVideoTypeColor(video.videoType),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getVideoTypeLabel(video.videoType),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Play button
                Center(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Video info
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.videoName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _getWorkoutTypeLabel(video.workoutType),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDuration(video.duration),
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getVideoTypeColor(VideoType type) {
    switch (type) {
      case VideoType.workout:
        return Colors.blue;
      case VideoType.progress:
        return Colors.green;
      case VideoType.formCheck:
        return Colors.orange;
      case VideoType.achievement:
        return Colors.purple;
      case VideoType.tutorial:
        return Colors.teal;
    }
  }

  String _getVideoTypeLabel(VideoType type) {
    switch (type) {
      case VideoType.workout:
        return 'Workout';
      case VideoType.progress:
        return 'Progress';
      case VideoType.formCheck:
        return 'Form';
      case VideoType.achievement:
        return 'Achievement';
      case VideoType.tutorial:
        return 'Tutorial';
    }
  }

  String _getWorkoutTypeLabel(WorkoutType type) {
    return type.name.toUpperCase();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildProgressOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                Text(
                  progressText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12),

                Text(
                  'Please wait while we process your video',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton.extended(
        onPressed: _selectAndUploadVideo,
        backgroundColor: primaryColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Video',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 6,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.video_library_outlined,
              size: 64,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 32),
          Text(
            'No videos uploaded yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Start documenting your fitness journey\nby uploading your first video',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _selectAndUploadVideo,
            icon: Icon(Icons.upload),
            label: Text('Upload Your First Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}
