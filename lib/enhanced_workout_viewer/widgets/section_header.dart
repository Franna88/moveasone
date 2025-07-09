import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final IconData? actionIcon;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onActionPressed,
    this.actionText,
    this.actionIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          if (onActionPressed != null)
            GestureDetector(
              onTap: onActionPressed,
              child: Row(
                children: [
                  if (actionText != null)
                    Text(
                      actionText!,
                      style: TextStyle(
                        color: UiColors().primaryBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  if (actionIcon != null)
                    Icon(
                      actionIcon,
                      color: UiColors().primaryBlue,
                      size: 20,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
