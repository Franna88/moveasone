import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: UiColors().grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextField(
            cursorColor: Colors.grey,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                hintText: 'Search',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 134, 134, 134),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                prefixIcon: Container(
                  padding: EdgeInsets.all(15),
                  width: 18,
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
