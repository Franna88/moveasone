import 'package:flutter/material.dart';

class UserImageStack extends StatefulWidget {
  final String userPic;
  final VoidCallback onpress;
  final bool isLoading;

  const UserImageStack({
    super.key,
    required this.userPic,
    required this.onpress,
    required this.isLoading,
  });

  @override
  State<UserImageStack> createState() => _UserImageStackState();
}

class _UserImageStackState extends State<UserImageStack> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: InkWell(
        onTap: widget.onpress,
        child: widget.isLoading
            ? CircleAvatar(
                foregroundColor: Colors.black.withOpacity(0.5),
                radius: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                height: 80,
                width: 100,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      backgroundImage: widget.userPic.isNotEmpty
                          ? NetworkImage(widget.userPic)
                          : null,
                      child: widget.userPic.isEmpty
                          ? Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      right: 19,
                      top: 58,
                      child: Container(
                        height: 23,
                        width: 22,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 55,
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
