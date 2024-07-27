import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/writeAMessage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';

class MessagesColumn extends StatefulWidget {
  const MessagesColumn({super.key});

  @override
  State<MessagesColumn> createState() => _MessagesColumnState();
}

class _MessagesColumnState extends State<MessagesColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnHeader(header: 'Messages'),
          CommonButtons(
            buttonText: 'Inbox',
            onTap: () {
              Navigator.pushNamed(context, '/inbox');
            },
            buttonColor: AdminColors().lightTeal,
          ),
          const SizedBox(height: 10),
          CommonButtons(
            buttonText: 'Message a Member',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteAMessage(),
                ),
              );
            },
            buttonColor: AdminColors().lightTeal,
          ),
          const SizedBox(height: 10),
          ColumnHeader(header: 'User'),
          CommonButtons(
            buttonText: 'Logout',
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserState(),
                ),
              );
            },
            buttonColor: AdminColors().lightTeal,
          ),
        ],
      ),
    );
  }
}
