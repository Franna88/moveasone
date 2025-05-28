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
  final Color primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final Color secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
  final Color accentColor = const Color(0xFFEDCBA4); // Toffee
  final Color backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream
  final Color energyColor = const Color(0xFFF5DEB3); // Sand
  final Color darkColor = const Color(0xFF5980B5); // Deeper Cornflower

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
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(bottom: 24),
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
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24),
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
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              participant['name'][0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'WORKSHOP MANAGEMENT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Create Workshop Form
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: darkColor.withOpacity(0.08),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Create New Workshop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: Center(
                      child: Text(
                        'CREATE WORKSHOP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_available,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Upcoming Workshops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
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
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: darkColor.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Workshop Header
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
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
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${workshop['participants'].length}/${workshop['maxParticipants']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Workshop Content
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workshop['description'],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: secondaryColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${workshop['date']} at ${workshop['time']}',
                                      style: TextStyle(
                                        color: darkColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _startWorkshop(workshops[index].id,
                                            workshop['title']);
                                      },
                                      icon: Icon(Icons.play_circle_outlined,
                                          size: 18),
                                      label: Text('START'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _viewParticipants(workshops[index].id);
                                      },
                                      icon:
                                          Icon(Icons.people_outline, size: 18),
                                      label: Text('PARTICIPANTS'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: secondaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
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
        labelStyle: TextStyle(
          color: primaryColor.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        filled: true,
        fillColor: secondaryColor.withOpacity(0.08),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
          labelStyle: TextStyle(
            color: primaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            label == 'Date' ? Icons.calendar_today : Icons.access_time,
            color: primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
          ),
          filled: true,
          fillColor: secondaryColor.withOpacity(0.08),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
