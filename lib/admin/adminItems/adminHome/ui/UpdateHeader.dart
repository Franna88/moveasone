import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../adminHomeItems/writeAMessage.dart';

class UpdateHeader extends StatefulWidget {
  final bool showButton;

  const UpdateHeader({
    super.key,
    this.showButton = false,
  });

  @override
  State<UpdateHeader> createState() => _UpdateHeaderState();
}

class _UpdateHeaderState extends State<UpdateHeader>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> _headerData = {};
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Modern color palette
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF7FB2DE);
  final Color accentColor = const Color(0xFFA3E1DB);
  final Color textColorLight = const Color(0xFFF8FFFA);

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fetchHeaderData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchHeaderData() async {
    try {
      DocumentSnapshot headerSnapshot = await FirebaseFirestore.instance
          .collection('updateHeader')
          .doc('headerInfo')
          .get();

      if (headerSnapshot.exists) {
        setState(() {
          _headerData = headerSnapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
        // Start animations after data is loaded
        _animationController.forward();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching header data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.black.withOpacity(0.05),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image with subtle blur effect
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: const [0.7, 1.0],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            _headerData['imageUrl'] ?? 'https://via.placeholder.com/800x400',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: primaryColor.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: primaryColor.withOpacity(0.5),
                    size: 64,
                  ),
                ),
              );
            },
          ),
        ),

        // Gradient overlay for better text contrast
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
        ),

        // Content
        widget.showButton ? _buildFullContent(context) : Container(),
      ],
    );
  }

  Widget _buildFullContent(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Header text with modern styling
              Text(
                _headerData['headerText'] ?? 'Mindful Movement',
                style: TextStyle(
                  color: textColorLight,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle text with improved readability
              Text(
                _headerData['subtitleText'] ??
                    'You have the power to decide to be great. Let\'s start now!',
                style: TextStyle(
                  color: textColorLight.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 4.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Modern style button with hover effect
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteAMessage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Update App Header',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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
}
