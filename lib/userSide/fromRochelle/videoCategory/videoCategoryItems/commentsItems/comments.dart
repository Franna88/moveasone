import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/ui/addCommentRow.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/ui/listViewComment.dart';

class Comments extends StatefulWidget {
  Function(int) changePageIndex;
  Comments({super.key,  required this.changePageIndex});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: heightDevice * 0.08,
            width: widthDevice,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    widget.changePageIndex(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 201, 200, 200),
                    ),
                    height: 5,
                    width: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Comments',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 0.2,
          width: widthDevice,
          color: Color.fromARGB(255, 128, 126, 126),
        ),
        ListViewComment(),
        Container(
          height: 0.2,
          width: widthDevice,
          color: Color.fromARGB(255, 29, 29, 29),
        ),
        //AddCommentRow()
      ],
    );
  }
}
