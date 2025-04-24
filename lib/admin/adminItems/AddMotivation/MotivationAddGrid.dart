import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class Motivationaddgrid extends StatefulWidget {
  const Motivationaddgrid({super.key});

  @override
  State<Motivationaddgrid> createState() => _MotivationaddgridState();

  static _MotivationaddgridState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MotivationaddgridState>();
  }
}

class _MotivationaddgridState extends State<Motivationaddgrid>
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

  void uploadImage() {
    _uploadImage();
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
              'New Motivation Video',
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
            FirebaseStorage.instance.ref().child('motivation/$fileName');
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
        await FirebaseFirestore.instance.collection('motivation').add({
          'videoName': videoName,
          'videoUrl': videoUrl,
          'thumbnailUrl': thumbnailUrl,
          'imageUrl': imageUrl,
          'timestamp': DateTime.now(),
        });

        setState(() {
          newVideos.add({
            'thumbnailUrl': thumbnailUrl,
            'videoName': videoName,
            'imageUrl': imageUrl ?? '',
          });
        });

        // Clear selected image
        setState(() {
          _selectedImage = null;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        print('Error uploading image: $e');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: newVideos.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    itemCount: newVideos.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      if (index == newVideos.length) {
                        return _buildAddVideoCard();
                      } else {
                        return _buildVideoCard(index);
                      }
                    },
                  ),
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
              Icons.videocam_outlined,
              size: 64,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Videos Added Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first motivation video to inspire others!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _uploadImage,
            icon: Icon(Icons.add),
            label: Text('ADD VIDEO'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVideoCard() {
    return InkWell(
      onTap: _uploadImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 32,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add New Video',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(int index) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with play icon overlay
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    newVideos[index]['imageUrl']!.isNotEmpty
                        ? newVideos[index]['imageUrl']!
                        : newVideos[index]['thumbnailUrl']!,
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
                // Play icon overlay
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Video title
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newVideos[index]['videoName']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  'Motivation Video',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeWidth: 4,
                ),
                SizedBox(height: 20),
                Text(
                  'Uploading... ${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (imageUploadProgress > 0.0 && imageUploadProgress < 1.0) ...[
                  SizedBox(height: 24),
                  LinearProgressIndicator(
                    value: imageUploadProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    backgroundColor: Colors.grey[200],
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Uploading Cover Image... ${(imageUploadProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
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
