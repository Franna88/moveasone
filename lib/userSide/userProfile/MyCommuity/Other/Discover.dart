import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> currentUserFriends = [];
  bool _isLoading = true;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF01B3B3);
  final Color accentColor = const Color(0xFF94FBAB);
  final Color subtleColor = const Color(0xFFE5F9E0);
  final Color backgroundColor = const Color(0xFFF8FFFA);

  Future<void> _refreshFriends() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(Duration(milliseconds: 500), () {
      _fetchCurrentUserFriends();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fetchCurrentUserFriends();
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _fetchCurrentUserFriends() async {
    setState(() {
      _isLoading = true;
    });

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userRef = _firestore.collection('users').doc(currentUser.uid);
      try {
        final userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          List friendsList = userSnapshot.get('friendsList') ?? [];
          setState(() {
            currentUserFriends = friendsList
                .where((friend) => friend is Map<String, dynamic>)
                .map<String>((friend) =>
                    (friend as Map<String, dynamic>)['id'] as String)
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            currentUserFriends = [];
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching friends: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text(
          'You must be signed in to view this page',
          style: TextStyle(color: primaryColor),
        ),
      );
    }

    return Column(
      children: [
        // Search bar with wellness theme
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for new friends...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: secondaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),

        // Users list with animation
        Expanded(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .where(FieldPath.documentId,
                          isNotEqualTo: currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        _isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(secondaryColor),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[300],
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    var users = snapshot.data!.docs;
                    var filteredUsers = users.where((user) {
                      final userId = user.id;

                      if (currentUserFriends.contains(userId)) {
                        return false;
                      }

                      if (_searchQuery.isEmpty) {
                        return true;
                      }

                      final userData = user.data() as Map<String, dynamic>;
                      final userName =
                          (userData['name'] as String? ?? '').toLowerCase();
                      return userName.contains(_searchQuery);
                    }).toList();

                    if (filteredUsers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: Colors.grey[400],
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: secondaryColor,
                      onRefresh: _refreshFriends,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final userData = user.data() as Map<String, dynamic>;
                          final userId = user.id;
                          final userName = userData['name'] ?? 'No Name';
                          final userPicture = userData['profilePic'] ?? '';

                          final delay = 0.2 + (index * 0.1);
                          final delayedAnimation = CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(delay.clamp(0.0, 1.0), 1.0,
                                curve: Curves.easeOut),
                          );

                          return AnimatedBuilder(
                            animation: delayedAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                    30 * (1 - delayedAnimation.value), 0),
                                child: Opacity(
                                  opacity: delayedAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildUserCard(
                              userId,
                              userName,
                              userPicture,
                              userData['bio'] as String? ?? 'No bio available',
                              userData['fitnessLevel'] as String? ?? 'Beginner',
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
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
              Icons.people_outline,
              size: 80,
              color: primaryColor.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No users to discover',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Come back later to find new connections',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String userId, String name, String picture, String bio,
      String fitnessLevel) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // View user profile
        },
        splashColor: accentColor.withOpacity(0.1),
        highlightColor: accentColor.withOpacity(0.05),
        child: Column(
          children: [
            // User header with background gradient
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      secondaryColor,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // User info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Profile picture
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: picture.isNotEmpty
                                  ? Image.network(
                                      picture,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Name and fitness level
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    fitnessLevel,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bio section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bio',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    bio.length > 100 ? bio.substring(0, 100) + '...' : bio,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // View profile
                    },
                    icon: Icon(Icons.person_outline),
                    label: Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Send friend request
                    },
                    icon: Icon(Icons.person_add_alt),
                    label: Text('Add Friend'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
