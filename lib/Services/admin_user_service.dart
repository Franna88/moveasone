import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/config/admin_config.dart';
import 'package:move_as_one/services/debug_service.dart';

class AdminUserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ensures the admin user document exists in Firebase
  static Future<void> ensureAdminUserExists() async {
    try {
      final adminUserId = AdminConfig.ADMIN_USER_ID;
      final adminDoc =
          await _firestore.collection('users').doc(adminUserId).get();

      if (!adminDoc.exists) {
        // Create admin user document
        await _firestore.collection('users').doc(adminUserId).set({
          'firstName': 'Rachelle',
          'lastName': 'Admin',
          'userName': AdminConfig.ADMIN_DISPLAY_NAME,
          'email': 'admin@moveasone.com',
          'status': 'admin',
          'profileImage': AdminConfig.ADMIN_PROFILE_PIC,
          'friendsList': [],
          'createdAt': FieldValue.serverTimestamp(),
          'isTrainer': true,
          'isAdmin': true,
        });

        DebugService().log(
            'Admin user document created successfully', LogLevel.info,
            tag: 'ADMIN_SETUP');
      } else {
        // Ensure admin document has required fields
        final data = adminDoc.data() as Map<String, dynamic>?;
        Map<String, dynamic> updates = {};

        if (data?['status'] != 'admin') {
          updates['status'] = 'admin';
        }
        if (data?['isAdmin'] != true) {
          updates['isAdmin'] = true;
        }
        if (data?['isTrainer'] != true) {
          updates['isTrainer'] = true;
        }
        if (data?['friendsList'] == null) {
          updates['friendsList'] = [];
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(adminUserId).update(updates);
          DebugService().log(
              'Admin user document updated with missing fields', LogLevel.info,
              tag: 'ADMIN_SETUP');
        }
      }
    } catch (e, stackTrace) {
      DebugService().logError('Error ensuring admin user exists', e, stackTrace,
          tag: 'ADMIN_SETUP');
    }
  }

  /// Store a message from a user to the admin (trainer)
  static Future<void> storeMessageToAdmin({
    required String senderId,
    required String message,
    required String senderName,
  }) async {
    try {
      await ensureAdminUserExists();

      final adminUserId = AdminConfig.ADMIN_USER_ID;
      final timestamp = Timestamp.now();

      // Update sender's friendsList (user side)
      await _updateUserFriendsList(
        userId: senderId,
        friendId: adminUserId,
        message: message,
        senderId: senderId,
        receiverId: adminUserId,
        timestamp: timestamp,
      );

      // Update admin's friendsList (admin side)
      await _updateUserFriendsList(
        userId: adminUserId,
        friendId: senderId,
        message: message,
        senderId: senderId,
        receiverId: adminUserId,
        timestamp: timestamp,
      );

      DebugService().log(
          'Message stored successfully for admin inbox', LogLevel.info,
          tag: 'ADMIN_MESSAGING');
    } catch (e, stackTrace) {
      DebugService().logError('Error storing message to admin', e, stackTrace,
          tag: 'ADMIN_MESSAGING');
      rethrow;
    }
  }

  /// Helper method to update a user's friendsList with a new message
  static Future<void> _updateUserFriendsList({
    required String userId,
    required String friendId,
    required String message,
    required String senderId,
    required String receiverId,
    required Timestamp timestamp,
  }) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();

    List<dynamic> friendsList = [];
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>?;
      friendsList = userData?['friendsList'] as List<dynamic>? ?? [];
    }

    // Find or create friend entry
    var friendEntry = friendsList.firstWhere(
      (friend) => friend['id'] == friendId,
      orElse: () => null,
    );

    if (friendEntry == null) {
      friendEntry = {
        'id': friendId,
        'status': 'friend',
        'messages': [],
      };
      friendsList.add(friendEntry);
    } else {
      // Ensure messages array exists
      if (friendEntry['messages'] == null || friendEntry['messages'] is! List) {
        friendEntry['messages'] = [];
      }
    }

    // Add the message
    (friendEntry['messages'] as List).add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    });

    // Update the document
    await _firestore.collection('users').doc(userId).set({
      'friendsList': friendsList,
    }, SetOptions(merge: true));
  }

  /// Get all messages sent to admin from users
  static Stream<List<Map<String, dynamic>>> getAdminMessages() {
    return _firestore
        .collection('users')
        .where('status', isEqualTo: 'user')
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> allMessages = [];

      DebugService().log(
          'Processing ${snapshot.docs.length} users for admin messages',
          LogLevel.info,
          tag: 'ADMIN_MESSAGES');

      for (var userDoc in snapshot.docs) {
        final userData = userDoc.data();
        final userName = userData['userName'] ?? userData['name'] ?? 'Unknown User';
        final userEmail = userData['email'] ?? '';
        final friendsList = userData['friendsList'] as List<dynamic>? ?? [];

        // Find messages to admin
        final adminFriend = friendsList.firstWhere(
          (friend) => friend['id'] == AdminConfig.ADMIN_USER_ID,
          orElse: () => null,
        );

        if (adminFriend != null && adminFriend['messages'] != null) {
          final messages = adminFriend['messages'] as List<dynamic>;
          if (messages.isNotEmpty) {
            DebugService().log(
                'Found ${messages.length} messages from user: $userName',
                LogLevel.info,
                tag: 'ADMIN_MESSAGES');

            allMessages.add({
              'userId': userDoc.id,
              'userName': userName,
              'userEmail': userEmail,
              'messages': messages,
              'lastMessage': messages.last,
            });
          }
        }
      }

      DebugService().log(
          'Total admin messages found: ${allMessages.length}', LogLevel.info,
          tag: 'ADMIN_MESSAGES');

      // Sort by last message timestamp
      allMessages.sort((a, b) {
        final aTime = a['lastMessage']['timestamp'] as Timestamp?;
        final bTime = b['lastMessage']['timestamp'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime); // Most recent first
      });

      return allMessages;
    });
  }
}
