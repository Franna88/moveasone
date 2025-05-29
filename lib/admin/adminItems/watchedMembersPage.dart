import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';

class WatchedMembersPage extends StatelessWidget {
  const WatchedMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watched Members'),
        backgroundColor: const Color(0xFF006261),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Members requiring special attention',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: WatchedMembersListView(),
          ),
        ],
      ),
    );
  }
}

class WatchedMembersListView extends StatelessWidget {
  const WatchedMembersListView({super.key});

  String _formatLastWorkoutDate(DateTime? lastWorkoutDate) {
    if (lastWorkoutDate == null) {
      return 'No workouts yet';
    }

    final now = DateTime.now();
    final difference = now.difference(lastWorkoutDate);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  String _getWatchReasonText(Map<String, dynamic> userData) {
    final String? watchReason = userData['watchReason'];
    final Timestamp? lastWorkoutTimestamp = userData['lastWorkout'];

    if (watchReason != null && watchReason.isNotEmpty) {
      return watchReason;
    }

    if (lastWorkoutTimestamp != null) {
      final lastWorkout = lastWorkoutTimestamp.toDate();
      final daysInactive = DateTime.now().difference(lastWorkout).inDays;

      if (daysInactive > 30) {
        return 'Inactive for $daysInactive days';
      }
    }

    final double? motivationScore = userData['motivationScore']?.toDouble();
    if (motivationScore != null && motivationScore < 50) {
      return 'Low motivation score: ${motivationScore.toStringAsFixed(1)}';
    }

    return 'Manually added to watch list';
  }

  Color _getMotivationColor(double? score) {
    if (score == null) return Colors.grey;

    if (score < 30) {
      return Colors.red;
    } else if (score < 60) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('isWatched', isEqualTo: true)
          .where('isAdmin', isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_off, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No members are currently being watched',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final userData = docs[index].data() as Map<String, dynamic>;
            final userId = docs[index].id;

            // Parse user data
            final String name = userData['name'] ?? 'Unknown';
            final String email = userData['email'] ?? 'No email';
            final String profileUrl = userData['profileUrl'] ?? '';
            final int? age = userData['age'];
            final String? gender = userData['gender'];
            final String? goal = userData['goal'];
            final double? motivationScore =
                userData['motivationScore']?.toDouble();

            // Get last workout date
            DateTime? lastWorkoutDate;
            if (userData['lastWorkout'] != null) {
              lastWorkoutDate = (userData['lastWorkout'] as Timestamp).toDate();
            }

            final watchReason = _getWatchReasonText(userData);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileUrl.isNotEmpty
                              ? NetworkImage(profileUrl)
                              : null,
                          child: profileUrl.isEmpty
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?')
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (age != null) ...[
                                    Text(
                                      '$age years',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  if (gender != null) ...[
                                    Text(
                                      gender,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  if (goal != null && goal.isNotEmpty) ...[
                                    Expanded(
                                      child: Text(
                                        'Goal: $goal',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        WatchButton(userId: userId, isWatched: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last workout: ${_formatLastWorkoutDate(lastWorkoutDate)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (motivationScore != null)
                                Tooltip(
                                  message: 'Motivation Score',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          _getMotivationColor(motivationScore),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${motivationScore.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reason: $watchReason',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.message_outlined),
                          label: const Text('Message'),
                          onPressed: () {
                            // TODO: Implement messaging functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Messaging not implemented yet')),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.person_outlined),
                          label: const Text('View Profile'),
                          onPressed: () {
                            // TODO: Implement user profile navigation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile view not implemented yet')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006261),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
