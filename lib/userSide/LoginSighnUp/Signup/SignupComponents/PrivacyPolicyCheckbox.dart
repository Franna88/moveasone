import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyCheckbox extends StatefulWidget {
  @override
  _PrivacyPolicyCheckboxState createState() => _PrivacyPolicyCheckboxState();
}

class _PrivacyPolicyCheckboxState extends State<PrivacyPolicyCheckbox> {
  bool _isChecked = false;

  Future<void> _launchPrivacyPolicy() async {
    final Uri url = Uri.parse(
        'https://github.com/Franna88/barefootBytes-privacy/blob/main/privacy-policy.md');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          fillColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
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
          onPressed: _launchPrivacyPolicy,
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
          onPressed: _launchPrivacyPolicy,
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
