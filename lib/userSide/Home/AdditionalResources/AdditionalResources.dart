import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResourcesComponents/AdditionalContainer.dart';
import 'package:move_as_one/myutility.dart';

class AdditionalResources extends StatefulWidget {
  const AdditionalResources({super.key});

  @override
  State<AdditionalResources> createState() => _AdditionalResourcesState();
}

class _AdditionalResourcesState extends State<AdditionalResources> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.35,
      child: Column(
        children: [
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Additional Resources',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontFamily: 'belight',
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFFAA5F3A),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w100,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: MyUtility(context).width * 0.02,
                ),
                AdditionsalContainer(
                    image: 'images/nutrision.png',
                    header: "Nutrition Tip",
                    discription: "Healthy Lifestyle"),
                AdditionsalContainer(
                    image: 'images/nutrision2.png',
                    header: "Nutrition Tip",
                    discription: "Healthy Lifestyle"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
