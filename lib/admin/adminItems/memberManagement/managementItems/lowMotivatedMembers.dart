import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/lowMotivatedWidget.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/statusBarActivity.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class LowMotivatedMembers extends StatelessWidget {
  const LowMotivatedMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(children: [
      HeaderWidget(header: 'LOW MOTIVATED MEMBERS'),
      LowMotivatedWidget(
        image: 'images/pfp1.jpg',
        name: 'Dulce Bothman',
        bar: StatusBarActivity(percentage: 23),
      ),
      LowMotivatedWidget(
        image: 'images/pfp2.jpg',
        name: 'Chance Cullhane',
        bar: StatusBarActivity(percentage: 32),
      ),
      LowMotivatedWidget(
        image: 'images/pfp3.jpg',
        name: 'Madelyn Lipshutz',
        bar: StatusBarActivity(percentage: 45),
      ),
    ]);
  }
}
