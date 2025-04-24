import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:move_as_one/Services/motivation_service.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class MemberProfile extends StatefulWidget {
  final String userId;
  final String memberName;
  final String memberImage;
  final String memberBio;
  final String memberWebsite;

  const MemberProfile({
    super.key,
    required this.userId,
    required this.memberName,
    required this.memberImage,
    required this.memberBio,
    required this.memberWebsite,
  });

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> userExercises = [];
  bool isUpdatingMotivation = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;

          // Extract user exercises and sort by date (most recent first)
          if (userData['userExercises'] != null) {
            userExercises = List<Map<String, dynamic>>.from(
                userData['userExercises']
                    .map((e) => Map<String, dynamic>.from(e)));

            userExercises.sort((a, b) {
              final dateA = DateTime.parse(a['date'] as String);
              final dateB = DateTime.parse(b['date'] as String);
              return dateB.compareTo(dateA); // Sort in descending order
            });
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _recalculateMotivation() async {
    setState(() {
      isUpdatingMotivation = true;
    });

    try {
      await MotivationService.updateUserMotivation(widget.userId);
      await _fetchUserDetails(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Motivation score updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating motivation score: $e')),
      );
    } finally {
      setState(() {
        isUpdatingMotivation = false;
      });
    }
  }

  Color _getMotivationColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getMotivationText(int score) {
    if (score >= 70) return 'High Motivation';
    if (score >= 40) return 'Medium Motivation';
    return 'Low Motivation';
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'MEMBER PROFILE'),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile image
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.memberImage.isNotEmpty
                          ? NetworkImage(widget.memberImage)
                          : null,
                      child: widget.memberImage.isEmpty
                          ? Icon(Icons.person,
                              size: 40, color: Colors.grey[600])
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Profile details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.memberName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (widget.memberBio.isNotEmpty) ...[
                            Text(
                              widget.memberBio,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (widget.memberWebsite.isNotEmpty) ...[
                            Text(
                              widget.memberWebsite,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF006261),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              WatchButton(
                                userId: widget.userId,
                                isWatched: userData['isWatched'] ?? false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Motivation section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Motivation Score',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: isUpdatingMotivation
                                ? null
                                : _recalculateMotivation,
                            icon: isUpdatingMotivation
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Icon(Icons.refresh, size: 16),
                            label: Text('Update'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF006261),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              textStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData['motivationScore'] ?? 0}%',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _getMotivationColor(
                                      userData['motivationScore'] ?? 0),
                                ),
                              ),
                              Text(
                                _getMotivationText(
                                    userData['motivationScore'] ?? 0),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getMotivationColor(
                                      userData['motivationScore'] ?? 0),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Last workout:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                userData['lastWorkoutDate'] != null
                                    ? _formatTimestamp(
                                        userData['lastWorkoutDate'])
                                    : userExercises.isNotEmpty
                                        ? userExercises[0]['date'] ?? 'Unknown'
                                        : 'No workouts',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: (userData['motivationScore'] ?? 0) / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getMotivationColor(userData['motivationScore'] ?? 0),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      if (userData['watchReason'] != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Watch reason: ${userData['watchReason']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Recent Activity
                const SizedBox(height: 24),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildWorkoutHistory(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWorkoutHistory() {
    if (userExercises.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No workout history found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: userExercises.length > 5 ? 5 : userExercises.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final exercise = userExercises[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.fitness_center,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              exercise['type'] ?? 'Unknown workout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _formatDate(exercise['date']),
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            trailing: exercise['completed'] == true
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.pending, color: Colors.orange),
          );
        },
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMd().format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'No data';

    try {
      final date = (timestamp as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat.yMMMd().format(date);
      }
    } catch (e) {
      return 'Unknown date';
    }
  }
}
