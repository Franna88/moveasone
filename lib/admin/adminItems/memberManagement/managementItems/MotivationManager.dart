import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/Services/motivation_service.dart';
import 'package:move_as_one/Services/scheduled_tasks.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class MotivationManager extends StatefulWidget {
  const MotivationManager({super.key});

  @override
  State<MotivationManager> createState() => _MotivationManagerState();
}

class _MotivationManagerState extends State<MotivationManager> {
  bool _isLoading = false;
  bool _isRunningScheduledTask = false;
  DateTime? _lastUpdated;
  Map<String, int> _motivationStats = {
    'low': 0,
    'medium': 0,
    'high': 0,
    'total': 0,
  };

  // Settings for auto-watch thresholds
  int _inactivityThreshold = 6; // Default: 6 days
  int _motivationThreshold = 30; // Default: below 30%
  bool _isLoadingSettings = true;
  bool _isSavingSettings = false;

  @override
  void initState() {
    super.initState();
    _fetchMotivationStats();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    setState(() {
      _isLoadingSettings = true;
    });

    try {
      DocumentSnapshot settingsDoc = await FirebaseFirestore.instance
          .collection('appSettings')
          .doc('watchSettings')
          .get();

      if (settingsDoc.exists) {
        Map<String, dynamic> data = settingsDoc.data() as Map<String, dynamic>;
        setState(() {
          _inactivityThreshold = data['inactivityThreshold'] ?? 6;
          _motivationThreshold = data['motivationThreshold'] ?? 30;
        });
      }
    } catch (e) {
      print('Error fetching watch settings: $e');
    } finally {
      setState(() {
        _isLoadingSettings = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSavingSettings = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('appSettings')
          .doc('watchSettings')
          .set({
        'inactivityThreshold': _inactivityThreshold,
        'motivationThreshold': _motivationThreshold,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error saving settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving settings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSavingSettings = false;
      });
    }
  }

  Future<void> _fetchMotivationStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check when motivation was last updated
      QuerySnapshot lastUpdatedQuery = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastCalculated', descending: true)
          .limit(1)
          .get();

      if (lastUpdatedQuery.docs.isNotEmpty) {
        Map<String, dynamic> data =
            lastUpdatedQuery.docs.first.data() as Map<String, dynamic>;
        if (data.containsKey('lastCalculated')) {
          _lastUpdated = DateTime.parse(data['lastCalculated']);
        }
      }

      // Get motivation statistics
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      int lowCount = 0;
      int mediumCount = 0;
      int highCount = 0;
      int totalCount = usersSnapshot.docs.length;

      for (var doc in usersSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int motivationScore = data['motivationScore'] ?? 50;

        if (motivationScore < 30) {
          lowCount++;
        } else if (motivationScore < 70) {
          mediumCount++;
        } else {
          highCount++;
        }
      }

      setState(() {
        _motivationStats = {
          'low': lowCount,
          'medium': mediumCount,
          'high': highCount,
          'total': totalCount,
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching motivation stats: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching motivation statistics'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _recalculateMotivation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await MotivationService.updateAllUsersMotivation();
      await _fetchMotivationStats();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Motivation scores recalculated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error recalculating motivation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recalculating motivation: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runScheduledTasks() async {
    setState(() {
      _isRunningScheduledTask = true;
    });

    try {
      await ScheduledTasks.forceRecalculation();
      await _fetchMotivationStats();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheduled task completed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error running scheduled task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error running scheduled task: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isRunningScheduledTask = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'MOTIVATION MANAGER'),
        const SizedBox(height: 20),

        // Last updated info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Last calculated: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _lastUpdated != null
                    ? '${_lastUpdated!.day}/${_lastUpdated!.month}/${_lastUpdated!.year} at ${_lastUpdated!.hour}:${_lastUpdated!.minute}'
                    : 'Never',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Motivation stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Member Motivation Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Stats grid
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        _buildStatRow(
                          'Low Motivation',
                          _motivationStats['low'] ?? 0,
                          _motivationStats['total'] ?? 1,
                          Colors.red,
                        ),
                        const SizedBox(height: 10),
                        _buildStatRow(
                          'Medium Motivation',
                          _motivationStats['medium'] ?? 0,
                          _motivationStats['total'] ?? 1,
                          Colors.orange,
                        ),
                        const SizedBox(height: 10),
                        _buildStatRow(
                          'High Motivation',
                          _motivationStats['high'] ?? 0,
                          _motivationStats['total'] ?? 1,
                          Colors.green,
                        ),
                      ],
                    ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Watch settings
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auto-Watch Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _isLoadingSettings
                  ? const Center(child: CircularProgressIndicator())
                  : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Automatically add members to watch list when:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Inactivity threshold
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_off,
                                  color: Colors.blueGrey,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Inactive for at least:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                DropdownButton<int>(
                                  value: _inactivityThreshold,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _inactivityThreshold = newValue;
                                      });
                                    }
                                  },
                                  items: <int>[3, 4, 5, 6, 7, 8, 9, 10]
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value days'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Motivation threshold
                            Row(
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.blueGrey,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Motivation score below:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                DropdownButton<int>(
                                  value: _motivationThreshold,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _motivationThreshold = newValue;
                                      });
                                    }
                                  },
                                  items: <int>[10, 20, 30, 40, 50]
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value%'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Save button
                            Center(
                              child: ElevatedButton(
                                onPressed:
                                    _isSavingSettings ? null : _saveSettings,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF006261),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSavingSettings
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text('Save Settings'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Action buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Recalculate button
              ElevatedButton(
                onPressed: _isLoading ? null : _recalculateMotivation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006261),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Recalculate All Motivation Scores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Run scheduled task button
              OutlinedButton(
                onPressed: _isRunningScheduledTask ? null : _runScheduledTasks,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF006261),
                  side: BorderSide(color: const Color(0xFF006261)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isRunningScheduledTask
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF006261)),
                        ),
                      )
                    : const Text(
                        'Run Auto-Watch Detection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStatRow(String label, int count, int total, Color color) {
    // Calculate percentage
    double percentage = total > 0 ? (count / total) * 100 : 0;

    return Row(
      children: [
        // Label
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: total > 0 ? count / total : 0,
                  backgroundColor: Colors.grey[300],
                  color: color,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count members (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
