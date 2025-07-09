import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/admin/adminItems/bookings/commonUi/bookingUserItem.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/myScedule.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class BookingsRequested extends StatefulWidget {
  const BookingsRequested({super.key});

  @override
  State<BookingsRequested> createState() => _BookingsRequestedState();
}

class _BookingsRequestedState extends State<BookingsRequested> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF6699CC),
        title: Text(
          'BOOKINGS REQUESTED',
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6699CC)),
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
                  Text(
                    'Error loading bookings',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending_actions, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'No pending bookings',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'New booking requests will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          // Sort bookings by createdAt in descending order (newest first)
          bookings.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aCreatedAt = aData['createdAt'];
            final bCreatedAt = bData['createdAt'];

            if (aCreatedAt == null && bCreatedAt == null) return 0;
            if (aCreatedAt == null) return 1;
            if (bCreatedAt == null) return -1;

            final aTimestamp = aCreatedAt as Timestamp;
            final bTimestamp = bCreatedAt as Timestamp;

            return bTimestamp.compareTo(aTimestamp); // Descending order
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final data = booking.data() as Map<String, dynamic>;

                    String userName =
                        data['userName'] ?? data['name'] ?? 'Unknown User';
                    String bookingDate = _formatBookingDate(data);
                    String timeStamp = _getRelativeTime(data['createdAt']);
                    String userPic = _getUserProfilePic(booking.id);

                    return BookingUserItem(
                      userPic: userPic,
                      userName: userName,
                      bookingDate: bookingDate,
                      timeStamp: timeStamp,
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: CommonButtons(
                  buttonText: 'My Schedule',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyScedule(),
                      ),
                    );
                  },
                  buttonColor: AdminColors().lightTeal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatBookingDate(Map<String, dynamic> data) {
    try {
      final date = data['selectedDate'] ?? '';
      final time = data['selectedTime'] ?? '';
      final duration = data['duration'] ?? '60';

      if (date.isNotEmpty && time.isNotEmpty) {
        final dateTime = DateTime.parse(date);
        final timeParts = time.split(' ');
        final timeOnly = timeParts[0];
        final period = timeParts[1];

        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];

        final formattedDate =
            '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';

        final startHour = int.parse(timeOnly.split(':')[0]);
        final startMinute = int.parse(timeOnly.split(':')[1]);
        final durationMinutes = int.parse(duration);

        final endDateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          period == 'PM' && startHour != 12 ? startHour + 12 : startHour,
          startMinute,
        ).add(Duration(minutes: durationMinutes));

        final endTime = _formatTime(endDateTime);

        return '$formattedDate ($time-$endTime)';
      }
    } catch (e) {
      print('Error formatting booking date: $e');
    }

    return 'Date not available';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }

  String _getRelativeTime(dynamic createdAt) {
    if (createdAt == null) return 'Unknown time';

    try {
      final Timestamp timestamp = createdAt as Timestamp;
      final DateTime bookingTime = timestamp.toDate();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(bookingTime);

      if (difference.inDays > 0) {
        if (difference.inDays == 1) {
          return 'Yesterday';
        } else if (difference.inDays < 7) {
          return '${difference.inDays} days ago';
        } else if (difference.inDays < 30) {
          final weeks = (difference.inDays / 7).floor();
          return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
        } else {
          final months = (difference.inDays / 30).floor();
          return months == 1 ? '1 month ago' : '$months months ago';
        }
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      print('Error calculating relative time: $e');
      return 'Unknown time';
    }
  }

  String _getUserProfilePic(String bookingId) {
    final images = [
      'images/comment1.jpg',
      'images/comment2.jpg',
      'images/comment3.jpg',
    ];

    final index = bookingId.hashCode % images.length;
    return images[index.abs()];
  }
}
