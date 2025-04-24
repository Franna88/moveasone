import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class NewVideosGridView extends StatefulWidget {
  const NewVideosGridView({super.key});

  @override
  State<NewVideosGridView> createState() => _NewVideosGridViewState();

  static _NewVideosGridViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NewVideosGridViewState>();
  }
}

class _NewVideosGridViewState extends State<NewVideosGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, String>> newVideos = [];
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  double progress = 0.0;
  File? _selectedImage;
  double imageUploadProgress = 0.0;

  // Modern color scheme
  final Color primaryColor = const Color(0xFF6A3EA1); // Purple
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color backgroundColor = const Color(0xFFF7F5FA); // Light purple tint

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileName = pickedFile.name;
      File file = File(pickedFile.path);

      // Show dialog to enter video name and optional image
      String? videoName = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'New Short Video',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter video title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: primaryColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Cover Image (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: secondaryColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add cover image',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _nameController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('SAVE'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            elevation: 5,
          );
        },
      );

      if (videoName == null || videoName.isEmpty) {
        print('No video name provided');
        return;
      }

      setState(() {
        isLoading = true;
        progress = 0.0;
        imageUploadProgress = 0.0;
      });

      try {
        // Upload video to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('shorts/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        TaskSnapshot snapshot = await uploadTask;
        String videoUrl = await snapshot.ref.getDownloadURL();

        // Debugging information
        print('Video uploaded: $videoUrl');

        // Generate thumbnail
        final Directory tempDir = await getTemporaryDirectory();
        final String thumbnailPath = '${tempDir.path}/$fileName.jpg';
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: pickedFile.path,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.JPEG,
        );

        // Debugging information
        if (thumbnailFile != null) {
          print('Thumbnail generated: $thumbnailFile');
        } else {
          print('Thumbnail generation failed');
        }

        // Upload thumbnail to Firebase Storage
        File thumbnail = File(thumbnailFile!);
        Reference thumbnailStorageRef =
            FirebaseStorage.instance.ref().child('thumbnails/$fileName.jpg');
        UploadTask thumbnailUploadTask = thumbnailStorageRef.putFile(thumbnail);

        thumbnailUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
        String thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

        // Debugging information
        print('Thumbnail uploaded: $thumbnailUrl');

        // Upload selected image if available
        String? imageUrl;
        if (_selectedImage != null) {
          Reference imageRef = FirebaseStorage.instance
              .ref()
              .child('covers/${_selectedImage!.path.split('/').last}');
          UploadTask imageUploadTask = imageRef.putFile(_selectedImage!);

          imageUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            setState(() {
              imageUploadProgress =
                  snapshot.bytesTransferred / snapshot.totalBytes;
            });
          });

          TaskSnapshot imageSnapshot = await imageUploadTask;
          imageUrl = await imageSnapshot.ref.getDownloadURL();
        }

        // Save metadata to Firestore
        await FirebaseFirestore.instance.collection('shorts').add({
          'videoName': videoName,
          'videoUrl': videoUrl,
          'thumbnailUrl': imageUrl ?? thumbnailUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          newVideos.add({
            'thumbnailUrl': imageUrl ?? thumbnailUrl,
            'videoName': videoName,
          });
          _selectedImage = null;
        });
      } catch (e) {
        print('Error uploading image: $e');
      } finally {
        setState(() {
          isLoading = false;
          progress = 0.0;
          imageUploadProgress = 0.0;
        });
      }
    } else {
      print('No video selected');
    }
  }

  // uploadImage function
  Future<void> uploadImage() async {
    return _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: newVideos.isEmpty ? _buildEmptyState() : _buildGrid(),
          ),
          builder: (context, child) => FadeTransition(
            opacity: _animationController,
            child: child,
          ),
        ),
        if (isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 64,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Add New Short Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap the button below to select a video',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _uploadImage,
            icon: Icon(Icons.add_circle),
            label: Text(
              'SELECT VIDEO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      itemCount: newVideos.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        if (index == newVideos.length) {
          return _buildAddButton();
        } else {
          return _buildVideoCard(
            thumbnailUrl: newVideos[index]['thumbnailUrl']!,
            videoName: newVideos[index]['videoName']!,
            index: index,
          );
        }
      },
    );
  }

  Widget _buildVideoCard({
    required String thumbnailUrl,
    required String videoName,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    thumbnailUrl,
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
                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Delete button in top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          newVideos.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Status indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: secondaryColor,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ready',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                videoName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: _uploadImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 32,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Video',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  value: progress,
                ),
                const SizedBox(height: 24),
                Text(
                  'Uploading... ${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                if (_selectedImage != null && imageUploadProgress > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Uploading cover image...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: imageUploadProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
