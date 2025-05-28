import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_constants.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/create_workout_screen.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoCategory.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoGridView.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/displayVideoScreen.dart';

class VideoBrowsPage extends StatefulWidget {
  const VideoBrowsPage({super.key});

  @override
  State<VideoBrowsPage> createState() => _VideoBrowsPageState();
}

class _VideoBrowsPageState extends State<VideoBrowsPage> {
  var pageIndex = 0;

  // Filter and sort state
  String? _selectedCategory;
  String? _selectedDifficulty;
  String _sortBy = 'name'; // 'name', 'date', 'duration'
  bool _sortAscending = true;
  bool _showFilterBar = true;

  changePageIndex(value) {
    setState(() {
      pageIndex = value;
    });
  }

  void _navigateToCreateWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkoutScreen(),
      ),
    ).then((_) => setState(() {})); // Refresh the page after returning
  }

  void _toggleSortDirection() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  void _selectSortOption(String option) {
    setState(() {
      _sortBy = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;

    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream
    final accentColor = const Color(0xFFEDCBA4); // Toffee

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Workouts',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilterBar ? Icons.filter_list : Icons.filter_list_off,
              color: _showFilterBar ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showFilterBar = !_showFilterBar;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: primaryColor),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort and filter bar
          if (_showFilterBar) _buildSortAndFilterBar(),

          // Category filters
          VideoCategory(),

          // Main content area
          Expanded(
            child: pageIndex == 0
                ? VideoGridView(
                    changePageIndex: changePageIndex,
                    sortBy: _sortBy,
                    sortAscending: _sortAscending,
                    categoryFilter: _selectedCategory,
                    difficultyFilter: _selectedDifficulty,
                  )
                : DisplayVideoScreen(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateWorkout,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSortAndFilterBar() {
    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sort options row
          Row(
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              _buildSortButton('Name', 'name'),
              const SizedBox(width: 8),
              _buildSortButton('Date', 'date'),
              const SizedBox(width: 8),
              _buildSortButton('Duration', 'duration'),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                  color: primaryColor,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _toggleSortDirection,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Filter options row
          Row(
            children: [
              Text(
                'Filter:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),

              // Category dropdown
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor.withOpacity(0.1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      hint: const Text('All Categories'),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ...WorkoutConstants.categories
                            .map((category) => DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Difficulty dropdown
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor.withOpacity(0.1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDifficulty,
                      hint: const Text('All Difficulties'),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Difficulties'),
                        ),
                        ...WorkoutConstants.difficulties
                            .map((difficulty) => DropdownMenuItem<String>(
                                  value: difficulty,
                                  child: Text(difficulty),
                                ))
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, String value) {
    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise

    final bool isSelected = _sortBy == value;

    return InkWell(
      onTap: () => _selectSortOption(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : secondaryColor.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
