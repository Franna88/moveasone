import 'package:flutter/material.dart';

class ContainerVerificationCode extends StatefulWidget {
  const ContainerVerificationCode({Key? key}) : super(key: key);

  @override
  State<ContainerVerificationCode> createState() =>
      _ContainerVerificationCodeState();
}

class _ContainerVerificationCodeState extends State<ContainerVerificationCode> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVerificationCodeBox(TextEditingController(), 1),
        _buildVerificationCodeBox(TextEditingController(), 2),
        _buildVerificationCodeBox(TextEditingController(), 3),
        _buildVerificationCodeBox(TextEditingController(), 4),
        _buildVerificationCodeBox(TextEditingController(), 5),
      ],
    );
  }

  Container _buildVerificationCodeBox(
      TextEditingController controller, int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: index.toString(),
            hintStyle: TextStyle(
              fontSize: 22,
              fontFamily: 'raleway',
              color: Color(0xFF707070),
            ),
          ),
        ),
      ),
    );
  }
}
