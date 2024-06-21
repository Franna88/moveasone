import 'package:flutter/material.dart';

class PrivacyPolicyCheckbox extends StatefulWidget {
  @override
  _PrivacyPolicyCheckboxState createState() => _PrivacyPolicyCheckboxState();
}

class _PrivacyPolicyCheckboxState extends State<PrivacyPolicyCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Color(0xFFFFFFA6);
              }
              return null;
            },
          ),
        ),
        Text(
          'I agree with ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Privacy',
            style: TextStyle(
              color: Color(0xFFAC6AFF),
            ),
          ),
        ),
        Text(
          ' and ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Policy',
            style: TextStyle(
              color: Color(0xFFAC6AFF),
            ),
          ),
        ),
      ],
    );
  }
}
