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
    return AnimatedBuilder(
      animation: _animationController,
      child: Container(
        color:
            const Color(0xFFE7E2FA), // Light purple background from screenshot
        child: _filteredWorkouts.isEmpty
            ? _buildEmptyState()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredWorkouts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
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
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(DocumentSnapshot workout) {
    final imageUrl = _getValidImageUrl(workout);
    final workoutName = _getWorkoutName(workout);
    final difficulty = _getWorkoutDifficulty(workout);
    final duration = _getWorkoutDuration(workout);
    final exerciseCount = _getExerciseCount(workout);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
            // Workout image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                child: imageUrl == null
                    ? Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.grey[500],
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.grey[500],
                          );
                        },
                      ),
              ),
            ),

            // Workout info
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout name
                    Text(
                      workoutName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Workout description
                    Expanded(
                      child: Text(
                        _getDescription(workout),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Tags row
                    Row(
                      children: [
                        // Difficulty tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A3EA1), // Purple
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            difficulty,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Duration tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Exercise count and edit/delete
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
                            InkWell(
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
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                _showDeleteConfirmation(workout);
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
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

  String _getDescription(DocumentSnapshot workout) {
    if (workout.data() is Map<String, dynamic>) {
      final data = workout.data() as Map<String, dynamic>;
      return data['description'] ?? 'No description';
    }
    return 'No description';
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
