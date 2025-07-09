import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/AllMessagesDisplay.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/adminInboxPage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/adminMembersList.dart';

class MessagesColumn extends StatefulWidget {
  const MessagesColumn({super.key});

  @override
  State<MessagesColumn> createState() => _MessagesColumnState();
}

class _MessagesColumnState extends State<MessagesColumn> {
  // Modern color scheme
  final Color primaryColor = const Color(0xFF6A3EA1); // Purple
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color messageColor = const Color(0xFF3498DB); // Blue for messages
  final Color logoutColor = const Color(0xFF7E8C8D); // Grey for logout

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Messages section header
        Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),

        // Messages buttons
        _buildActionButton(
          title: 'Inbox',
          icon: Icons.inbox,
          color: messageColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminInboxPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        _buildActionButton(
          title: 'Message a Member',
          icon: Icons.chat_bubble_outline,
          color: messageColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminMembersList(),
              ),
            );
          },
        ),

        // User section
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 16),
          child: Text(
            'User',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Logout button
        _buildActionButton(
          title: 'Logout',
          icon: Icons.logout,
          color: logoutColor,
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserState(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
