import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/myutility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealPlanRequestPage extends StatefulWidget {
  const MealPlanRequestPage({super.key});

  @override
  State<MealPlanRequestPage> createState() => _MealPlanRequestPageState();
}

class _MealPlanRequestPageState extends State<MealPlanRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _notesController = TextEditingController();

  String selectedGoal = 'Weight Loss';
  String selectedActivityLevel = 'Moderate (3-5 days/week)';
  String selectedDietType = 'Balanced';
  String selectedMealCount = '3 meals + 2 snacks';
  String selectedBudget = 'Moderate (R500-1000/week)';

  final List<String> goals = [
    'Weight Loss',
    'Muscle Gain',
    'Weight Maintenance',
    'Improved Energy',
    'Better Health',
  ];

  final List<String> activityLevels = [
    'Sedentary (Little exercise)',
    'Light (1-3 days/week)',
    'Moderate (3-5 days/week)',
    'Very Active (6-7 days/week)',
    'Extremely Active (2x/day)',
  ];

  final List<String> dietTypes = [
    'Balanced',
    'Low Carb',
    'High Protein',
    'Vegetarian',
    'Vegan',
    'Keto',
    'Mediterranean',
    'Paleo',
  ];

  final List<String> mealCounts = [
    '3 meals only',
    '3 meals + 1 snack',
    '3 meals + 2 snacks',
    '5-6 small meals',
    'Custom',
  ];

  final List<String> budgets = [
    'Budget (R300-500/week)',
    'Moderate (R500-1000/week)',
    'Premium (R1000-1500/week)',
    'Luxury (R1500+/week)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: heightDevice,
          width: widthDevice,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Navigation Header
              HeaderWidget(header: 'REQUEST MEAL PLAN'),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'Request Meal Plan',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'BeVietnam',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6699CC),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 3,
                              width: MyUtility(context).width * 0.5,
                              decoration: BoxDecoration(
                                color: Color(0xFF6699CC),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Get a personalized nutrition plan tailored to your goals',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'BeVietnam',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Form Content
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Personal Information
                              _buildSectionTitle('Personal Information'),
                              _buildPersonalInfoSection(),

                              SizedBox(height: 24),

                              // Goals & Activity
                              _buildSectionTitle('Goals & Activity Level'),
                              _buildGoalSelection(),
                              SizedBox(height: 16),
                              _buildActivityLevelSelection(),

                              SizedBox(height: 24),

                              // Diet Preferences
                              _buildSectionTitle('Diet Preferences'),
                              _buildDietTypeSelection(),
                              SizedBox(height: 16),
                              _buildMealCountSelection(),

                              SizedBox(height: 24),

                              // Health Information
                              _buildSectionTitle('Health & Allergies'),
                              _buildAllergiesField(),

                              SizedBox(height: 24),

                              // Budget
                              _buildSectionTitle('Budget'),
                              _buildBudgetSelection(),

                              SizedBox(height: 24),

                              // Additional Notes
                              _buildSectionTitle('Additional Notes'),
                              _buildNotesField(),

                              SizedBox(height: 32),

                              // Submit Button
                              _buildSubmitButton(),

                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E1E1E),
          fontFamily: 'BeVietnam',
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration('Full Name *', Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('Email *', Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: _inputDecoration('Phone Number', Icons.phone),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: _inputDecoration('Height (cm)', Icons.height),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration:
                      _inputDecoration('Weight (kg)', Icons.fitness_center),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF6699CC)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF6699CC), width: 2),
      ),
      labelStyle: TextStyle(fontFamily: 'BeVietnam'),
    );
  }

  Widget _buildGoalSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Primary Goal',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'BeVietnam',
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map((goal) {
              bool isSelected = selectedGoal == goal;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGoal = goal;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF6699CC) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFF6699CC) : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    goal,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontFamily: 'BeVietnam',
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: activityLevels.map((level) {
          return RadioListTile<String>(
            title: Text(
              level,
              style: TextStyle(
                fontFamily: 'BeVietnam',
                fontSize: 14,
              ),
            ),
            value: level,
            groupValue: selectedActivityLevel,
            activeColor: Color(0xFF6699CC),
            onChanged: (value) {
              setState(() {
                selectedActivityLevel = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDietTypeSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diet Type',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'BeVietnam',
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dietTypes.map((diet) {
              bool isSelected = selectedDietType == diet;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDietType = diet;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF6699CC) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFF6699CC) : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    diet,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontFamily: 'BeVietnam',
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCountSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meal Structure',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'BeVietnam',
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mealCounts.map((count) {
              bool isSelected = selectedMealCount == count;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMealCount = count;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF6699CC) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFF6699CC) : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontFamily: 'BeVietnam',
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesField() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _allergiesController,
        decoration:
            _inputDecoration('Allergies & Dietary Restrictions', Icons.warning),
        maxLines: 3,
      ),
    );
  }

  Widget _buildBudgetSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: budgets.map((budget) {
          return RadioListTile<String>(
            title: Text(
              budget,
              style: TextStyle(
                fontFamily: 'BeVietnam',
                fontSize: 14,
              ),
            ),
            value: budget,
            groupValue: selectedBudget,
            activeColor: Color(0xFF6699CC),
            onChanged: (value) {
              setState(() {
                selectedBudget = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _notesController,
        decoration: _inputDecoration(
            'Additional Notes or Special Requests', Icons.note),
        maxLines: 4,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6699CC),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Submit Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnam',
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get current user
        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please login to request a meal plan')),
          );
          return;
        }

        // Save meal plan request to Firebase
        await FirebaseFirestore.instance.collection('mealPlanRequests').add({
          'userId': currentUser.uid,
          'userEmail': currentUser.email,
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'goal': selectedGoal,
          'activityLevel': selectedActivityLevel,
          'dietType': selectedDietType,
          'mealCount': selectedMealCount,
          'budget': selectedBudget,
          'allergies': _allergiesController.text,
          'notes': _notesController.text,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  'Request Submitted!',
                  style: TextStyle(
                    color: Color(0xFF6699CC),
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thank you for your meal plan request!',
                  style: TextStyle(fontSize: 16, fontFamily: 'BeVietnam'),
                ),
                SizedBox(height: 12),
                Text(
                  'Our nutrition experts will review your information and create a personalized meal plan for you.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'BeVietnam'),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📧 You will receive an email confirmation within 24 hours',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '📋 Your custom meal plan will be ready in 2-3 business days',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Reset form after submission
                  _formKey.currentState!.reset();
                  setState(() {
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _heightController.clear();
                    _weightController.clear();
                    _allergiesController.clear();
                    _notesController.clear();
                    selectedGoal = 'Weight Loss';
                    selectedActivityLevel = 'Moderate (3-5 days/week)';
                    selectedDietType = 'Balanced';
                    selectedMealCount = '3 meals + 2 snacks';
                    selectedBudget = 'Moderate (R500-1000/week)';
                  });
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFF6699CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting meal plan request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
