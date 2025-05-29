import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:move_as_one/userSide/userProfile/Sendhi5Back/Sendhi5Back.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _friendsList = [];

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF01B3B3);
  final Color accentColor = const Color(0xFF94FBAB);
  final Color subtleColor = const Color(0xFFE5F9E0);
  final Color backgroundColor = const Color(0xFFF8FFFA);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fetchFriends();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchFriends() async {
    setState(() {
      _isLoading = true;
    });

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        setState(() {
          _isLoading = false;
          _friendsList = [];
        });
        return;
      }

      final friendsList = userDoc['friendsList'] as List<dynamic>? ?? [];
      final friends = friendsList.where((friend) {
        if (friend is Map<String, dynamic>) {
          return friend['status'] == 'friend';
        }
        return false;
      }).toList();

      setState(() {
        _friendsList = List<Map<String, dynamic>>.from(friends);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching friends: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return Center(
        child: Text(
          'You must be signed in to view this page',
          style: TextStyle(color: primaryColor),
        ),
      );
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
            ),
          )
        : _friendsList.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                color: secondaryColor,
                onRefresh: _fetchFriends,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _friendsList.length,
                    itemBuilder: (context, index) {
                      return _buildFriendItem(_friendsList[index], index);
                    },
                  ),
                ),
              );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _animationController.value)),
                child: Opacity(
                  opacity: _animationController.value,
                  child: child,
                ),
              );
            },
            child: Icon(
              Icons.group_outlined,
              size: 80,
              color: primaryColor.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No friends yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Connect with others to build your community',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person_add),
            label: Text('Find Friends'),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(Map<String, dynamic> friend, int index) {
    final friendId = friend['id'] as String? ?? '';
    final delay = 0.2 + (index * 0.1);
    final delayedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(delay.clamp(0.0, 1.0), 1.0, curve: Curves.easeOut),
    );

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(friendId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox.shrink();
        }

        final friendData = snapshot.data!;
        final friendName = friendData['name'] as String? ?? 'Unknown User';
        final friendPicture = friendData['profilePic'] as String? ?? '';

        return AnimatedBuilder(
          animation: delayedAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - delayedAnimation.value), 0),
              child: Opacity(
                opacity: delayedAnimation.value,
                child: child,
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shadowColor: primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: subtleColor,
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sendhi5Back(
                      userId: friendId,
                      picture: friendPicture,
                      name: friendName,
                    ),
                  ),
                );
              },
              splashColor: accentColor.withOpacity(0.1),
              highlightColor: accentColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Profile picture with border
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: friendPicture.isNotEmpty
                            ? Image.network(
                                friendPicture,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: primaryColor.withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  color: primaryColor.withOpacity(0.7),
                                  size: 36,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Friend name and status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friendName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Friend',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action icons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: secondaryColor,
                            size: 22,
                          ),
                          onPressed: () {
                            // Message friend
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: secondaryColor,
                            size: 22,
                          ),
                          onPressed: () {
                            // Send hi5
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
