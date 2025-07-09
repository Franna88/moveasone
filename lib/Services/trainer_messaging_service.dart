import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/config/admin_config.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:move_as_one/services/debug_service.dart';

class TrainerMessagingService {
  static void messageTrainer({
    required BuildContext context,
    required String trainerName,
    String? trainerPic,
  }) {
    DebugService().logUserAction('message_trainer_tapped',
        screen: 'TrainerMessagingService',
        parameters: {'trainerName': trainerName});

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login to message trainers'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final adminInfo = AdminConfig.getAdminInfo();
      final adminUserId = adminInfo['userId']!;
      final adminDisplayName = adminInfo['displayName']!;
      final adminProfilePic = trainerPic ?? adminInfo['profilePic'] ?? 'images/comment1.jpg';

      final chatId = (currentUser.uid.compareTo(adminUserId) > 0)
          ? '${currentUser.uid}_$adminUserId'
          : '${adminUserId}_${currentUser.uid}';

      // Log the messaging action
      DebugService().log(
          'User messaging trainer (routed to admin): $trainerName',
          LogLevel.info,
          tag: 'MESSAGING');

      // Show loading feedback
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
              Text('Opening chat with $trainerName...'),
            ],
          ),
          backgroundColor: Color(0xFF6699CC),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to chat (shows trainer name but routes to admin)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyChat(
            userName: trainerName, // Display the trainer's name
            userPic: adminProfilePic,
            userId: adminUserId, // But route to admin
            chatId: chatId,
          ),
        ),
      );

      // Dismiss loading snackbar after navigation
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e, stackTrace) {
      DebugService().logError('Error opening chat with trainer', e, stackTrace,
          tag: 'MESSAGING');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening chat. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Convenience method for messaging Rachelle specifically
  static void messageRachelle(BuildContext context) {
    messageTrainer(
      context: context,
      trainerName: 'Rachelle',
      trainerPic: 'images/comment1.jpg',
    );
  }

  // Method to check if a user should be treated as a trainer
  static bool isTrainerMessage(String userName) {
    return AdminConfig.isTrainer(userName);
  }
}
