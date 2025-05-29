import 'package:flutter/material.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color textColor;

  // New color palette
  static const primaryColor = Color(0xFF6699CC); // Cornflower Blue
  static const secondaryColor = Color(0xFF94D8E0); // Pale Turquoise
  static const accentColor = Color(0xFFEDCBA4); // Toffee
  static const bgColor = Color(0xFFFFF8F0); // Light Sand/Cream

  const ModernAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.textColor = primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: textColor,
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: actions ?? [],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
