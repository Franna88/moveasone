import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModernInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsets contentPadding;

  // New color palette
  static const primaryColor = Color(0xFF6699CC); // Cornflower Blue
  static const secondaryColor = Color(0xFF94D8E0); // Pale Turquoise
  static const accentColor = Color(0xFFEDCBA4); // Toffee
  static const backgroundColor = Color(0xFFFFF8F0); // Light Sand/Cream

  const ModernInputField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: primaryColor)
                : null,
            suffixIcon: suffixIcon,
            isDense: true,
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ModernDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool isMultiSelect;

  // New color palette
  static const primaryColor = Color(0xFF6699CC); // Cornflower Blue
  static const secondaryColor = Color(0xFF94D8E0); // Pale Turquoise
  static const accentColor = Color(0xFFEDCBA4); // Toffee
  static const backgroundColor = Color(0xFFFFF8F0); // Light Sand/Cream

  const ModernDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isMultiSelect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
