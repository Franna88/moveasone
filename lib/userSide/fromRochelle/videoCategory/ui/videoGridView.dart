import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/workout_detail_screen.dart';

class VideoGridView extends StatefulWidget {
  final Function(int) changePageIndex;
  final String sortBy;
  final bool sortAscending;
  final String? categoryFilter;
  final String? difficultyFilter;

  VideoGridView({
    super.key,
    required this.changePageIndex,
    this.sortBy = 'name',
    this.sortAscending = true,
    this.categoryFilter,
    this.difficultyFilter,
  });

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<DocumentSnapshot> workoutDocuments = [];
  List<DocumentSnapshot> _filteredWorkouts = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    fetchWorkouts();
  }

  @override
  void didUpdateWidget(VideoGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-apply filters and sorting when props change
    if (oldWidget.sortBy != widget.sortBy ||
        oldWidget.sortAscending != widget.sortAscending ||
        oldWidget.categoryFilter != widget.categoryFilter ||
        oldWidget.difficultyFilter != widget.difficultyFilter) {
      _applyFiltersAndSort();
    }
  }

  Future<void> fetchWorkouts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('createWorkout').get();
    setState(() {
      workoutDocuments = querySnapshot.docs;
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    // Start with all workouts
    _filteredWorkouts = List.from(workoutDocuments);

    // Apply category filter
    if (widget.categoryFilter != null) {
      _filteredWorkouts = _filteredWorkouts.where((doc) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false;

        // Check in different possible category fields
        if (data.containsKey('categories') && data['categories'] is List) {
          return (data['categories'] as List).contains(widget.categoryFilter);
        } else if (data.containsKey('selectedCategories') &&
            data['selectedCategories'] is List) {
          return (data['selectedCategories'] as List)
              .contains(widget.categoryFilter);
        }
        return false;
      }).toList();
    }

    // Apply difficulty filter
    if (widget.difficultyFilter != null) {
      _filteredWorkouts = _filteredWorkouts.where((doc) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false;

        if (data.containsKey('difficulty')) {
          return data['difficulty'] == widget.difficultyFilter;
        }
        return false;
      }).toList();
    }

    // Apply sorting
    _sortWorkouts();

    setState(() {});
  }

  void _sortWorkouts() {
    switch (widget.sortBy) {
      case 'name':
        _filteredWorkouts.sort((a, b) {
          var aData = a.data() as Map<String, dynamic>?;
          var bData = b.data() as Map<String, dynamic>?;

          String aName = aData?['name']?.toString() ?? '';
          String bName = bData?['name']?.toString() ?? '';

          return widget.sortAscending
              ? aName.compareTo(bName)
              : bName.compareTo(aName);
        });
        break;

      case 'date':
        _filteredWorkouts.sort((a, b) {
          var aData = a.data() as Map<String, dynamic>?;
          var bData = b.data() as Map<String, dynamic>?;

          Timestamp? aTimestamp = aData?['updatedAt'] as Timestamp?;
          Timestamp? bTimestamp = bData?['updatedAt'] as Timestamp?;

          if (aTimestamp == null || bTimestamp == null) {
            return 0;
          }

          return widget.sortAscending
              ? aTimestamp.compareTo(bTimestamp)
              : bTimestamp.compareTo(aTimestamp);
        });
        break;

      case 'duration':
        _filteredWorkouts.sort((a, b) {
          var aData = a.data() as Map<String, dynamic>?;
          var bData = b.data() as Map<String, dynamic>?;

          int aDuration = 0;
          int bDuration = 0;

          // Try different possible duration fields
          if (aData?.containsKey('estimatedDuration') ?? false) {
            aDuration = aData!['estimatedDuration'] as int? ?? 0;
          } else if (aData?.containsKey('time') ?? false) {
            var time = aData!['time'];
            aDuration =
                time is int ? time : (int.tryParse(time.toString()) ?? 0);
          }

          if (bData?.containsKey('estimatedDuration') ?? false) {
            bDuration = bData!['estimatedDuration'] as int? ?? 0;
          } else if (bData?.containsKey('time') ?? false) {
            var time = bData!['time'];
            bDuration =
                time is int ? time : (int.tryParse(time.toString()) ?? 0);
          }

          return widget.sortAscending
              ? aDuration.compareTo(bDuration)
              : bDuration.compareTo(aDuration);
        });
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper function to get a valid image URL or field
  String? _getValidImageUrl(DocumentSnapshot workout) {
    // Check different possible field names for images
    final imageFields = ['displayImage', 'imageUrl', 'image'];

    for (var field in imageFields) {
      if (workout.data() is Map<String, dynamic>) {
        final data = workout.data() as Map<String, dynamic>;
        if (data.containsKey(field) &&
            data[field] is String &&
            data[field].toString().isNotEmpty &&
            (data[field].toString().startsWith('http') ||
                data[field].toString().startsWith('https'))) {
          return data[field];
        }
      }
    }

    return null;
  }

  // Helper function to get workout name
  String _getWorkoutName(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;
      return data['name'] ?? 'Workout';
    }
    return 'Workout';
  }

  // Helper function to get workout difficulty
  String _getWorkoutDifficulty(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;
      return data['difficulty'] ?? 'Beginner';
    }
    return 'Beginner';
  }

  // Helper function to get workout duration
  String _getWorkoutDuration(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;

      // Try different possible duration fields
      if (data.containsKey('estimatedDuration')) {
        return '${data['estimatedDuration']} min';
      } else if (data.containsKey('time')) {
        return '${data['time']} min';
      }
    }
    return '0 min';
  }

  // Helper function to get exercise count
  int _getExerciseCount(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;
      int count = 0;

      // Count exercises in all sections
      if (data.containsKey('workouts') && data['workouts'] is List) {
        count += (data['workouts'] as List).length;
      }
      if (data.containsKey('warmUps') && data['warmUps'] is List) {
        count += (data['warmUps'] as List).length;
      }
      if (data.containsKey('coolDowns') && data['coolDowns'] is List) {
        count += (data['coolDowns'] as List).length;
      }

      return count;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // New color palette
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream
    final accentColor = const Color(0xFFEDCBA4); // Toffee

    return AnimatedBuilder(
      animation: _animationController,
      child: Container(
        color: backgroundColor,
        child: _filteredWorkouts.isEmpty
            ? _buildEmptyState()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredWorkouts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      var workout = _filteredWorkouts[index];
                      return _buildWorkoutCard(workout);
                    },
                  );
                },
              ),
      ),
      builder: (context, child) => Padding(
        padding: EdgeInsets.only(top: 50 - _animationController.value * 50),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState() {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue

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
          Text(
            'No matching workouts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different filter options',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(DocumentSnapshot workout) {
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final accentColor = const Color(0xFFEDCBA4); // Toffee

    final imageUrl = _getValidImageUrl(workout);
    final workoutName = _getWorkoutName(workout);
    final difficulty = _getWorkoutDifficulty(workout);
    final duration = _getWorkoutDuration(workout);
    final exerciseCount = _getExerciseCount(workout);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(
                workoutId: workout.id,
              ),
            ),
          ).then((_) => fetchWorkouts());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout image or gradient header
            Container(
              height: 90,
              width: double.infinity,
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

                  // Icon and difficulty
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Workout type icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(workout),
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
                            difficulty,
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

            // Workout info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout name
                    Text(
                      workoutName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Workout description
                    Expanded(
                      child: Text(
                        _getDescription(workout),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

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
                          duration,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Categories
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: _getCategories(workout)
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

                    const SizedBox(height: 8),

                    // Actions row at bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$exerciseCount exercises',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        // Edit/Delete icons
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetailScreen(
                                      workoutId: workout.id,
                                    ),
                                  ),
                                ).then((_) => fetchWorkouts());
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red[400],
                              ),
                              onPressed: () {
                                _showDeleteConfirmation(workout);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
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

  // Helper function to get category icon
  IconData _getCategoryIcon(DocumentSnapshot workout) {
    final categories = _getCategories(workout);

    if (categories.contains('Cardio')) {
      return Icons.directions_run;
    } else if (categories.contains('Strength')) {
      return Icons.fitness_center;
    } else if (categories.contains('Yoga')) {
      return Icons.self_improvement;
    } else if (categories.contains('Flexibility')) {
      return Icons.accessibility_new;
    }

    return Icons.fitness_center;
  }

  // Helper function to get categories
  List<String> _getCategories(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;

      if (data.containsKey('categories') && data['categories'] is List) {
        return List<String>.from(data['categories'].map((c) => c.toString()));
      } else if (data.containsKey('selectedCategories') &&
          data['selectedCategories'] is List) {
        return List<String>.from(
            data['selectedCategories'].map((c) => c.toString()));
      }
    }

    return ['General'];
  }

  // Helper function to get workout description
  String _getDescription(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;
      return data['description'] ?? 'No description available';
    }
    return 'No description available';
  }

  void _showDeleteConfirmation(DocumentSnapshot workout) {
    final workoutName = _getWorkoutName(workout);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: Text(
          'Are you sure you want to delete "$workoutName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteWorkout(workout.id);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWorkout(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('createWorkout')
          .doc(id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted successfully')),
      );

      // Refresh the workout list
      fetchWorkouts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete workout: $e')),
      );
    }
  }
}
