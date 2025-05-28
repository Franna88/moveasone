import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_constants.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/workout_detail_screen.dart';
import 'package:move_as_one/enhanced_workout_creator/services/workout_service.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_app_bar.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_button.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_input_field.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/multi_select_chip.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  List<String> _selectedCategories = [];
  List<String> _selectedBodyAreas = [];
  List<String> _selectedWeekdays = [];
  List<String> _selectedEquipment = [];
  String? _selectedDifficulty;

  File? _imageFile;
  String _imageUrl = '';
  bool _isLoading = false;

  // New color palette
  final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
  final accentColor = const Color(0xFFEDCBA4); // Toffee
  final highlightColor = const Color(0xFFF5DEB3); // Sand
  final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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

  Future<void> _createWorkout() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedBodyAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one body area'),
          backgroundColor: Colors.red,
        ),
      );
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

    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day of the week'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image if selected
      if (_imageFile != null) {
        _imageUrl = await _workoutService.uploadImage(_imageFile!);
      }

      // Create workout object
      final workout = Workout(
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl,
        categories: _selectedCategories,
        difficulty: _selectedDifficulty!,
        bodyAreas: _selectedBodyAreas,
        equipment: _selectedEquipment,
        weekdays: _selectedWeekdays,
        estimatedDuration: int.tryParse(_durationController.text) ?? 0,
      );

      // Save workout to Firestore
      final workoutId = await _workoutService.createWorkout(workout);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Workout created successfully'),
            backgroundColor: Colors.green.shade600,
          ),
        );

        // Navigate to workout detail screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(workoutId: workoutId),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create workout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ModernAppBar(
        title: 'Create Workout',
        backgroundColor: Colors.white,
        textColor: primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 16),
                    _buildBasicInfo(),
                    const SizedBox(height: 16),
                    _buildCategoriesSection(),
                    const SizedBox(height: 16),
                    _buildBodyAreasSection(),
                    const SizedBox(height: 16),
                    _buildDifficultySection(),
                    const SizedBox(height: 16),
                    _buildWeekdaysSection(),
                    const SizedBox(height: 16),
                    _buildEquipmentSection(),
                    const SizedBox(height: 32),
                    ModernButton(
                      text: 'Create Workout',
                      onPressed: _createWorkout,
                      type: ButtonType.primary,
                      isFullWidth: true,
                      isLoading: _isLoading,
                      icon: Icons.check,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add Workout Image',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ModernInputField(
              label: 'Workout Name',
              hint: 'Enter workout name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a workout name';
                }
                return null;
              },
            ),
            ModernInputField(
              label: 'Description',
              hint: 'Enter workout description',
              controller: _descriptionController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a workout description';
                }
                return null;
              },
            ),
            ModernInputField(
              label: 'Estimated Duration (minutes)',
              hint: 'Enter estimated workout duration',
              controller: _durationController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the estimated duration';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration <= 0) {
                  return 'Please enter a valid duration';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: MultiSelectChip(
          options: WorkoutConstants.categories,
          selectedItems: _selectedCategories,
          onSelectionChanged: (selectedItems) {
            setState(() {
              _selectedCategories = selectedItems;
            });
          },
          label: 'Workout Categories',
          isRequired: true,
        ),
      ),
    );
  }

  Widget _buildBodyAreasSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: MultiSelectChip(
          options: WorkoutConstants.bodyAreas,
          selectedItems: _selectedBodyAreas,
          onSelectionChanged: (selectedItems) {
            setState(() {
              _selectedBodyAreas = selectedItems;
            });
          },
          label: 'Body Areas',
          isRequired: true,
        ),
      ),
    );
  }

  Widget _buildDifficultySection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleSelectChip(
          options: WorkoutConstants.difficulties,
          selectedItem: _selectedDifficulty,
          onSelectionChanged: (selectedItem) {
            setState(() {
              _selectedDifficulty = selectedItem;
            });
          },
          label: 'Difficulty Level',
          isRequired: true,
        ),
      ),
    );
  }

  Widget _buildWeekdaysSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: MultiSelectChip(
          options: WorkoutConstants.weekdays,
          selectedItems: _selectedWeekdays,
          onSelectionChanged: (selectedItems) {
            setState(() {
              _selectedWeekdays = selectedItems;
            });
          },
          label: 'Weekdays',
          isRequired: true,
        ),
      ),
    );
  }

  Widget _buildEquipmentSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: MultiSelectChip(
          options: WorkoutConstants.equipment,
          selectedItems: _selectedEquipment,
          onSelectionChanged: (selectedItems) {
            setState(() {
              _selectedEquipment = selectedItems;
            });
          },
          label: 'Equipment',
          isRequired: false,
        ),
      ),
    );
  }
}
