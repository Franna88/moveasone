import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/adminTextField.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class WriteAMessage extends StatefulWidget {
  const WriteAMessage({super.key});

  @override
  State<WriteAMessage> createState() => _WriteAMessageState();
}

class _WriteAMessageState extends State<WriteAMessage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  Uint8List? pickedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadLastSavedText();
  }

  Future<void> _loadLastSavedText() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('updateHeader')
        .doc('headerInfo')
        .get();

    if (document.exists) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      _titleController.text = data['headerText'] ?? '';
      _subtitleController.text = data['subtitleText'] ?? '';
      setState(() {
        imageUrl = data['imageUrl'] ?? '';
      });
    }
  }

  Future<void> onImageTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('updateHeader/${image.name}');
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    final newImageUrl = await imageRef.getDownloadURL();

    setState(() {
      pickedImage = imageBytes;
      imageUrl = newImageUrl;
    });

    // Save image URL to Firestore
    await FirebaseFirestore.instance
        .collection('updateHeader')
        .doc('headerInfo')
        .set({
      'imageUrl': newImageUrl,
    }, SetOptions(merge: true));
  }

  Future<void> saveHeaderInfo() async {
    await FirebaseFirestore.instance
        .collection('updateHeader')
        .doc('headerInfo')
        .set({
      'headerText': _titleController.text,
      'subtitleText': _subtitleController.text,
      if (imageUrl != null) 'imageUrl': imageUrl,
    }, SetOptions(merge: true));

    // Navigate back to WorkoutsFullLenght after saving
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WorkoutsFullLenght()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(header: 'WRITE A MESSAGE'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColumnHeader(header: 'New Photo'),
                    if (pickedImage != null)
                      Image.memory(pickedImage!, height: 100, width: 100)
                    else if (imageUrl != null && imageUrl!.isNotEmpty)
                      Image.network(imageUrl!, height: 100, width: 100)
                    else
                      Container(),
                    CommonButtons(
                      buttonText: 'Upload Photo',
                      onTap: onImageTapped,
                      buttonColor: AdminColors().lightBrown,
                    ),
                    ColumnHeader(header: 'Header Title'),
                    AdminTextField(
                      hintText: 'Title here',
                      controller: _titleController,
                      maxLength: 25,
                    ),
                    ColumnHeader(header: 'Sub Title'),
                    AdminTextField(
                      hintText: 'Sub Title here',
                      controller: _subtitleController,
                      maxLength: 60,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButtons(
                      buttonText: 'Save',
                      onTap: saveHeaderInfo,
                      buttonColor: UiColors().teal,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
