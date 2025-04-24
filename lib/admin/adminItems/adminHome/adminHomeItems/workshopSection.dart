import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:move_as_one/userSide/Home/WorkshopRoom.dart';

class WorkshopSection extends StatefulWidget {
  const WorkshopSection({super.key});

  @override
  State<WorkshopSection> createState() => _WorkshopSectionState();
}

class _WorkshopSectionState extends State<WorkshopSection> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _maxParticipantsController =
      TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Enhanced color palette
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF03A696);
  final Color accentColor = const Color(0xFFE6F4F1);
  final Color backgroundColor = const Color(0xFFFAFAFA);
  final Color energyColor = const Color(0xFFF6E7CB);
  final Color darkColor = const Color(0xFF01373A);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _createWorkshop() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _maxParticipantsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('workshops').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _selectedDate,
        'time': _selectedTime?.format(context),
        'maxParticipants': int.parse(_maxParticipantsController.text),
        'participants': [],
        'status': 'upcoming',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _timeController.clear();
      _maxParticipantsController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workshop created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating workshop: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startWorkshop(String workshopId, String title) async {
    try {
      // Update workshop status to 'in-progress'
      await FirebaseFirestore.instance
          .collection('workshops')
          .doc(workshopId)
          .update({
        'status': 'in-progress',
        'startedAt': FieldValue.serverTimestamp(),
      });

      // Navigate to workshop room
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkshopRoom(
            workshopId: workshopId,
            workshopTitle: title,
            isHost: true,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting workshop: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewParticipants(String workshopId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              'Workshop Participants',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workshops')
                  .doc(workshopId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading participants'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final workshop = snapshot.data?.data() as Map<String, dynamic>;
                final participants =
                    workshop['participants'] as List<dynamic>? ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              participant['name'][0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  participant['name'],
                                  style: TextStyle(
                                    color: darkColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  participant['email'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [primaryColor, secondaryColor],
              ).createShader(bounds),
              child: Text(
                'Workshop Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Create Workshop Form
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: darkColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Create New Workshop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Workshop Title',
                    icon: Icons.title,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 2,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          controller: _dateController,
                          label: 'Date',
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildDateField(
                          controller: _timeController,
                          label: 'Time',
                          onTap: () => _selectTime(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: _maxParticipantsController,
                    label: 'Maximum Participants',
                    icon: Icons.people,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createWorkshop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Center(
                      child: Text(
                        'Create Workshop',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Upcoming Workshops List
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_available,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Upcoming Workshops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workshops')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final workshops = snapshot.data?.docs ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: workshops.length,
                  itemBuilder: (context, index) {
                    final workshop =
                        workshops[index].data() as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: darkColor.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Workshop Header
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    workshop['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    '${workshop['participants'].length}/${workshop['maxParticipants']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Workshop Content
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workshop['description'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${workshop['date']} at ${workshop['time']}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _startWorkshop(workshops[index].id,
                                            workshop['title']);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                            color: primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Text('Start Workshop'),
                                    ),
                                    SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        _viewParticipants(workshops[index].id);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: secondaryColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                            color: secondaryColor,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Text('View Participants'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: accentColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: accentColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            label == 'Date' ? Icons.calendar_today : Icons.access_time,
            color: primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: accentColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: accentColor),
          ),
          filled: true,
          fillColor: accentColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
