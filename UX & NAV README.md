# Move as One - Fitness Community App

## Overview

Move as One is a wellness and fitness community application designed to help users achieve their fitness goals through workouts, community support, and personalized content. The app offers a seamless experience for both regular users and administrators, with distinct navigation flows and features.

## App Structure & Navigation

### User Journey

#### 1. Onboarding & Authentication
- **Home Page** (`lib/HomePage.dart`): The entry point of the application featuring an elegant gradient background with the app's tagline "Unlock your ultimate potential."
- **Sign In** (`lib/userSide/LoginSighnUp/Login/Signin.dart`): Allows existing users to log in with email/password or social accounts.
- **Sign Up Flow** (Starting with `lib/userSide/InfoQuiz/Goal/Goal.dart`): New users go through a series of questions to set up their profile:
  - Fitness goals
  - Gender
  - Body measurements (height, weight)
  - Age
  - Activity level

#### 2. User Role Determination
- **User State** (`lib/Services/UserState.dart`): After authentication, this component checks the user's role (regular user or admin) and directs them to the appropriate interface.

#### 3. Regular User Interface
- **Bottom Navigation Bar** (`lib/BottomNavBar/BottomNavBar.dart`): The main navigation hub for regular users with 5 main sections:

  a. **Workouts** (`lib/userSide/Home/GetStarted.dart`):
  - Featured workouts
  - Daily recommendations
  - Progress tracking
  
  b. **Videos** (`lib/userSide/UserVideo/UserAddVideo.dart` and `lib/userSide/UserVideo/UserVideoView.dart`):
  - Browse workout videos
  - Save favorites
  - View personal video collection
  
  c. **Add** (`lib/userSide/userProfile/MyCommuity/Other/AllMessagesDisplay.dart`):
  - Central action button for creating content
  - Interact with community messages
  
  d. **Community** (`lib/userSide/userProfile/MyCommuity/MyCommnity.dart`):
  - Connect with other users
  - Share progress
  - Participate in challenges
  
  e. **Profile** (`lib/userSide/UserProfile/UserProfile.dart`):
  - Personal stats and progress
  - Account settings
  - Achievement tracking

#### 4. Admin Interface
- **Admin Dashboard** (`lib/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart`):
  - Content management
  - User statistics
  - Workout creation tools
  - Community management

## User Experience Features

### Regular Users

1. **Personalized Content**
   - Content tailored to the user's goals and preferences
   - Progress tracking and adaptive recommendations

2. **Workout Experience**
   - Video-guided workouts
   - Various difficulty levels and categories
   - Progress tracking

3. **Community Engagement**
   - Connect with like-minded individuals
   - Share achievements
   - Give and receive encouragement ("Hi-Five" system)

4. **Video Library**
   - Save favorite workouts
   - Create personal collections
   - Track completed workouts

### Admin Users

1. **Content Management**
   - Create and edit workout content
   - Manage video categories
   - Schedule featured content

2. **User Management**
   - Monitor user statistics
   - Respond to user messages
   - Moderate community interactions

3. **Analytics**
   - Track popular content
   - Monitor user engagement
   - Identify trends

## Color Scheme & Design

The app features a gentle, wellness-focused color palette:

- **Primary Colors**: Cornflower Blue, Pale Turquoise
- **Accent Colors**: Light Coral, Toffee
- **Background Colors**: Light sand/cream tones
- **Highlight Colors**: Lemon, Light Moss, Lavender

The design emphasizes readability, accessibility, and a calming aesthetic that supports the wellness journey.

## File Structure Overview

```
lib/
├── admin/                      # Admin-specific components
├── BottomNavBar/               # Main navigation for regular users
├── commonUi/                   # Shared UI components and colors
├── HomePage.dart               # App entry point
├── MyHome.dart                 # Home screen components
├── Services/                   # Authentication and user state management
│   ├── auth_services.dart      # Authentication logic
│   └── UserState.dart          # User role determination
└── userSide/                   # User-facing features
    ├── Home/                   # Main user dashboard
    ├── InfoQuiz/               # Onboarding questionnaire
    ├── LoginSighnUp/           # Authentication screens
    ├── UserProfile/            # User profile management
    └── UserVideo/              # Video browsing and management
```

## Getting Started

1. Install the app
2. Create an account or log in
3. Set your fitness goals during onboarding
4. Explore the workouts and community features
5. Track your progress and stay motivated!

## Technical Requirements

- iOS 13.0+ / Android 5.0+
- Internet connection for community features and content synchronization
- Camera and storage permissions for profile customization
