import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/myutility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedDuration = '60 minutes';

  final List<String> durations = [
    '30 minutes',
    '60 minutes',
    '90 minutes',
    '120 minutes',
  ];

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: heightDevice,
          width: widthDevice,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Navigation Header
              HeaderWidget(header: 'BOOK A MBIT'),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'Book Your mbit',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'BeVietnam',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6699CC),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 3,
                              width: MyUtility(context).width * 0.4,
                              decoration: BoxDecoration(
                                color: Color(0xFF6699CC),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Schedule your personalized mbit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'BeVietnam',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Form Content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Duration Selection
                            _buildSectionTitle('Duration'),
                            _buildDurationSelection(),

                            SizedBox(height: 24),

                            // Date Selection
                            _buildSectionTitle('Select Date'),
                            _buildDateSelection(),

                            SizedBox(height: 24),

                            // Time Selection
                            _buildSectionTitle('Select Time'),
                            _buildTimeSelection(),

                            SizedBox(height: 32),

                            // Book Button
                            _buildBookButton(),

                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E1E1E),
          fontFamily: 'BeVietnam',
        ),
      ),
    );
  }

  Widget _buildDurationSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        children: durations.map((duration) {
          bool isSelected = selectedDuration == duration;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDuration = duration;
              });
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF6699CC) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Color(0xFF6699CC) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                duration,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontFamily: 'BeVietnam',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateSelection() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 90)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF6699CC),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF6699CC)),
            SizedBox(width: 12),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'Select a date',
              style: TextStyle(
                fontSize: 16,
                color: selectedDate != null ? Colors.black : Colors.grey[600],
                fontFamily: 'BeVietnam',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay(hour: 9, minute: 0),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF6699CC),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedTime = picked;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFF6699CC)),
            SizedBox(width: 12),
            Text(
              selectedTime != null
                  ? selectedTime!.format(context)
                  : 'Select a time',
              style: TextStyle(
                fontSize: 16,
                color: selectedTime != null ? Colors.black : Colors.grey[600],
                fontFamily: 'BeVietnam',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    bool canBook = selectedDate != null && selectedTime != null;

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canBook ? _handleBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6699CC),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: canBook ? 2 : 0,
        ),
        child: Text(
          'Book mbit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnam',
          ),
        ),
      ),
    );
  }

  void _handleBooking() async {
    try {
      // Get current user
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please login to book a mbit')),
        );
        return;
      }

      // Save booking to Firebase
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'service': 'Book mbit',
        'duration': selectedDuration,
        'date': selectedDate!.toIso8601String(),
        'time':
            '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'formattedDate':
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
        'formattedTime': selectedTime!.format(context),
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: Color(0xFF6699CC),
                  fontFamily: 'BeVietnam',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your mbit has been booked successfully.',
                style: TextStyle(fontSize: 16, fontFamily: 'BeVietnam'),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service: Book mbit',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Duration: $selectedDuration'),
                    Text(
                        'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                    Text('Time: ${selectedTime!.format(context)}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Reset form after booking
                setState(() {
                  selectedDate = null;
                  selectedTime = null;
                  selectedDuration = '60 minutes';
                });
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF6699CC),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking mbit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
