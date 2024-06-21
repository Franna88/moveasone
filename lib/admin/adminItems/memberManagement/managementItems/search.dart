import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/searchBar.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
     var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Container(
                width: widthDevice * 0.80,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'SEARCH MEMBERS',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SearchBarWidget(),]);
  }
}