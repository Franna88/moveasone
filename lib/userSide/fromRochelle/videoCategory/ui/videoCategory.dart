import 'package:flutter/material.dart';

class VideoCategory extends StatefulWidget {
  const VideoCategory({super.key});

  @override
  State<VideoCategory> createState() => _VideoCategoryState();
}

class _VideoCategoryState extends State<VideoCategory> {
  int _selectedIndex = 0;

  // Sample categories matching the screenshot
  final List<String> categories = [
    'Upper Body',
    'Strength',
    'Legs',
    'Arms',
    'Back',
    'Core',
    'All'
  ];

  @override
  Widget build(BuildContext context) {
    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: secondaryColor.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildCategoryChip(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(int index) {
    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise

    final bool isSelected = index == _selectedIndex;
    final String category = categories[index];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? primaryColor : secondaryColor.withOpacity(0.1),
            border: Border.all(
              color:
                  isSelected ? primaryColor : secondaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
