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

      // Show dialog to enter video name and optional image
      String? videoName = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter video name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Video name'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
              ],
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
                                    newVideos[index]['imageUrl']!.isNotEmpty
                                        ? newVideos[index]['imageUrl']!
                                        : newVideos[index]['thumbnailUrl']!),
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
                if (imageUploadProgress > 0.0 && imageUploadProgress < 1.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(value: imageUploadProgress),
                        SizedBox(height: 10),
                        Text(
                          'Uploading Image... ${(imageUploadProgress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
