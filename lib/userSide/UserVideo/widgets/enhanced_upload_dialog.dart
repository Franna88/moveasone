import 'package:flutter/material.dart';
import '../models/video_models.dart';

class EnhancedUploadDialog extends StatefulWidget {
  final Function(String videoName, VideoType videoType, WorkoutType workoutType,
      String description, List<String> tags) onUpload;

  const EnhancedUploadDialog({
    Key? key,
    required this.onUpload,
  }) : super(key: key);

  @override
  State<EnhancedUploadDialog> createState() => _EnhancedUploadDialogState();
}

class _EnhancedUploadDialogState extends State<EnhancedUploadDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  VideoType _selectedVideoType = VideoType.workout;
  WorkoutType _selectedWorkoutType = WorkoutType.cardio;

  late AnimationController _animationController;

  // Modern fitness app colors
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF7FB2DE);
  final Color accentColor = const Color(0xFFA3E1DB);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _buildDialogContent(),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Video',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Add your fitness video',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey[400],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Video Name
            _buildInputField(
              controller: _nameController,
              label: 'Video Name',
              hint: 'e.g., Morning Cardio Session',
              icon: Icons.title,
            ),

            const SizedBox(height: 20),

            // Video Type Selection
            _buildSectionHeader('Video Type'),
            const SizedBox(height: 12),
            _buildVideoTypeSelection(),

            const SizedBox(height: 20),

            // Workout Type Selection
            _buildSectionHeader('Workout Type'),
            const SizedBox(height: 12),
            _buildWorkoutTypeSelection(),

            const SizedBox(height: 20),

            // Description
            _buildInputField(
              controller: _descriptionController,
              label: 'Description (Optional)',
              hint: 'Tell us about your workout...',
              icon: Icons.description,
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // Tags
            _buildInputField(
              controller: _tagsController,
              label: 'Tags (Optional)',
              hint: 'cardio, morning, hiit (separate with commas)',
              icon: Icons.tag,
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Upload Video',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  Widget _buildVideoTypeSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: VideoType.values.map((type) {
        final isSelected = _selectedVideoType == type;
        return InkWell(
          onTap: () => setState(() => _selectedVideoType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey[300]!,
              ),
            ),
            child: Text(
              _getVideoTypeLabel(type),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutTypeSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WorkoutType.values.map((type) {
        final isSelected = _selectedWorkoutType == type;
        return InkWell(
          onTap: () => setState(() => _selectedWorkoutType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? secondaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? secondaryColor : Colors.grey[300]!,
              ),
            ),
            child: Text(
              _getWorkoutTypeLabel(type),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getVideoTypeLabel(VideoType type) {
    switch (type) {
      case VideoType.workout:
        return '🏋️ Workout';
      case VideoType.progress:
        return '📈 Progress';
      case VideoType.formCheck:
        return '✅ Form Check';
      case VideoType.achievement:
        return '🏆 Achievement';
      case VideoType.tutorial:
        return '📚 Tutorial';
    }
  }

  String _getWorkoutTypeLabel(WorkoutType type) {
    switch (type) {
      case WorkoutType.cardio:
        return '❤️ Cardio';
      case WorkoutType.strength:
        return '💪 Strength';
      case WorkoutType.yoga:
        return '🧘 Yoga';
      case WorkoutType.pilates:
        return '🤸 Pilates';
      case WorkoutType.hiit:
        return '🔥 HIIT';
      case WorkoutType.stretching:
        return '🤲 Stretching';
      case WorkoutType.dance:
        return '💃 Dance';
      case WorkoutType.sports:
        return '⚽ Sports';
      case WorkoutType.rehabilitation:
        return '🏥 Rehabilitation';
      case WorkoutType.other:
        return '🎯 Other';
    }
  }

  void _handleUpload() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a video name'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    widget.onUpload(
      _nameController.text.trim(),
      _selectedVideoType,
      _selectedWorkoutType,
      _descriptionController.text.trim(),
      tags,
    );

    Navigator.of(context).pop();
  }
}
