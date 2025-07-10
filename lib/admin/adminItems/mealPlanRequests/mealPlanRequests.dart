import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class MealPlanRequests extends StatefulWidget {
  const MealPlanRequests({super.key});

  @override
  State<MealPlanRequests> createState() => _MealPlanRequestsState();
}

class _MealPlanRequestsState extends State<MealPlanRequests> {
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF94D8E0);
  final Color accentColor = const Color(0xFFEDCBA4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'MEAL PLAN REQUESTS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mealPlanRequests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Error loading meal plan requests',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'No pending meal plan requests',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'New meal plan requests will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final mealPlanRequests = snapshot.data!.docs;

          // Sort by createdAt in descending order (newest first)
          mealPlanRequests.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aCreatedAt = aData['createdAt'];
            final bCreatedAt = bData['createdAt'];

            if (aCreatedAt == null && bCreatedAt == null) return 0;
            if (aCreatedAt == null) return 1;
            if (bCreatedAt == null) return -1;

            final aTimestamp = aCreatedAt as Timestamp;
            final bTimestamp = bCreatedAt as Timestamp;

            return bTimestamp.compareTo(aTimestamp); // Descending order
          });

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: mealPlanRequests.length,
            itemBuilder: (context, index) {
              final request = mealPlanRequests[index];
              final data = request.data() as Map<String, dynamic>;

              return _buildMealPlanRequestItem(
                userName: data['name'] ?? 'Unknown User',
                email: data['email'] ?? '',
                phone: data['phone'] ?? '',
                goal: data['goal'] ?? '',
                activityLevel: data['activityLevel'] ?? '',
                dietType: data['dietType'] ?? '',
                budget: data['budget'] ?? '',
                allergies: data['allergies'] ?? '',
                notes: data['notes'] ?? '',
                createdAt: data['createdAt'],
                documentId: request.id,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMealPlanRequestItem({
    required String userName,
    required String email,
    required String phone,
    required String goal,
    required String activityLevel,
    required String dietType,
    required String budget,
    required String allergies,
    required String notes,
    required dynamic createdAt,
    required String documentId,
  }) {
    return GestureDetector(
      onTap: () {
        _showMealPlanDetails(
          userName: userName,
          email: email,
          phone: phone,
          goal: goal,
          activityLevel: activityLevel,
          dietType: dietType,
          budget: budget,
          allergies: allergies,
          notes: notes,
          createdAt: createdAt,
          documentId: documentId,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: accentColor,
              radius: 24,
              child: Icon(
                Icons.restaurant,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          email,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.fitness_center, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '$goal • $dietType',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        budget,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Requested ${_formatTimestamp(createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showMealPlanDetails({
    required String userName,
    required String email,
    required String phone,
    required String goal,
    required String activityLevel,
    required String dietType,
    required String budget,
    required String allergies,
    required String notes,
    required dynamic createdAt,
    required String documentId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.restaurant, color: primaryColor),
            SizedBox(width: 8),
            Text(
              'Meal Plan Request Details',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Name', userName),
              _buildDetailRow('Email', email),
              _buildDetailRow('Phone', phone),
              _buildDetailRow('Goal', goal),
              _buildDetailRow('Activity Level', activityLevel),
              _buildDetailRow('Diet Type', dietType),
              _buildDetailRow('Budget', budget),
              if (allergies.isNotEmpty) _buildDetailRow('Allergies', allergies),
              if (notes.isNotEmpty) _buildDetailRow('Notes', notes),
              _buildDetailRow('Requested', _formatTimestamp(createdAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              _updateMealPlanStatus(documentId, 'rejected');
              Navigator.pop(context);
            },
            child: Text(
              'Reject',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _updateMealPlanStatus(documentId, 'approved');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Approve'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMealPlanStatus(String documentId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('mealPlanRequests')
          .doc(documentId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meal plan request $status successfully'),
          backgroundColor: status == 'approved' ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating meal plan request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    try {
      final Timestamp ts = timestamp as Timestamp;
      final DateTime dateTime = ts.toDate();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}
