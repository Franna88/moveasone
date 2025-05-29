import 'package:flutter/material.dart';

class MotivationalContainer extends StatelessWidget {
  final String image;
  final String motivational;
  final Color color;
  final VoidCallback onPress;
  final bool isPopular;

  const MotivationalContainer({
    Key? key,
    required this.image,
    required this.motivational,
    required this.color,
    required this.onPress,
    this.isPopular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Modern wellness color scheme
    final Color primaryColor = const Color(0xFF025959); // Deep Teal
    final Color secondaryColor = const Color(0xFF01B3B3); // Bright Teal
    final Color accentColor = const Color(0xFF94FBAB); // Mint/Lime
    final Color subtleColor = const Color(0xFFE5F9E0); // Pale Mint

    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play indicator
            Stack(
              children: [
                // Image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    image,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 110,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient overlay for better text visibility
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // Play button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Popular badge if applicable
                if (isPopular)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: primaryColor,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Popular',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Title and metadata
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motivational,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: secondaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Wellness',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
