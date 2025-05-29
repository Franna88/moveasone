import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  List<Map<String, String>> newVideos = [];
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  double progress = 0.0;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF01B3B3);
  final Color accentColor = const Color(0xFF94FBAB);
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
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileName = pickedFile.name;
      File file = File(pickedFile.path);

      // Show dialog to enter video name
      String? videoName = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.title, color: secondaryColor),
                SizedBox(width: 8),
                Text(
                  'Name Your Video',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter a descriptive name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondaryColor, width: 2),
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: primaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _nameController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Save'),
              ),
            ],
          );
        },
      );

      if (videoName == null || videoName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please provide a name for your video'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
        return;
      }

      setState(() {
        isLoading = true;
        progress = 0.0;
      });

      try {
        // Upload video to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('userVideos/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        TaskSnapshot snapshot = await uploadTask;
        String videoUrl = await snapshot.ref.getDownloadURL();

        // Generate thumbnail
        final Directory tempDir = await getTemporaryDirectory();
        final String thumbnailPath = '${tempDir.path}/$fileName.jpg';
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: pickedFile.path,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.JPEG,
        );

        // Upload thumbnail to Firebase Storage
        File thumbnail = File(thumbnailFile!);
        Reference thumbnailStorageRef = FirebaseStorage.instance
            .ref()
            .child('userThumbnails/$fileName.jpg');
        UploadTask thumbnailUploadTask = thumbnailStorageRef.putFile(thumbnail);

        thumbnailUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress =
                0.5 + (snapshot.bytesTransferred / snapshot.totalBytes) * 0.5;
          });
        });

        TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
        String thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

        // Get current user UID
        final uid = FirebaseAuth.instance.currentUser!.uid;

        // Save metadata to Firestore in the user's document under userVideos list
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'userVideos': FieldValue.arrayUnion([
            {
              'videoName': videoName,
              'videoUrl': videoUrl,
              'thumbnailUrl': thumbnailUrl,
              'date': DateTime.now()
            }
          ])
        });

        setState(() {
          newVideos.add({
            'thumbnailUrl': thumbnailUrl,
            'videoName': videoName,
          });
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video uploaded successfully!'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading video. Please try again.'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
          progress = 0.0;
          _nameController.clear();
        });
      }
    }
  }

  // uploadImage function
  Future<void> uploadImage() async {
    return _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background color
        Container(
          color: backgroundColor,
        ),

        // Main content
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _animationController.value)),
              child: Opacity(
                opacity: _animationController.value,
                child: child,
              ),
            );
          },
          child: Container(
            height: heightDevice * 0.72,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Videos',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle,
                            color: secondaryColor, size: 28),
                        onPressed: _uploadImage,
                      ),
                    ],
                  ),
                ),

                // Instructions text
                if (newVideos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Tap the + button to upload a new video',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Video grid
                Expanded(
                  child: newVideos.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          itemCount: newVideos.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final delay = 0.2 + (index * 0.1);
                            final delayedAnimation = CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(delay.clamp(0.0, 1.0), 1.0,
                                  curve: Curves.easeOut),
                            );

                            return AnimatedBuilder(
                              animation: delayedAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      20 * (1 - delayedAnimation.value), 0),
                                  child: Opacity(
                                    opacity: delayedAnimation.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildVideoCard(
                                newVideos[index]['thumbnailUrl']!,
                                newVideos[index]['videoName']!,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),

        // Upload progress overlay
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(secondaryColor),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Uploading video...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
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
          ),

        // Add FAB for quick add action
        if (!isLoading)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _uploadImage,
              backgroundColor: secondaryColor,
              child: Icon(
                Icons.video_call,
                color: Colors.white,
              ),
              elevation: 4,
              tooltip: 'Upload new video',
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            size: 64,
            color: primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 24),
          Text(
            'No videos uploaded yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Upload your first video to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _uploadImage,
            icon: Icon(Icons.add),
            label: Text('Upload Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(String thumbnailUrl, String videoName) {
    return Card(
      elevation: 3,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: subtleColor,
          width: 1.5,
        ),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),

                // Success indicator
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // Gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Video title
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Upload complete',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
