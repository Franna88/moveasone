import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:move_as_one/userSide/Home/WorkshopRoom.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class LiveWorkshops extends StatefulWidget {
  const LiveWorkshops({super.key});

  @override
  State<LiveWorkshops> createState() => _LiveWorkshopsState();
}

class _LiveWorkshopsState extends State<LiveWorkshops>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final UiColors _colors = UiColors();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgLight,
      appBar: AppBar(
        backgroundColor: _colors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Live Workshops',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'In Progress'),
            Tab(text: 'My Workshops'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search workshops...',
                    prefixIcon: Icon(Icons.search, color: _colors.primaryBlue),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _colors.iceBlue,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Filter Chips
                Row(
                  children: [
                    const Text(
                      'Filter by: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All'),
                            _buildFilterChip('Today'),
                            _buildFilterChip('This Week'),
                            _buildFilterChip('Available'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWorkshopList('upcoming'),
                _buildWorkshopList('in-progress'),
                _buildMyWorkshopsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? filter : 'All';
          });
        },
        selectedColor: _colors.primaryBlue.withOpacity(0.2),
        checkmarkColor: _colors.primaryBlue,
        labelStyle: TextStyle(
          color: isSelected ? _colors.primaryBlue : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildWorkshopList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getWorkshopStream(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading workshops',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(status);
        }

        final workshops = _filterWorkshops(snapshot.data!.docs);

        if (workshops.isEmpty) {
          return _buildEmptyState(status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workshops.length,
            itemBuilder: (context, index) {
              final workshop = workshops[index];
              final data = workshop.data() as Map<String, dynamic>;
              return _buildWorkshopCard(workshop.id, data);
            },
          ),
        );
      },
    );
  }

  Widget _buildMyWorkshopsList() {
    if (_auth.currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Please sign in to view your workshops',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('workshops')
          .where('participants', arrayContains: {
            'id': _auth.currentUser!.uid,
            'name': _auth.currentUser!.displayName ?? 'Anonymous',
            'email': _auth.currentUser!.email,
          })
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading your workshops'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('registered');
        }

        final workshops = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workshops.length,
          itemBuilder: (context, index) {
            final workshop = workshops[index];
            final data = workshop.data() as Map<String, dynamic>;
            return _buildWorkshopCard(workshop.id, data, isRegistered: true);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    IconData icon;
    String title;
    String subtitle;

    switch (status) {
      case 'upcoming':
        icon = Icons.event_busy;
        title = 'No upcoming workshops';
        subtitle = 'Check back later for new workshops';
        break;
      case 'in-progress':
        icon = Icons.video_call_outlined;
        title = 'No live workshops';
        subtitle = 'No workshops are currently in progress';
        break;
      case 'registered':
        icon = Icons.bookmark_border;
        title = 'No registered workshops';
        subtitle = 'Join a workshop to see it here';
        break;
      default:
        icon = Icons.event_note;
        title = 'No workshops found';
        subtitle = 'Try adjusting your filters';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(String workshopId, Map<String, dynamic> data,
      {bool isRegistered = false}) {
    DateTime? date;
    try {
      date = (data['date'] as Timestamp?)?.toDate();
    } catch (e) {
      print('Error parsing date: $e');
    }

    final isToday = date != null &&
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    final participants = data['participants'] as List? ?? [];
    final maxParticipants = data['maxParticipants'] ?? 0;
    final isFull = participants.length >= maxParticipants;
    final status = data['status'] as String? ?? 'upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with background image/gradient
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _colors.primaryBlue.withOpacity(0.8),
                  _colors.paleTurquoise.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (data['imageUrl'] != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        data['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  ),
                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _colors.lemon,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          if (isFull) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Full',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      // Title
                      Text(
                        data['title'] ?? 'Untitled Workshop',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (data['description'] != null) ...[
                  Text(
                    data['description'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                ],
                // Workshop details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.calendar_today,
                        date != null
                            ? DateFormat('MMM dd, yyyy').format(date)
                            : 'Date TBA',
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.access_time,
                        data['time'] ?? 'Time TBA',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.people,
                        '${participants.length}/$maxParticipants participants',
                      ),
                    ),
                    if (isRegistered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _colors.lightMoss.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Registered',
                          style: TextStyle(
                            color: _colors.lightMoss,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    if (status == 'in-progress') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _joinWorkshop(
                            workshopId,
                            data['title'] ?? 'Untitled Workshop',
                          ),
                          icon: const Icon(Icons.video_call, size: 18),
                          label: const Text('Join Live'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colors.lightMoss,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ] else if (status == 'upcoming') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isFull
                              ? null
                              : () => _joinWorkshop(
                                    workshopId,
                                    data['title'] ?? 'Untitled Workshop',
                                  ),
                          icon: Icon(
                            isRegistered ? Icons.login : Icons.event_available,
                            size: 18,
                          ),
                          label: Text(isRegistered ? 'Enter' : 'Join Workshop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => _showWorkshopDetails(workshopId, data),
                      icon: const Icon(Icons.info_outline),
                      style: IconButton.styleFrom(
                        backgroundColor: _colors.iceBlue,
                        foregroundColor: _colors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return _colors.lightBlue;
      case 'in-progress':
        return _colors.lightMoss;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'upcoming':
        return 'Upcoming';
      case 'in-progress':
        return 'Live';
      case 'completed':
        return 'Completed';
      default:
        return status.toUpperCase();
    }
  }

  Stream<QuerySnapshot> _getWorkshopStream(String status) {
    Query query = FirebaseFirestore.instance.collection('workshops');

    if (status != 'all') {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('date', descending: false).snapshots();
  }

  List<QueryDocumentSnapshot> _filterWorkshops(
      List<QueryDocumentSnapshot> workshops) {
    List<QueryDocumentSnapshot> filtered = workshops;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final title = (data['title'] as String?)?.toLowerCase() ?? '';
        final description =
            (data['description'] as String?)?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Filter by selected filter
    if (_selectedFilter != 'All') {
      final now = DateTime.now();
      filtered = filtered.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        DateTime? date;
        try {
          date = (data['date'] as Timestamp?)?.toDate();
        } catch (e) {
          return false;
        }

        switch (_selectedFilter) {
          case 'Today':
            return date != null &&
                date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;
          case 'This Week':
            if (date == null) return false;
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            final weekEnd = weekStart.add(const Duration(days: 6));
            return date.isAfter(weekStart) && date.isBefore(weekEnd);
          case 'Available':
            final participants = data['participants'] as List? ?? [];
            final maxParticipants = data['maxParticipants'] ?? 0;
            return participants.length < maxParticipants;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  Future<void> _joinWorkshop(String workshopId, String title) async {
    if (_auth.currentUser == null) {
      _showSnackBar('Please sign in to join workshops', isError: true);
      return;
    }

    // Simple loading indicator using snackbar instead of dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Joining workshop...'),
          ],
        ),
        backgroundColor: _colors.primaryBlue,
        duration: Duration(milliseconds: 800), // Shorter duration
      ),
    );

    try {
      final workshopRef =
          FirebaseFirestore.instance.collection('workshops').doc(workshopId);
      final workshopDoc = await workshopRef.get();

      // Dismiss loading snackbar regardless of result
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (!workshopDoc.exists) {
        _showSnackBar('Workshop not found', isError: true);
        return;
      }

      final workshop = workshopDoc.data() as Map<String, dynamic>;
      final currentParticipants = workshop['participants'] as List? ?? [];
      final maxParticipants = workshop['maxParticipants'] ?? 20;

      if (currentParticipants.length >= maxParticipants) {
        _showSnackBar('Workshop is full', isError: true);
        return;
      }

      final isRegistered =
          currentParticipants.any((p) => p['id'] == _auth.currentUser!.uid);

      if (!isRegistered) {
        await workshopRef.update({
          'participants': FieldValue.arrayUnion([
            {
              'id': _auth.currentUser!.uid,
              'name': _auth.currentUser!.displayName ?? 'Anonymous',
              'email': _auth.currentUser!.email,
              'joinedAt': DateTime.now().toIso8601String(),
            }
          ]),
        });

        _showSnackBar('Successfully joined workshop!');
      }

      // Navigate to workshop room
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkshopRoom(
              workshopId: workshopId,
              workshopTitle: title,
              isHost: false,
            ),
          ),
        );
      }
    } catch (e) {
      // Ensure snackbar is dismissed on error too
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showSnackBar('Error joining workshop: $e', isError: true);
    }
  }

  void _showWorkshopDetails(String workshopId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] ?? 'Untitled Workshop',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (data['description'] != null) ...[
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Workshop Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Workshop details in a card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _colors.iceBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Date', () {
                            DateTime? date;
                            try {
                              date = (data['date'] as Timestamp?)?.toDate();
                            } catch (e) {
                              return 'Date TBA';
                            }
                            return date != null
                                ? DateFormat('EEEE, MMMM dd, yyyy').format(date)
                                : 'Date TBA';
                          }()),
                          _buildDetailRow('Time', data['time'] ?? 'Time TBA'),
                          _buildDetailRow('Duration',
                              '${data['duration'] ?? 'TBA'} minutes'),
                          _buildDetailRow(
                            'Participants',
                            '${(data['participants'] as List?)?.length ?? 0}/${data['maxParticipants'] ?? 0}',
                          ),
                          _buildDetailRow('Status',
                              _getStatusText(data['status'] ?? 'upcoming')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Participants section
                    const Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('workshops')
                          .doc(workshopId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final workshop =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final participants =
                            workshop['participants'] as List? ?? [];

                        if (participants.isEmpty) {
                          return const Text('No participants yet');
                        }

                        return Column(
                          children: participants.map((participant) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _colors.primaryBlue,
                                child: Text(
                                  (participant['name'] as String?)
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(participant['name'] ?? 'Anonymous'),
                              subtitle: Text(participant['email'] ?? ''),
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _colors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : _colors.lightMoss,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLoadingDialog() {
    try {
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing by tapping outside
        builder: (BuildContext dialogContext) {
          // Auto-dismiss after 10 seconds as failsafe
          Future.delayed(Duration(seconds: 10), () {
            if (mounted && Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6699CC)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Joining workshop...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      if (Navigator.canPop(dialogContext)) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF6699CC),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error showing loading dialog: $e');
    }
  }
}
