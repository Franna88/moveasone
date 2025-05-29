import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
}

class CommonButtons extends StatefulWidget {
  final String buttonText;
  final Function() onTap;
  final Color? buttonColor;
  final double? width;
  final bool elevated;
  final int? motivationScore;
  final String? motivationText;
  final bool showMotivation;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final ButtonType type;

  CommonButtons({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.width,
    this.elevated = false,
    this.motivationScore,
    this.motivationText,
    this.showMotivation = false,
    this.icon,
    this.isLoading = false,
    this.height = 50,
    this.borderRadius = 12,
    this.type = ButtonType.primary,
  });

  @override
  State<CommonButtons> createState() => _CommonButtonsState();
}

class _CommonButtonsState extends State<CommonButtons> {
  Color getMotivationColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    // If custom button color is provided, use it instead of the themed colors
    Color backgroundColor = widget.buttonColor ?? theme.colorScheme.primary;

    switch (widget.type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: widget.elevated ? 2 : 0,
          shadowColor:
              widget.elevated ? backgroundColor.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor ?? theme.colorScheme.secondary,
          foregroundColor: Colors.white,
          elevation: widget.elevated ? 2 : 0,
          shadowColor:
              widget.elevated ? backgroundColor.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      case ButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(color: backgroundColor),
          ),
        );
      case ButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      case ButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor ?? Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: widget.elevated ? 2 : 0,
          shadowColor:
              widget.elevated ? Colors.red.shade600.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      case ButtonType.success:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor ?? Colors.green.shade600,
          foregroundColor: Colors.white,
          elevation: widget.elevated ? 2 : 0,
          shadowColor:
              widget.elevated ? Colors.green.shade600.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
    }
  }

  Widget _buildButtonContent() {
    final TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'BeVietnam',
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    if (widget.isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.icon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.buttonText,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        else
          Text(
            widget.buttonText,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        if (widget.showMotivation && widget.motivationScore != null) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: LinearProgressIndicator(
              value: widget.motivationScore! / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                getMotivationColor(widget.motivationScore!),
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          if (widget.motivationText != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.motivationText!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'BeVietnam',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widget.width ?? widthDevice,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onTap,
        style: _getButtonStyle(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: _buildButtonContent(),
        ),
      ),
    );
  }
}
