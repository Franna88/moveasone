import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/config/admin_config.dart';
import 'package:move_as_one/services/admin_user_service.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';

class AdminInboxPage extends StatefulWidget {
  const AdminInboxPage({super.key});

  @override
  State<AdminInboxPage> createState() => _AdminInboxPageState();
}

class _AdminInboxPageState extends State<AdminInboxPage> {
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF94D8E0);
  final Color accentColor = const Color(0xFFEDCBA4);

  void _runDiagnostics() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Running diagnostics...'),
          backgroundColor: primaryColor,
        ),
      );

      // Run simplified diagnostic
      await _runSimpleDiagnostic();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diagnostics completed! Check console for details.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error running diagnostics: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _runSimpleDiagnostic() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    print('=== MESSAGING DIAGNOSTIC ===');

    // Check current user
    final currentUser = auth.currentUser;
    print('Current User: ${currentUser?.uid} (${currentUser?.email})');

    if (currentUser != null) {
      // Check current user document
      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();
      print('Current User Doc Exists: ${userDoc.exists}');

      if (userDoc.exists) {
        final data = userDoc.data()!;
        print('Current User Status: ${data['status']}');
        print('Current User Name: ${data['name']}');
        print('Current User UserName: ${data['userName']}');
        print(
            'Current User Friends List Length: ${(data['friendsList'] as List?)?.length ?? 0}');

        // Check for admin in friends list
        final friendsList = data['friendsList'] as List? ?? [];
        final adminFriend = friendsList.firstWhere(
          (friend) => friend['id'] == AdminConfig.ADMIN_USER_ID,
          orElse: () => null,
        );

        print('Has Admin in Friends List: ${adminFriend != null}');
        if (adminFriend != null) {
          print('Messages with Admin: ${adminFriend['messages']?.length ?? 0}');
          if (adminFriend['messages'] != null &&
              adminFriend['messages'].isNotEmpty) {
            print('Last Message: ${adminFriend['messages'].last}');
          }
        }
      }
    }

    // Check admin user
    final adminDoc = await firestore
        .collection('users')
        .doc(AdminConfig.ADMIN_USER_ID)
        .get();
    print('Admin User Exists: ${adminDoc.exists}');

    if (adminDoc.exists) {
      final adminData = adminDoc.data()!;
      print('Admin Status: ${adminData['status']}');
      print('Admin UserName: ${adminData['userName']}');
      print(
          'Admin Friends List Length: ${(adminData['friendsList'] as List?)?.length ?? 0}');
    }

    // Test the query
    final usersSnapshot = await firestore
        .collection('users')
        .where('status', isEqualTo: 'user')
        .get();

    print('Users with status=user: ${usersSnapshot.docs.length}');

    int messagesFound = 0;
    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      final friendsList = data['friendsList'] as List? ?? [];
      final adminFriend = friendsList.firstWhere(
        (friend) => friend['id'] == AdminConfig.ADMIN_USER_ID,
        orElse: () => null,
      );

      if (adminFriend != null && adminFriend['messages'] != null) {
        final messages = adminFriend['messages'] as List;
        if (messages.isNotEmpty) {
          messagesFound++;
          print(
              'Found ${messages.length} messages from ${data['name'] ?? data['userName']}');
        }
      }
    }

    print('Total users with messages to admin: $messagesFound');
    print('=== END DIAGNOSTIC ===');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Admin Inbox',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report, color: Colors.white),
            onPressed: _runDiagnostics,
            tooltip: 'Run Diagnostics',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Messages'),
                  Tab(text: 'Bookings'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMessagesTab(),
                  _buildBookingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: AdminUserService.getAdminMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error loading messages', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.red)),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text('No messages yet', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('User messages will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          );
        }

        final adminMessages = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: adminMessages.length,
          itemBuilder: (context, index) {
            final messageData = adminMessages[index];
            final lastMessage = messageData['lastMessage'];

            return _buildMessageItem(
              userName: messageData['userName'] ??
                  messageData['name'] ??
                  'Unknown User',
              userEmail: messageData['userEmail'] ?? '',
              lastMessage: lastMessage['message'] ?? '',
              timestamp: lastMessage['timestamp'],
              userId: messageData['userId'] ?? '',
            );
          },
        );
      },
    );
  }

  Widget _buildBookingsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error loading bookings', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text('No pending bookings', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('New booking requests will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          );
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final data = booking.data() as Map<String, dynamic>;

            return _buildBookingItem(
              userName: data['userName'] ?? data['name'] ?? 'Unknown User',
              selectedDate: data['selectedDate'] ?? '',
              selectedTime: data['selectedTime'] ?? '',
              duration: data['duration'] ?? '60',
              createdAt: data['createdAt'],
            );
          },
        );
      },
    );
  }

  Widget _buildMessageItem({
    required String userName,
    required String userEmail,
    required String lastMessage,
    required dynamic timestamp,
    required String userId,
  }) {
    return GestureDetector(
      onTap: () {
        // Open chat with the user
        final chatId = (userId.compareTo(AdminConfig.ADMIN_USER_ID) > 0)
            ? '${userId}_${AdminConfig.ADMIN_USER_ID}'
            : '${AdminConfig.ADMIN_USER_ID}_$userId';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyChat(
              userName: userName,
              userPic: AdminConfig.ADMIN_PROFILE_PIC,
              userId: userId,
              chatId: chatId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 24,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimestamp(timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem({
    required String userName,
    required String selectedDate,
    required String selectedTime,
    required String duration,
    required dynamic createdAt,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: accentColor,
            radius: 24,
            child: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '$selectedTime ($duration min)',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(selectedDate),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Requested ${_formatTimestamp(createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    try {
      final Timestamp ts = timestamp as Timestamp;
      final DateTime dateTime = ts.toDate();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'No date';

      final DateTime date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
