import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_constants.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';
import 'package:move_as_one/enhanced_workout_creator/services/workout_service.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_app_bar.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_button.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_input_field.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/multi_select_chip.dart';

class ExerciseEditorScreen extends StatefulWidget {
  final String workoutId;
  final String exerciseType; // 'warmup', 'exercise', 'cooldown'
  final WorkoutExercise? exercise; // If editing an existing exercise

  const ExerciseEditorScreen({
    Key? key,
    required this.workoutId,
    required this.exerciseType,
    this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseEditorScreen> createState() => _ExerciseEditorScreenState();
}

class _ExerciseEditorScreenState extends State<ExerciseEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final WorkoutService _workoutService = WorkoutService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _restController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _selectedDifficulty;
  String? _selectedEquipment;
  bool _isTimeBased = false;
  bool _isLoading = false;

  File? _imageFile;
  File? _videoFile;
  File? _audioFile;

  String _imageUrl = '';
  String _videoUrl = '';
  String _audioUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.exercise != null) {
      _nameController.text = widget.exercise!.name;
      _descriptionController.text = widget.exercise!.description;
      _setsController.text = widget.exercise!.sets.toString();
      _repsController.text = widget.exercise!.reps.toString();
      _restController.text = widget.exercise!.restBetweenSets.toString();
      _durationController.text = widget.exercise!.duration.toString();
      _selectedDifficulty = widget.exercise!.difficulty;
      _selectedEquipment = widget.exercise!.equipment;
      _isTimeBased = widget.exercise!.isTimeBased;
      _imageUrl = widget.exercise!.imageUrl;
      _videoUrl = widget.exercise!.videoUrl;
      _audioUrl = widget.exercise!.audioUrl;
    } else {
      // Default values for new exercise
      _setsController.text = '3';
      _repsController.text = '10';
      _restController.text = '30';
      _durationController.text = '30';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
      });
    }
  }

  Future<void> _pickAudio() async {
    // Simplified for example purposes
    // In a real app, you would use a file picker plugin
    // and filter for audio files
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio picker not implemented in this example.'),
      ),
    );
  }

  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDifficulty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a difficulty level'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedEquipment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select equipment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload files if selected
      if (_imageFile != null) {
        _imageUrl = await _workoutService.uploadImage(_imageFile!);
      }

      if (_videoFile != null) {
        _videoUrl = await _workoutService.uploadVideo(_videoFile!);
      }

      if (_audioFile != null) {
        _audioUrl = await _workoutService.uploadAudio(_audioFile!);
      }

      // Fetch the workout
      final workout = await _workoutService.getWorkout(widget.workoutId);
      if (workout == null) {
        throw Exception('Workout not found');
      }

      // Create the exercise
      final exercise = WorkoutExercise(
        id: widget.exercise?.id, // Use existing ID if editing
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl,
        videoUrl: _videoUrl,
        audioUrl: _audioUrl,
        equipment: _selectedEquipment!,
        difficulty: _selectedDifficulty!,
        sets: int.parse(_setsController.text),
        reps: int.parse(_repsController.text),
        restBetweenSets: int.parse(_restController.text),
        duration: int.parse(_durationController.text),
        isTimeBased: _isTimeBased,
      );

      // Update the appropriate exercise list based on type
      List<WorkoutExercise> updatedExercises;
      Workout updatedWorkout;

      switch (widget.exerciseType) {
        case 'warmup':
          updatedExercises = List.from(workout.warmups);
          if (widget.exercise != null) {
            final index =
                updatedExercises.indexWhere((e) => e.id == widget.exercise!.id);
            if (index != -1) {
              updatedExercises[index] = exercise;
            } else {
              updatedExercises.add(exercise);
            }
          } else {
            updatedExercises.add(exercise);
          }
          updatedWorkout = workout.copyWith(warmups: updatedExercises);
          break;
        case 'exercise':
          updatedExercises = List.from(workout.exercises);
          if (widget.exercise != null) {
            final index =
                updatedExercises.indexWhere((e) => e.id == widget.exercise!.id);
            if (index != -1) {
              updatedExercises[index] = exercise;
            } else {
              updatedExercises.add(exercise);
            }
          } else {
            updatedExercises.add(exercise);
          }
          updatedWorkout = workout.copyWith(exercises: updatedExercises);
          break;
        case 'cooldown':
          updatedExercises = List.from(workout.cooldowns);
          if (widget.exercise != null) {
            final index =
                updatedExercises.indexWhere((e) => e.id == widget.exercise!.id);
            if (index != -1) {
              updatedExercises[index] = exercise;
            } else {
              updatedExercises.add(exercise);
            }
          } else {
            updatedExercises.add(exercise);
          }
          updatedWorkout = workout.copyWith(cooldowns: updatedExercises);
          break;
        default:
          throw Exception('Invalid exercise type');
      }

      // Update the workout in Firestore
      await _workoutService.updateWorkout(updatedWorkout);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.exercise == null
                ? 'Exercise created successfully'
                : 'Exercise updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Return the exercise to the previous screen
        Navigator.pop(context, exercise);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save exercise: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;
    final String title = isEditing ? 'Edit Exercise' : 'Add Exercise';
    final String typeLabel = widget.exerciseType == 'warmup'
        ? 'Warm-up'
        : widget.exerciseType == 'cooldown'
            ? 'Cool-down'
            : 'Main Exercise';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: ModernAppBar(
        title: '$title - $typeLabel',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 16),
                    _buildBasicInfoSection(),
                    const SizedBox(height: 16),
                    _buildPerformanceSection(),
                    const SizedBox(height: 16),
                    _buildMediaSection(),
                    const SizedBox(height: 32),
                    ModernButton(
                      text: isEditing ? 'Update Exercise' : 'Add Exercise',
                      onPressed: _saveExercise,
                      type: ButtonType.primary,
                      isFullWidth: true,
                      icon: isEditing ? Icons.check : Icons.add,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : _imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add Exercise Image',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ModernInputField(
              label: 'Exercise Name',
              hint: 'Enter exercise name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an exercise name';
                }
                return null;
              },
            ),
            ModernInputField(
              label: 'Description',
              hint: 'Enter exercise description',
              controller: _descriptionController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an exercise description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SingleSelectChip(
              label: 'Difficulty',
              options: WorkoutConstants.difficulties,
              selectedItem: _selectedDifficulty,
              onSelectionChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
              isRequired: true,
            ),
            const SizedBox(height: 16),
            SingleSelectChip(
              label: 'Equipment',
              options: WorkoutConstants.equipment,
              selectedItem: _selectedEquipment,
              onSelectionChanged: (value) {
                setState(() {
                  _selectedEquipment = value;
                });
              },
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Time-Based Exercise'),
              subtitle: Text(
                _isTimeBased
                    ? 'Exercise performed for a specific duration'
                    : 'Exercise performed for a specific number of repetitions',
              ),
              value: _isTimeBased,
              onChanged: (value) {
                setState(() {
                  _isTimeBased = value;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ModernInputField(
                    label: 'Sets',
                    hint: 'Number of sets',
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final sets = int.tryParse(value);
                      if (sets == null || sets <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _isTimeBased
                      ? ModernInputField(
                          label: 'Duration (seconds)',
                          hint: 'Time per set',
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final duration = int.tryParse(value);
                            if (duration == null || duration <= 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        )
                      : ModernInputField(
                          label: 'Repetitions',
                          hint: 'Reps per set',
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final reps = int.tryParse(value);
                            if (reps == null || reps <= 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                ),
              ],
            ),
            ModernInputField(
              label: 'Rest Between Sets (seconds)',
              hint: 'Rest time',
              controller: _restController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rest time';
                }
                final rest = int.tryParse(value);
                if (rest == null || rest < 0) {
                  return 'Invalid rest time';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Demonstration Video'),
              subtitle: Text(
                _videoFile != null
                    ? 'Video selected'
                    : _videoUrl.isNotEmpty
                        ? 'Video uploaded'
                        : 'No video selected',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _pickVideo,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: const Text('Audio Instructions'),
              subtitle: Text(
                _audioFile != null
                    ? 'Audio selected'
                    : _audioUrl.isNotEmpty
                        ? 'Audio uploaded'
                        : 'No audio selected',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _pickAudio,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
