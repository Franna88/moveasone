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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE7E2FA),
              width: 1.0,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            color: isSelected
                ? const Color(0xFF9C69B8) // Purple color
                : Colors.grey.shade300,
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
