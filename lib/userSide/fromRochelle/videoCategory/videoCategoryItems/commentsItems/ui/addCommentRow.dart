import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/ui/commentPostButton.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/ui/commentTextField.dart';

class AddCommentRow extends StatelessWidget {
  const AddCommentRow({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      children: [
        MyDivider(),
        Container(
          width: widthDevice,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18,
                  backgroundImage: AssetImage('images/comment1.jpg'),
                ),
                const SizedBox(
                  width: 8,
                ),
                CommentTextField(hintText: 'Add a comment as Lana Stepsson'),
                const SizedBox(
                  width: 8,
                ),
                CommentPostButton()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
