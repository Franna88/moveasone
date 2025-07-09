class AdminConfig {
  // Admin account ID that receives all trainer messages
  static const String ADMIN_USER_ID = 'rachelle_admin_id';

  // Display name for the admin when users message trainers
  static const String ADMIN_DISPLAY_NAME = 'Rachelle';

  // Default profile picture for admin
  static const String ADMIN_PROFILE_PIC = 'images/comment1.jpg';

  // List of trainer names that should route to admin
  static const List<String> TRAINER_NAMES = [
    'Rachelle',
    'Rochelle', // Alternative spelling
    'Lena Rosser',
    // Add more trainer names as needed
  ];

  // Check if a user is a trainer (messages should go to admin)
  static bool isTrainer(String userName) {
    return TRAINER_NAMES
        .any((trainer) => trainer.toLowerCase() == userName.toLowerCase());
  }

  // Get admin user info for messaging
  static Map<String, String> getAdminInfo() {
    return {
      'userId': ADMIN_USER_ID,
      'displayName': ADMIN_DISPLAY_NAME,
      'profilePic': ADMIN_PROFILE_PIC,
    };
  }
}
