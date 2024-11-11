import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class CheckBoxWidget extends StatefulWidget {
  String description;
  bool checkboxValue;
  CheckBoxWidget(
      {super.key, required this.description, required this.checkboxValue});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2,left: 20),
      child: SizedBox(
        height: 20,
        child: CheckboxListTile(
          
          controlAffinity: ListTileControlAffinity.leading,
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (!states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return null;
          }),
          side: BorderSide(
            color: Colors.black,
          ),
          visualDensity: VisualDensity(vertical: -4, horizontal: -4),
          contentPadding: EdgeInsets.all(0),
          checkboxShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          value: widget.checkboxValue,
          activeColor: UiColors().teal,
          checkColor: Colors.white,
          
          onChanged: (bool? value) {
            setState(() {
              widget.checkboxValue = !widget.checkboxValue;
            });
          },
          
          title: Text(
            
            widget.description,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                
                ),
          ),
        ),
      ),
    );
  }
}
