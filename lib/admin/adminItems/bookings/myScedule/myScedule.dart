import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/admin/adminItems/bookings/commonUi/bookingUserItem.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/ui/myDateTimePicker.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class MyScedule extends StatefulWidget {
  const MyScedule({super.key});

  @override
  State<MyScedule> createState() => _MySceduleState();
}

class _MySceduleState extends State<MyScedule> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'APPOINTMENT'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: MyDateTimePicker(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(4, 4), // Shadow position
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF6699CC)),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            SizedBox(height: 16),
                            Text(
                              'Error loading bookings',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.grey, size: 48),
                            SizedBox(height: 16),
                            Text(
                              'No bookings found',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Client bookings will appear here',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
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

                  return SingleChildScrollView(
                    child: Column(
                      children: bookings.map((booking) {
                        final data = booking.data() as Map<String, dynamic>;

                        // Get user name from booking data
                        String userName =
                            data['userName'] ?? data['name'] ?? 'Unknown User';

                        // Format booking date and time
                        String bookingDate = _formatBookingDate(data);

                        // Calculate relative timestamp
                        String timeStamp = _getRelativeTime(data['createdAt']);

                        // Get profile picture (default to first image for now)
                        String userPic = _getUserProfilePic(booking.id);

                        return BookingUserItem(
                          userPic: userPic,
                          userName: userName,
                          bookingDate: bookingDate,
                          timeStamp: timeStamp,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatBookingDate(Map<String, dynamic> data) {
    try {
      final date = data['selectedDate'] ?? '';
      final time = data['selectedTime'] ?? '';
      final duration = data['duration'] ?? '60';

      if (date.isNotEmpty && time.isNotEmpty) {
        // Parse the date and time
        final dateTime = DateTime.parse(date);
        final timeParts = time.split(' ');
        final timeOnly = timeParts[0];
        final period = timeParts[1];

        // Format the date
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

        // Calculate end time
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
    // For now, cycle through available images
    // In a real app, you'd fetch the user's actual profile picture
    final images = [
      'images/comment1.jpg',
      'images/comment2.jpg',
      'images/comment3.jpg',
    ];

    final index = bookingId.hashCode % images.length;
    return images[index.abs()];
  }
}
