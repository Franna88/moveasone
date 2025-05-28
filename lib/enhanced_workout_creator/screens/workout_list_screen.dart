import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_constants.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/create_workout_screen.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/workout_detail_screen.dart';
import 'package:move_as_one/enhanced_workout_creator/services/workout_service.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_app_bar.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_button.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final WorkoutService _workoutService = WorkoutService();
  List<Workout> _workouts = [];
  List<Workout> _filteredWorkouts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Filter and sort state
  String? _selectedCategory;
  String? _selectedDifficulty;
  String _sortBy = 'name'; // 'name', 'date', 'duration'
  bool _sortAscending = true;
  bool _showFilterBar = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _applyFilters() {
    setState(() {
      _filteredWorkouts = _workouts.where((workout) {
        // Apply category filter
        if (_selectedCategory != null &&
            !workout.categories.contains(_selectedCategory)) {
          return false;
        }

        // Apply difficulty filter
        if (_selectedDifficulty != null &&
            workout.difficulty != _selectedDifficulty) {
          return false;
        }

        return true;
      }).toList();

      // Apply sorting
      _sortWorkouts();
    });
  }

  void _sortWorkouts() {
    switch (_sortBy) {
      case 'name':
        _filteredWorkouts.sort((a, b) => _sortAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'date':
        _filteredWorkouts.sort((a, b) => _sortAscending
            ? a.updatedAt.compareTo(b.updatedAt)
            : b.updatedAt.compareTo(a.updatedAt));
        break;
      case 'duration':
        _filteredWorkouts.sort((a, b) => _sortAscending
            ? a.estimatedDuration.compareTo(b.estimatedDuration)
            : b.estimatedDuration.compareTo(a.estimatedDuration));
        break;
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedDifficulty = null;
      _sortBy = 'name';
      _sortAscending = true;
      _filteredWorkouts = List.from(_workouts);
      _sortWorkouts();
    });
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final workouts = await _workoutService.getAllWorkouts();
      setState(() {
        _workouts = workouts;
        _filteredWorkouts = List.from(workouts); // Initialize filtered list
        _sortWorkouts(); // Apply default sorting
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load workouts: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteWorkout(String id) async {
    try {
      await _workoutService.deleteWorkout(id);
      setState(() {
        _workouts.removeWhere((workout) => workout.id == id);
        _filteredWorkouts.removeWhere((workout) => workout.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete workout: $e')),
      );
    }
  }

  void _navigateToCreateWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkoutScreen(),
      ),
    ).then((_) => _loadWorkouts());
  }

  void _navigateToWorkoutDetail(Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(workoutId: workout.id),
      ),
    ).then((_) => _loadWorkouts());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ModernAppBar(
        title: 'Workouts',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              _showFilterBar ? Icons.filter_list_off : Icons.filter_list,
              color: _showFilterBar ? primaryColor : null,
            ),
            onPressed: () {
              setState(() {
                _showFilterBar = !_showFilterBar;
              });
            },
            tooltip: 'Filter workouts',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorkouts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter/sort bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showFilterBar ? null : 0,
            child: _showFilterBar ? _buildFilterBar() : const SizedBox.shrink(),
          ),

          // Workout content
          Expanded(
            child: _buildBody(),
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

  Widget _buildFilterBar() {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Sort options
          Row(
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              _buildSortChip('Name', 'name'),
              const SizedBox(width: 8),
              _buildSortChip('Date', 'date'),
              const SizedBox(width: 8),
              _buildSortChip('Duration', 'duration'),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _sortAscending = !_sortAscending;
                    _sortWorkouts();
                  });
                },
                tooltip: _sortAscending ? 'Ascending' : 'Descending',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  'Filter:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Category dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor.withOpacity(0.1),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text('Category'),
                    underline: const SizedBox(),
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
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Difficulty dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor.withOpacity(0.1),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedDifficulty,
                    hint: const Text('Difficulty'),
                    underline: const SizedBox(),
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
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Reset filters button
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: Icon(Icons.refresh, size: 16, color: primaryColor),
                  label: Text(
                    'Reset',
                    style: TextStyle(color: primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String sortValue) {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise

    final isSelected = _sortBy == sortValue;
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = sortValue;
          _sortWorkouts();
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : secondaryColor.withOpacity(0.1),
          border: Border.all(
            color: isSelected ? primaryColor : secondaryColor.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(16),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ModernButton(
              text: 'Retry',
              onPressed: _loadWorkouts,
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (_workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No workouts yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first workout',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Create Workout',
              onPressed: _navigateToCreateWorkout,
              icon: Icons.add,
            ),
          ],
        ),
      );
    }

    if (_filteredWorkouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No matching workouts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different filter options',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWorkouts,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredWorkouts.length,
        itemBuilder: (context, index) {
          final workout = _filteredWorkouts[index];
          return _buildCompactWorkoutCard(workout);
        },
      ),
    );
  }

  Widget _buildCompactWorkoutCard(Workout workout) {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final accentColor = const Color(0xFFEDCBA4); // Toffee

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () => _navigateToWorkoutDetail(workout),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header with gradient
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern for visual interest
                  Positioned(
                    right: -15,
                    top: -15,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -5,
                    bottom: -20,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),

                  // Workout icon and difficulty badge
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Workout type icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            workout.categories.contains('Cardio')
                                ? Icons.directions_run
                                : workout.categories.contains('Strength')
                                    ? Icons.fitness_center
                                    : Icons.self_improvement,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            workout.difficulty,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Workout details
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout name
                    Text(
                      workout.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Duration
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${workout.estimatedDuration} min',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Categories
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: workout.categories
                          .take(2)
                          .map((category) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: secondaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: primaryColor,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                    const Spacer(),

                    // Actions row at bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Edit icon
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: primaryColor,
                          ),
                          onPressed: () => _navigateToWorkoutDetail(workout),
                          splashRadius: 24,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),

                        // Delete icon
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red[400],
                          ),
                          onPressed: () => _deleteWorkout(workout.id),
                          splashRadius: 24,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
