import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAboutPages/writeAReview.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/ui/messageBuild.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: widthDevice,
          height: heightDevice * 0.38,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                MessageBuild(
                    messangerName: 'Rochelle',
                    message:
                        'You are doing such a great Job. I love how you are working towards your goal. Let me know if you need any help. ',
                    timeStamp: '2d ago'),
                MessageBuild(
                    messangerName: 'Rochelle',
                    message:
                        'You are doing such a great Job. I love how you are working towards your goal. Let me know if you need any help. ',
                    timeStamp: '2d ago'),
              ],
            ),
          ),
        ),
        
        const MyDivider(),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: CommonButtons(
              buttonText: 'Write a Message',
              onTap: () {
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WriteAReview()),
  );
                //ADD ROUTE
              },
              buttonColor: Colors.black),
        )
      ],
    );
  }
}
