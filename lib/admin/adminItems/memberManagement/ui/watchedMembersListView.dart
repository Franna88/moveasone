import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/WatchedMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';

class WatchedMembersListView extends StatefulWidget {
  final MemberFilterType filterType;

  const WatchedMembersListView({super.key, required this.filterType});

  @override
  State<WatchedMembersListView> createState() => _WatchedMembersListViewState();
}

class _WatchedMembersListViewState extends State<WatchedMembersListView> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    // Stream that listens to changes in the users collection
    Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Container(
      width: widthDevice,
      height: heightDevice * 0.90,
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handling errors
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          // Showing loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Handling empty data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          // Get the current date and time
          DateTime now = DateTime.now();

          // Filter users based on the filter type and exclude admins
          var filteredMembers =
              snapshot.data!.docs.where((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Skip admin users completely
            if (data['status'] == 'admin') {
              return false;
            }

            // Apply the selected filter
            switch (widget.filterType) {
              case MemberFilterType.threeDay:
                // Filter for users who haven't worked out in the last 3 days
                return _checkInactivityDays(data, now, 3);

              case MemberFilterType.sixDay:
                // Filter for users who haven't worked out in the last 6 days
                return _checkInactivityDays(data, now, 6);

              case MemberFilterType.lowMotivation:
                // Filter for users with low motivation score
                return _checkLowMotivation(data);

              case MemberFilterType.watched:
                // Filter for users marked as watched
                return _checkWatchedStatus(data);

              case MemberFilterType.all:
                // No filter, show all users except admins
                return true;
            }
          }).toList();

          // Handling empty filtered data
          if (filteredMembers.isEmpty) {
            String message = 'No members found';

            switch (widget.filterType) {
              case MemberFilterType.threeDay:
                message =
                    'No users found who haven\'t logged a workout in the last 3 days';
                break;
              case MemberFilterType.sixDay:
                message =
                    'No users found who haven\'t logged a workout in the last 6 days';
                break;
              case MemberFilterType.lowMotivation:
                message = 'No users found with low motivation';
                break;
              case MemberFilterType.watched:
                message = 'No users are currently being watched';
                break;
              case MemberFilterType.all:
                message = 'No users found';
                break;
            }

            return Center(child: Text(message));
          }

          // Mapping Firestore documents to WatchMemberModel
          var watchedMembers = filteredMembers.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return WatchMemberModel(
              userId: document.id,
              memberName: data['name'] ?? 'Unknown Name',
              memberImage: data['profilePic'] ?? '',
              memberBio: data['bio'] ?? 'No bio available',
              memberWebsite: data['website'] ?? '',
              isWatched: data['isWatched'] ?? false,
              motivationScore: data['motivationScore'] ?? 50,
              age: data['age'] ?? '',
              gender: data['gender'] ?? '',
              goal: data['goal'] ?? '',
              lastWorkoutDate: _getLastWorkoutDate(data),
              daysSinceLastWorkout: data['daysSinceLastWorkout'] ?? 0,
            );
          }).toList();

          return ListView.builder(
            itemCount: watchedMembers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberProfile(
                        userId: watchedMembers[index].userId,
                        memberName: watchedMembers[index].memberName,
                        memberImage: watchedMembers[index].memberImage,
                        memberBio: watchedMembers[index].memberBio,
                        memberWebsite: watchedMembers[index].memberWebsite,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Member avatar
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 28,
                              backgroundImage:
                                  watchedMembers[index].memberImage.isNotEmpty
                                      ? NetworkImage(
                                          watchedMembers[index].memberImage)
                                      : const AssetImage('images/avatar1.png')
                                          as ImageProvider,
                            ),
                            const SizedBox(width: 16),

                            // Member details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name and age
                                  Row(
                                    children: [
                                      Text(
                                        watchedMembers[index].memberName,
                                        style: const TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (watchedMembers[index]
                                          .age
                                          .isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          '(${watchedMembers[index].age})',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Gender and goal if available
                                  if (watchedMembers[index].gender.isNotEmpty ||
                                      watchedMembers[index].goal.isNotEmpty)
                                    Text(
                                      '${watchedMembers[index].gender}${watchedMembers[index].gender.isNotEmpty && watchedMembers[index].goal.isNotEmpty ? " • " : ""}${watchedMembers[index].goal}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  const SizedBox(height: 4),

                                  // Last workout info
                                  Row(
                                    children: [
                                      Icon(Icons.fitness_center,
                                          size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        watchedMembers[index].lastWorkoutDate ==
                                                null
                                            ? 'No workouts yet'
                                            : 'Last workout: ${_formatLastWorkout(watchedMembers[index].daysSinceLastWorkout)}',
                                        style: TextStyle(
                                          color: _getInactivityColor(
                                              watchedMembers[index]
                                                  .daysSinceLastWorkout),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Motivation score
                                  if (widget.filterType ==
                                          MemberFilterType.lowMotivation ||
                                      watchedMembers[index].motivationScore <
                                          40) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 8,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.grey[200],
                                          ),
                                          child: LinearProgressIndicator(
                                            value: watchedMembers[index]
                                                    .motivationScore /
                                                100,
                                            backgroundColor: Colors.transparent,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              _getMotivationColor(
                                                  watchedMembers[index]
                                                      .motivationScore),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${watchedMembers[index].motivationScore}%',
                                          style: TextStyle(
                                            color: _getMotivationColor(
                                                watchedMembers[index]
                                                    .motivationScore),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Watch button
                            WatchButton(
                              userId: watchedMembers[index].userId,
                              isWatched: watchedMembers[index].isWatched,
                            ),
                          ],
                        ),

                        // Reason for watching (if available)
                        if ((watchedMembers[index].isWatched ||
                                widget.filterType ==
                                    MemberFilterType.watched) &&
                            (watchedMembers[index].daysSinceLastWorkout >= 6 ||
                                watchedMembers[index].motivationScore <
                                    30)) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber,
                                    size: 16, color: Colors.orange[700]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _getWatchReason(
                                        watchedMembers[index]
                                            .daysSinceLastWorkout,
                                        watchedMembers[index].motivationScore),
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to check if a user hasn't worked out in X days
  bool _checkInactivityDays(
      Map<String, dynamic> userData, DateTime now, int days) {
    // If we have the days since last workout already calculated, use that
    if (userData.containsKey('daysSinceLastWorkout')) {
      return (userData['daysSinceLastWorkout'] ?? 0) >= days;
    }

    // Otherwise, calculate from userExercises
    List<dynamic> userExercises = userData['userExercises'] ?? [];

    // Find the latest workout date
    DateTime? lastWorkoutDate;
    if (userExercises.isNotEmpty) {
      lastWorkoutDate = userExercises
          .map((exercise) => DateTime.parse(exercise['date']))
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }

    // Check if the last workout date is more than X days ago
    return lastWorkoutDate == null ||
        now.difference(lastWorkoutDate).inDays >= days;
  }

  // Helper function to check if a user has low motivation
  bool _checkLowMotivation(Map<String, dynamic> userData) {
    // Get the motivation score, defaulting to 50 if not set
    int motivationScore = userData['motivationScore'] ?? 50;

    // Consider motivation low if below 30%
    return motivationScore < 30;
  }

  // Helper function to check if a user is being watched
  bool _checkWatchedStatus(Map<String, dynamic> userData) {
    // Check if user is marked as watched
    return userData['isWatched'] == true;
  }

  // Helper function to get color based on motivation score
  Color _getMotivationColor(int score) {
    if (score < 30) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  // Helper function to get color based on days since last workout
  Color _getInactivityColor(int days) {
    if (days >= 6) return Colors.red;
    if (days >= 3) return Colors.orange;
    return Colors.green;
  }

  // Helper function to get the last workout date
  DateTime? _getLastWorkoutDate(Map<String, dynamic> userData) {
    if (userData.containsKey('lastWorkoutDate')) {
      return (userData['lastWorkoutDate'] as Timestamp?)?.toDate();
    }

    List<dynamic> userExercises = userData['userExercises'] ?? [];
    if (userExercises.isEmpty) return null;

    try {
      return userExercises
          .map((exercise) => DateTime.parse(exercise['date']))
          .reduce((a, b) => a.isAfter(b) ? a : b);
    } catch (e) {
      print('Error parsing workout dates: $e');
      return null;
    }
  }

  // Helper function to format the last workout text
  String _formatLastWorkout(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  // Helper function to generate watch reason text
  String _getWatchReason(int daysSinceLastWorkout, int motivationScore) {
    List<String> reasons = [];

    if (daysSinceLastWorkout >= 6) {
      reasons.add('Inactive for $daysSinceLastWorkout days');
    }

    if (motivationScore < 30) {
      reasons.add('Low motivation score ($motivationScore%)');
    }

    return reasons.join(', ');
  }
}

// Model to represent a watched member
class WatchMemberModel {
  final String userId;
  final String memberName;
  final String memberImage;
  final String memberBio;
  final String memberWebsite;
  final bool isWatched;
  final int motivationScore;
  final String age;
  final String gender;
  final String goal;
  final DateTime? lastWorkoutDate;
  final int daysSinceLastWorkout;

  WatchMemberModel({
    required this.userId,
    required this.memberName,
    required this.memberImage,
    required this.memberBio,
    required this.memberWebsite,
    this.isWatched = false,
    this.motivationScore = 50,
    this.age = '',
    this.gender = '',
    this.goal = '',
    this.lastWorkoutDate,
    this.daysSinceLastWorkout = 0,
  });
}
