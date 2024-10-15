import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResources.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/Rachelle.dart';
import 'package:move_as_one/userSide/Home/Motivational/Motivational.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkout.dart';
import 'package:move_as_one/myutility.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late Future<Map<String, dynamic>> _headerInfoFuture;

  @override
  void initState() {
    super.initState();
    _headerInfoFuture = _loadHeaderInfo();
  }

  Future<Map<String, dynamic>> _loadHeaderInfo() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('updateHeader')
        .doc('headerInfo')
        .get();

    if (document.exists) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      print("Data fetched: $data");
      return {
        'headerText': data['headerText'] ?? 'You can be Great',
        'subtitleText': data['subtitleText'] ??
            'You have the power to decide to be great. Let’s start now!',
        'imageUrl': data['imageUrl'] ?? '',
      };
    } else {
      print("Document does not exist");
      return {
        'headerText': 'You can be Great',
        'subtitleText':
            'You have the power to decide to be great. Let’s start now!',
        'imageUrl': '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _headerInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text('Error loading header info'));
        } else if (!snapshot.hasData) {
          print("No data");
          return Center(child: Text('No header info available'));
        } else {
          final headerText = snapshot.data?['headerText'] ?? 'You can be Great';
          final subtitleText = snapshot.data?['subtitleText'] ??
              'You have the power to decide to be great. Let’s start now!';
          final imageUrl = snapshot.data?['imageUrl'] ?? '';
          print("Header Text: $headerText");
          print("Subtitle Text: $subtitleText");
          print("Image URL: $imageUrl");

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MyUtility(context).width,
                  height: MyUtility(context).height / 1.8,
                  decoration: BoxDecoration(
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage('images/bicepFlex.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MyUtility(context).height * 0.21,
                      ),
                      SizedBox(
                        width: MyUtility(context).width / 1.15,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            headerText,
                            style: TextStyle(
                              color: Color(0xFF006261),
                              fontSize: 44,
                              fontFamily: 'belight',
                              height: 0.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: SizedBox(
                          width: MyUtility(context).width / 1.15,
                          child: Text(
                            subtitleText,
                            style: TextStyle(
                              color: /*Color(0xA5006261)*/
                                  Color.fromARGB(255, 116, 235, 217),
                              fontSize: 16,
                              fontFamily: 'Be Vietnam',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MyUtility(context).width / 1.15,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: MyUtility(context).width * 0.5,
                            height: MyUtility(context).height * 0.06,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: ShapeDecoration(
                              color: Color(0xFF006261),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Let’s Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'belight',
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Rachelle(),
                YourWorkouts(),
                Motivational(),
                AdditionalResources(),
              ],
            ),
          );
        }
      },
    );
  }
}
