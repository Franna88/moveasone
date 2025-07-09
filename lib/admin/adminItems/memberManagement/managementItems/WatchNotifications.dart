import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_as_one/Services/motivation_service.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class WatchNotifications extends StatefulWidget {
  const WatchNotifications({super.key});

  @override
  State<WatchNotifications> createState() => _WatchNotificationsState();
}

class _WatchNotificationsState extends State<WatchNotifications> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return MainContainer(
      children: [
        HeaderWidget(header: 'WATCH LIST NOTIFICATIONS'),
        Container(
          width: widthDevice,
          height: heightDevice * 0.90,
          child: StreamBuilder<QuerySnapshot>(
            stream: MotivationService.getAdminNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No notifications available'));
              }

              // Mark all notifications as read
              _markAllAsRead(snapshot.data!.docs);

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var notification = snapshot.data!.docs[index];
                  var data = notification.data() as Map<String, dynamic>;

                  return _buildNotificationItem(
                    context,
                    notificationId: notification.id,
                    userId: data['userId'],
                    userName:
                        data['userName'] ?? data['name'] ?? 'Unknown User',
                    reason: data['reason'],
                    time: data['createdAt'] != null
                        ? (data['createdAt'] as Timestamp).toDate()
                        : DateTime.now(),
                    isRead: data['isRead'] ?? false,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String notificationId,
    required String userId,
    required String userName,
    required String reason,
    required DateTime time,
    required bool isRead,
  }) {
    return GestureDetector(
      onTap: () => _navigateToUserProfile(context, userId, userName),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Color(0xFFF8F2E5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Color(0xFFF39C12),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'User added to watch list',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM d, h:mm a').format(time),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blueGrey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () =>
                      _navigateToUserProfile(context, userId, userName),
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View Profile'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF006261),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            MyDivider(),
          ],
        ),
      ),
    );
  }

  void _navigateToUserProfile(
      BuildContext context, String userId, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberProfile(
          userId: userId,
          memberName: userName,
          memberImage: '',
          memberBio: '',
          memberWebsite: '',
        ),
      ),
    );
  }

  Future<void> _markAllAsRead(List<QueryDocumentSnapshot> notifications) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var notification in notifications) {
      final data = notification.data() as Map<String, dynamic>;
      if (!(data['isRead'] ?? false)) {
        batch.update(notification.reference, {'isRead': true});
      }
    }

    await batch.commit();
  }
}
