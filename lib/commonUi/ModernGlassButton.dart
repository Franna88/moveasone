import 'package:flutter/material.dart';
import 'dart:ui';

enum GlassButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
}

class ModernGlassButton extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final bool elevated;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final GlassButtonType type;
  final double blurStrength;
  final double backgroundOpacity;

  // Default color palette - matches the app's colors
  static const Color primaryColor = Color(0xFF6699CC); // Cornflower Blue
  static const Color secondaryColor = Color(0xFF94D8E0); // Pale Turquoise
  static const Color accentColor = Color(0xFFF4A460); // Light Coral
  static const Color highlightColor = Color(0xFFEEE8AA); // Lemon
  static const Color textDefaultColor = Colors.white;

  const ModernGlassButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.width,
    this.elevated = true,
    this.icon,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 20,
    this.type = GlassButtonType.primary,
    this.blurStrength = 10.0,
    this.backgroundOpacity = 0.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get default color based on type
    Color defaultColor = _getTypeColor();
    Color bgColor = buttonColor ?? defaultColor;
    Color txtColor = textColor ?? textDefaultColor;

    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.8,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onTap,
              splashColor: bgColor.withOpacity(0.3),
              highlightColor: bgColor.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(backgroundOpacity),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: elevated
                      ? [
                          BoxShadow(
                            color: bgColor.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildButtonContent(txtColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case GlassButtonType.primary:
        return primaryColor;
      case GlassButtonType.secondary:
        return secondaryColor;
      case GlassButtonType.outline:
        return primaryColor;
      case GlassButtonType.text:
        return primaryColor;
      case GlassButtonType.danger:
        return Colors.red.shade600;
      case GlassButtonType.success:
        return Colors.green.shade600;
    }
  }

  Widget _buildButtonContent(Color textColor) {
    final TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      shadows: [
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 3.0,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );

    if (isLoading) {
      return const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return Center(
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: textStyle,
                ),
              ],
            )
          : Text(
              buttonText,
              style: textStyle,
            ),
    );
  }
}
