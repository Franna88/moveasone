import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/languageListView.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/searchBar.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
     var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        Padding(
            padding: const EdgeInsets.only( top: 25, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                
                Container(
                  width: widthDevice * 0.80,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'LANGUAGE',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        SearchBarWidget(),
        const SizedBox(height: 25,),
        LanguageListView()
      ],
    );
  }
}
