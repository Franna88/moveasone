import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:move_as_one/config/admin_config.dart';
import 'package:move_as_one/services/admin_user_service.dart';

class AdminMembersList extends StatefulWidget {
  const AdminMembersList({super.key});

  @override
  State<AdminMembersList> createState() => _AdminMembersListState();
}

class _AdminMembersListState extends State<AdminMembersList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF94D8E0);
  final Color accentColor = const Color(0xFFEDCBA4);

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(
          header: 'MESSAGE A MEMBER',
          showBackButton: true,
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
        ),

        // Members list
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where('status', isEqualTo: 'user')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text('Error loading members'),
                      SizedBox(height: 8),
                      Text('${snapshot.error}',
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text('No members found'),
                    ],
                  ),
                ),
              );
            }

            var members = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name = (data['name'] ?? data['userName'] ?? '')
                  .toString()
                  .toLowerCase();
              final email = (data['email'] ?? '').toString().toLowerCase();

              return _searchQuery.isEmpty ||
                  name.contains(_searchQuery) ||
                  email.contains(_searchQuery);
            }).toList();

            if (members.isEmpty) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text('No members match your search'),
                    ],
                  ),
                ),
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final memberData = member.data() as Map<String, dynamic>;

                  return _buildMemberItem(
                    memberId: member.id,
                    memberName: memberData['name'] ??
                        memberData['userName'] ??
                        'Unknown Member',
                    memberEmail: memberData['email'] ?? '',
                    memberProfilePic: _getProfilePicture(memberData),
                    lastActive: memberData['lastActive'],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMemberItem({
    required String memberId,
    required String memberName,
    required String memberEmail,
    required String memberProfilePic,
    dynamic lastActive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              _startConversationWith(memberId, memberName, memberProfilePic),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 28,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  backgroundImage: memberProfilePic.startsWith('http')
                      ? NetworkImage(memberProfilePic)
                      : AssetImage(memberProfilePic) as ImageProvider,
                  child: memberProfilePic.isEmpty
                      ? Text(
                          memberName.isNotEmpty
                              ? memberName[0].toUpperCase()
                              : 'M',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 16),

                // Member details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (memberEmail.isNotEmpty)
                        Text(
                          memberEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getStatusColor(lastActive),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            _getStatusText(lastActive),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Message icon
                Icon(
                  Icons.chat_bubble_outline,
                  color: primaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(dynamic lastActive) {
    if (lastActive == null) return Colors.grey;

    try {
      final lastActiveTime = (lastActive as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(lastActiveTime);

      if (difference.inMinutes < 15) return Colors.green;
      if (difference.inHours < 24) return Colors.orange;
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  String _getStatusText(dynamic lastActive) {
    if (lastActive == null) return 'Status unknown';

    try {
      final lastActiveTime = (lastActive as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(lastActiveTime);

      if (difference.inMinutes < 15) return 'Active now';
      if (difference.inHours < 1) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return 'Inactive';
    } catch (e) {
      return 'Status unknown';
    }
  }

  // Safe method to get profile picture from user data
  String _getProfilePicture(Map<String, dynamic> userData) {
    try {
      // Check for various profile picture field names
      if (userData.containsKey('profilePic') &&
          userData['profilePic'] != null) {
        return userData['profilePic'].toString();
      }
      if (userData.containsKey('profileImage') &&
          userData['profileImage'] != null) {
        return userData['profileImage'].toString();
      }
      if (userData.containsKey('profile_pic') &&
          userData['profile_pic'] != null) {
        return userData['profile_pic'].toString();
      }
      if (userData.containsKey('profile_image') &&
          userData['profile_image'] != null) {
        return userData['profile_image'].toString();
      }

      // Return default avatar if no profile picture field found
      return 'images/Avatar1.jpg';
    } catch (e) {
      print('Error getting profile picture: $e');
      return 'images/Avatar1.jpg';
    }
  }

  void _startConversationWith(
      String memberId, String memberName, String memberProfilePic) {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Starting conversation with $memberName...'),
            ],
          ),
          backgroundColor: primaryColor,
          duration: Duration(seconds: 2),
        ),
      );

      // Test the message sending functionality first
      _testMessageSending(memberId, memberName);

      // Generate chat ID
      final adminUserId = AdminConfig.ADMIN_USER_ID;
      final chatId = (memberId.compareTo(adminUserId) > 0)
          ? '${memberId}_$adminUserId'
          : '${adminUserId}_$memberId';

      // Navigate to chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyChat(
            userName: memberName,
            userPic: memberProfilePic,
            userId: memberId,
            chatId: chatId,
          ),
        ),
      ).then((_) {
        // Hide loading indicator when chat loads
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting conversation: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Test function to verify message sending works
  void _testMessageSending(String memberId, String memberName) async {
    try {
      final adminUserId = AdminConfig.ADMIN_USER_ID;
      final timestamp = Timestamp.now();
      final testMessage =
          'Hello $memberName! This is a test message from admin.';

      print('=== TESTING MESSAGE SENDING ===');
      print('Admin ID: $adminUserId');
      print('Member ID: $memberId');
      print('Member Name: $memberName');

      // Check if admin user exists
      final adminDoc =
          await _firestore.collection('users').doc(adminUserId).get();
      print('Admin user exists: ${adminDoc.exists}');

      if (!adminDoc.exists) {
        print('Creating admin user...');
        await AdminUserService.ensureAdminUserExists();
      }

      // Test the message sending logic that would be used in bottomChatTextField
      await _testAdminToUserMessage(
          adminUserId, memberId, testMessage, timestamp);

      print('Message sending test completed successfully');

      // Show success message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Message system verified - ready to chat!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Message sending test failed: $e');

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Message system error: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Test the admin-to-user message flow
  Future<void> _testAdminToUserMessage(String adminUserId, String memberId,
      String message, Timestamp timestamp) async {
    // Update admin user's friendsList
    DocumentSnapshot adminDoc =
        await _firestore.collection('users').doc(adminUserId).get();
    List adminFriendsList = [];
    if (adminDoc.exists) {
      final adminData = adminDoc.data() as Map<String, dynamic>?;
      adminFriendsList = adminData?['friendsList'] as List<dynamic>? ?? [];
    }

    // Find or create the friend entry for the member in admin's list
    var adminFriendEntry = adminFriendsList.firstWhere(
      (friend) => friend['id'] == memberId,
      orElse: () => null,
    );

    if (adminFriendEntry == null) {
      adminFriendEntry = {
        'id': memberId,
        'status': 'friend',
        'messages': [],
      };
      adminFriendsList.add(adminFriendEntry);
    } else {
      if (adminFriendEntry['messages'] == null ||
          adminFriendEntry['messages'] is! List) {
        adminFriendEntry['messages'] = [];
      }
    }

    // Add the message to admin's friend's messages
    (adminFriendEntry['messages'] as List).add({
      'senderId': adminUserId,
      'receiverId': memberId,
      'message': message,
      'timestamp': timestamp,
    });

    // Update admin user's friendsList
    await _firestore
        .collection('users')
        .doc(adminUserId)
        .update({'friendsList': adminFriendsList});
    print('Updated admin friendsList');

    // Update member user's friendsList
    DocumentSnapshot memberDoc =
        await _firestore.collection('users').doc(memberId).get();
    List memberFriendsList = [];
    if (memberDoc.exists) {
      final memberData = memberDoc.data() as Map<String, dynamic>?;
      memberFriendsList = memberData?['friendsList'] as List<dynamic>? ?? [];
    }

    // Find or create the friend entry for the admin in member's list
    var memberFriendEntry = memberFriendsList.firstWhere(
      (friend) => friend['id'] == adminUserId,
      orElse: () => null,
    );

    if (memberFriendEntry == null) {
      memberFriendEntry = {
        'id': adminUserId,
        'status': 'friend',
        'messages': [],
      };
      memberFriendsList.add(memberFriendEntry);
    } else {
      if (memberFriendEntry['messages'] == null ||
          memberFriendEntry['messages'] is! List) {
        memberFriendEntry['messages'] = [];
      }
    }

    // Add the message to member's friend's messages
    (memberFriendEntry['messages'] as List).add({
      'senderId': adminUserId,
      'receiverId': memberId,
      'message': message,
      'timestamp': timestamp,
    });

    // Update member user's friendsList
    await _firestore
        .collection('users')
        .doc(memberId)
        .update({'friendsList': memberFriendsList});
    print('Updated member friendsList');

    // Verify the message was stored
    final updatedAdminDoc =
        await _firestore.collection('users').doc(adminUserId).get();
    final updatedMemberDoc =
        await _firestore.collection('users').doc(memberId).get();

    if (updatedAdminDoc.exists && updatedMemberDoc.exists) {
      final adminData = updatedAdminDoc.data() as Map<String, dynamic>;
      final memberData = updatedMemberDoc.data() as Map<String, dynamic>;

      final adminFriends = adminData['friendsList'] as List;
      final memberFriends = memberData['friendsList'] as List;

      print('Admin friends count: ${adminFriends.length}');
      print('Member friends count: ${memberFriends.length}');

      // Check if message exists in both lists
      final adminFriend = adminFriends.firstWhere((f) => f['id'] == memberId,
          orElse: () => null);
      final memberFriend = memberFriends
          .firstWhere((f) => f['id'] == adminUserId, orElse: () => null);

      if (adminFriend != null && memberFriend != null) {
        print(
            'Message count in admin list: ${adminFriend['messages']?.length ?? 0}');
        print(
            'Message count in member list: ${memberFriend['messages']?.length ?? 0}');
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
