import 'package:flutter/material.dart';

class ColumnHeader extends StatelessWidget {
  final String header;
  final Color? color;

  const ColumnHeader({
    super.key,
    required this.header,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        header,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? const Color(0xFF6A3EA1),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
