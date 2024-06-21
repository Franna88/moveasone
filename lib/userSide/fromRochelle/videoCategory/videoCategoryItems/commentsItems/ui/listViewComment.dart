import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/model/commentModel.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/ui/addCommentRow.dart';

class ListViewComment extends StatelessWidget {
  const ListViewComment({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          height: heightDevice * 0.50,
          width: widthDevice,
          color: Colors.white,
          child: ListView.builder(
            itemCount: dummyComments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 18,
                        backgroundImage:
                            AssetImage(dummyComments[index].assetName),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  dummyComments[index].userName,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  dummyComments[index].timeStamp,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 128, 127, 127),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              dummyComments[index].userComment,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  dummyComments[index].likes,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 107, 106, 106),
                                  ),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 107, 106, 106),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 1, width: 15, color: Colors.black),
                                Text(
                                  '  View 4 more replies',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 107, 106, 106),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: AddCommentRow(),
        )
      ],
    );
  }
}
