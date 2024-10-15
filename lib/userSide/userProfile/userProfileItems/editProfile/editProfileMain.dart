import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/mySwitchButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/userProfile/UserProfile.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsColors.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsWidget.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/mainContentContainer.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/ui/profileEditTextField.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/ui/saveButton.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/ui/smallEditTextField.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/ui/userImageStack.dart';

class EditProfileMain extends StatefulWidget {
  const EditProfileMain({super.key});

  @override
  State<EditProfileMain> createState() => _EditProfileMainState();
}

class _EditProfileMainState extends State<EditProfileMain> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _profilePicUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        _nameController.text = doc.get('name');
        _bioController.text = doc.get('bio');
        _websiteController.text = doc.get('website');
        _genderController.text = doc.get('gender');
        _ageController.text = doc.get('age');
        _heightController.text = doc.get('height');
        _weightController.text = doc.get('weight');
        _profilePicUrl = doc.get('profilePic');
      });
      print('User details fetched successfully.');
    } else {
      print('No user details found.');
    }
  }

  Future<void> saveUserDetails() async {
    print('saveUserDetails called.');

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Capture the data from the text controllers
    final name = _nameController.text;
    final bio = _bioController.text;
    final website = _websiteController.text;
    final gender = _genderController.text;
    final age = _ageController.text;
    final height = _heightController.text;
    final weight = _weightController.text;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'bio': bio,
        'website': website,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'profilePic': _profilePicUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      print('User details updated successfully.');
    } catch (e) {
      print('Failed to update user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      print('Image picked successfully.');
      await uploadImage(imageFile);
    } else {
      print('No image picked.');
    }
  }

  Future<void> uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pics/$uid.jpg');
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _profilePicUrl = downloadUrl;
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePic': _profilePicUrl,
      });

      print('Image uploaded and Firestore updated successfully.');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      print('Failed to upload image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        HeaderWidget(header: 'EDIT PROFILE'),
        Container(
          height: heightDevice * 0.88,
          width: widthDevice,
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserImageStack(
                  userPic: _profilePicUrl,
                  onpress: pickImage,
                  isLoading: _isLoading,
                ),

                ProfileEditTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                ProfileEditTextField(
                  controller: _bioController,
                  labelText: 'Bio',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                ProfileEditTextField(
                  controller: _websiteController,
                  labelText: 'Website',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: UiColors().teal,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnam',
                      ),
                    ),
                  ),
                ),
                ProfileEditTextField(
                  controller: _genderController,
                  labelText: 'Gender',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                ProfileEditTextField(
                  controller: _ageController,
                  labelText: 'Age',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                ProfileEditTextField(
                  controller: _heightController,
                  labelText: 'Height',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                ProfileEditTextField(
                  controller: _weightController,
                  labelText: 'Weight',
                  fieldWidth: widthDevice,
                  onChanged: () {
                    //ADD LOGIC
                  },
                  textColor: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnam',
                      ),
                    ),
                  ),
                ),
                //WEIGHT LOSS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Loss',
                        style: TextStyle(
                          fontFamily: 'BeVietnam',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      MySwitchButton()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallEditTextField(
                      labelText: 'Ideal Weight',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallEditTextField(
                      labelText: 'Current Weight',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                  ],
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().green,
                    iconColor: Colors.white,
                    iconType: Icons.check,
                    borderColor: GoalsColors().green,
                    barColor: GoalsColors().green,
                    percentage: '100%',
                    goal: 'Weight Goal',
                    progressValue: 100,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                //WEIGHT TRAINING
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Training',
                        style: TextStyle(
                          fontFamily: 'BeVietnam',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      MySwitchButton()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallEditTextField(
                      labelText: 'Ideal Bicep',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallEditTextField(
                      labelText: 'Current Bicep',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                  ],
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().yellow,
                    iconColor: Colors.black,
                    iconType: Icons.priority_high,
                    borderColor: GoalsColors().yellow,
                    barColor: GoalsColors().yellow,
                    percentage: '50%',
                    goal: 'Arms Goal',
                    progressValue: 0.50,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // LEGS BUILD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Leg Build',
                        style: TextStyle(
                          fontFamily: 'BeVietnam',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      MySwitchButton()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallEditTextField(
                      labelText: 'Ideal Upper Leg',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallEditTextField(
                      labelText: 'Current Upper Leg',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                  ],
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: Colors.white,
                    iconColor: GoalsColors().blue,
                    iconType: Icons.circle,
                    borderColor: GoalsColors().blue,
                    barColor: GoalsColors().blue,
                    percentage: '30%',
                    goal: 'Legs Goal',
                    progressValue: 0.30,
                    iconSize: 11,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                //STRONG CORE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Strong Core',
                        style: TextStyle(
                          fontFamily: 'BeVietnam',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      MySwitchButton()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallEditTextField(
                      labelText: 'Ideal Waist',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallEditTextField(
                      labelText: 'Current Waist',
                      fieldWidth: widthDevice * 0.43,
                      onChanged: () {
                        //ADD LOGIC
                      },
                      textColor: Colors.black,
                      keyType: TextInputType.number,
                    ),
                  ],
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().red,
                    iconColor: Colors.white,
                    iconType: Icons.close,
                    borderColor: GoalsColors().red,
                    barColor: GoalsColors().red,
                    percentage: '10%',
                    goal: 'Waist Goal',
                    progressValue: 0.10,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SaveButton(
                  buttonText: 'Save',
                  onTap: () async {
                    await saveUserDetails();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfile()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
