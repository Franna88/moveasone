import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class AllMemberList extends StatefulWidget {
  const AllMemberList({super.key});

  @override
  State<AllMemberList> createState() => _AllMemberListState();
}

class _AllMemberListState extends State<AllMemberList> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    // Stream that listens to changes in the users collection
    Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Container(
      width: widthDevice,
      height: heightDevice * 0.90,
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handling errors
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          // Showing loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Handling empty data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          // Mapping Firestore documents to WatchMemberModel
          var watchedMembers =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return WatchMemberModel(
              userId: document.id,
              memberName: data['name'] ?? 'Unknown Name',
              memberImage: data['profilePic'] ?? '',
              memberBio: data['bio'] ?? 'No bio available',
              memberWebsite: data['website'] ?? '',
            );
          }).toList();

          return ListView.builder(
            itemCount: watchedMembers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberProfile(
                        userId: watchedMembers[index].userId,
                        memberName: watchedMembers[index].memberName,
                        memberImage: watchedMembers[index].memberImage,
                        memberBio: watchedMembers[index].memberBio,
                        memberWebsite: watchedMembers[index].memberWebsite,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 25,
                              backgroundImage: watchedMembers[index]
                                      .memberImage
                                      .isNotEmpty
                                  ? NetworkImage(
                                      watchedMembers[index].memberImage)
                                  : AssetImage(
                                      'images/avatar1.png'), // Default image path
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              watchedMembers[index].memberName,
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                            Spacer(),
                            WatchButton()
                          ],
                        ),
                      ),
                      MyDivider()
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Model to represent a watched member
class WatchMemberModel {
  final String userId;
  final String memberName;
  final String memberImage;
  final String memberBio;
  final String memberWebsite;

  WatchMemberModel({
    required this.userId,
    required this.memberName,
    required this.memberImage,
    required this.memberBio,
    required this.memberWebsite,
  });
}
