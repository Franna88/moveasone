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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Workouts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilterBar ? Icons.filter_list : Icons.filter_list_off,
              color: _showFilterBar ? const Color(0xFF6A3EA1) : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showFilterBar = !_showFilterBar;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
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
        backgroundColor:
            const Color(0xFF6A3EA1), // Purple color to match enhanced creator
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sort options row
          Row(
            children: [
              const Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
                  color: Colors.black87,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _toggleSortDirection,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filter options row
          Row(
            children: [
              const Text(
                'Filter:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),

              // Category dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      hint: const Text('All Categories'),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDifficulty,
                      hint: const Text('All Difficulties'),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
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
    final bool isSelected = _sortBy == value;

    return InkWell(
      onTap: () => _selectSortOption(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6A3EA1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
