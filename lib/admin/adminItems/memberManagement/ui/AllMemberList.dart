import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';

class AllMemberList extends StatefulWidget {
  const AllMemberList({super.key});

  @override
  State<AllMemberList> createState() => _AllMemberListState();
}

class _AllMemberListState extends State<AllMemberList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Active', 'Inactive'];

  // Modern color scheme
  final Color primaryColor = const Color(0xFF6A3EA1); // Purple
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color backgroundColor = const Color(0xFFF7F5FA); // Light purple tint

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'MEMBERS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: primaryColor),
            onPressed: () {
              _showFilterSheet(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon:
                    Icon(Icons.search, color: primaryColor.withOpacity(0.7)),
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Tab selector
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          _selectedTab == index ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _selectedTab == index
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              )
                            ],
                    ),
                    child: Center(
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: _selectedTab == index
                              ? Colors.white
                              : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Members list
          Expanded(
            child: _buildMembersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Functionality to add a new member or perform another action
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add new member functionality')));
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('All Members', Icons.people),
              _buildFilterOption(
                  'Active Last Week', Icons.check_circle_outline),
              _buildFilterOption(
                  'Inactive Members', Icons.remove_circle_outline),
              _buildFilterOption('New Members', Icons.new_releases_outlined),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: secondaryColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(Icons.check_circle, color: primaryColor),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    // Stream that listens to changes in the users collection
    Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Handling errors
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Showing loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading members...',
                  style: TextStyle(color: primaryColor, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Handling empty data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No members found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Filter out admins and apply search filter
        var filteredMembers = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Skip admin users
          if (data['status'] == 'admin') {
            return false;
          }

          // Apply tab filters
          if (_selectedTab == 1) {
            // Active
            // Check if user has been active in the last 7 days
            final lastActive = data['lastActive'] as Timestamp?;
            if (lastActive == null) return false;

            final now = DateTime.now();
            final lastActiveDate = lastActive.toDate();
            return now.difference(lastActiveDate).inDays <= 7;
          } else if (_selectedTab == 2) {
            // Inactive
            // Check if user has NOT been active in the last 7 days
            final lastActive = data['lastActive'] as Timestamp?;
            if (lastActive == null) return true;

            final now = DateTime.now();
            final lastActiveDate = lastActive.toDate();
            return now.difference(lastActiveDate).inDays > 7;
          }

          // Apply search filter
          if (_searchQuery.isNotEmpty) {
            String name = (data['name'] ?? '').toLowerCase();
            String email = (data['email'] ?? '').toLowerCase();
            return name.contains(_searchQuery) || email.contains(_searchQuery);
          }

          return true;
        }).toList();

        if (filteredMembers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_search, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No members match "$_searchQuery"'
                      : 'No members found for the selected filter',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Mapping Firestore documents to WatchMemberModel
        var members = filteredMembers.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          bool isWatched = data['isWatched'] ?? false;

          return WatchMemberModel(
            userId: document.id,
            memberName: data['name'] ?? 'Unknown Name',
            memberEmail: data['email'] ?? '',
            memberImage: data['profilePic'] ?? '',
            memberBio: data['bio'] ?? 'No bio available',
            memberWebsite: data['website'] ?? '',
            isWatched: isWatched,
            age: data['age'] ?? '',
            gender: data['gender'] ?? '',
            goal: data['goal'] ?? '',
          );
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberProfile(
                        userId: member.userId,
                        memberName: member.memberName,
                        memberImage: member.memberImage,
                        memberBio: member.memberBio,
                        memberWebsite: member.memberWebsite,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: member.isWatched
                        ? LinearGradient(
                            colors: [
                              const Color(0xFFFFF9C4).withOpacity(0.4),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with status indicator
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 28,
                              backgroundImage: member.memberImage.isNotEmpty
                                  ? NetworkImage(member.memberImage)
                                  : null,
                              child: member.memberImage.isEmpty
                                  ? Text(
                                      member.memberName.isNotEmpty
                                          ? member.memberName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _selectedTab == 1
                                    ? Colors.green
                                    : (_selectedTab == 2
                                        ? Colors.red
                                        : Colors.grey),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Member info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  member.memberName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                if (member.isWatched) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: secondaryColor,
                                  ),
                                ],
                              ],
                            ),
                            if (member.memberEmail.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                member.memberEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            if (member.age.isNotEmpty ||
                                member.gender.isNotEmpty ||
                                member.goal.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (member.age.isNotEmpty)
                                    _buildTag('${member.age} years',
                                        Icons.cake_outlined),
                                  if (member.gender.isNotEmpty)
                                    _buildTag(
                                        member.gender,
                                        member.gender.toLowerCase() == 'male'
                                            ? Icons.male
                                            : Icons.female),
                                  if (member.goal.isNotEmpty)
                                    _buildTag(member.goal, Icons.flag_outlined),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Watch button
                      WatchButton(
                        userId: member.userId,
                        isWatched: member.isWatched,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTag(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: secondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// Model to represent a member
class WatchMemberModel {
  final String userId;
  final String memberName;
  final String memberEmail;
  final String memberImage;
  final String memberBio;
  final String memberWebsite;
  final bool isWatched;
  final String age;
  final String gender;
  final String goal;

  WatchMemberModel({
    required this.userId,
    required this.memberName,
    this.memberEmail = '',
    required this.memberImage,
    required this.memberBio,
    required this.memberWebsite,
    this.isWatched = false,
    this.age = '',
    this.gender = '',
    this.goal = '',
  });
}
