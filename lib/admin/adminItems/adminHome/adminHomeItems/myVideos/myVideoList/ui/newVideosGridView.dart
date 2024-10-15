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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
            title: Text('Enter video name'),
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Video name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, _nameController.text),
                child: Text('OK'),
              ),
            ],
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

        // Save metadata to Firestore
        await FirebaseFirestore.instance.collection('shorts').add({
          'videoName': videoName,
          'videoUrl': videoUrl,
          'thumbnailUrl': thumbnailUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          newVideos.add({
            'thumbnailUrl': thumbnailUrl,
            'videoName': videoName,
          });
        });
      } catch (e) {
        print('Error uploading image: $e');
      } finally {
        setState(() {
          isLoading = false;
          progress = 0.0;
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
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: SizedBox(
            height: heightDevice * 0.72,
            child: GridView.builder(
              itemCount: newVideos.length + 1,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                if (index == newVideos.length) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _uploadImage,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      children: [
                        Container(
                          height: heightDevice * 0.12,
                          width: widthDevice * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    newVideos[index]['thumbnailUrl']!),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Text(newVideos[index]['videoName']!,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          builder: (context, child) => Padding(
            padding:
                EdgeInsets.only(top: 100 - _animationController.value * 100),
            child: child,
          ),
        ),
        if (isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(value: progress),
                SizedBox(height: 20),
                Text(
                  'Uploading... ${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
