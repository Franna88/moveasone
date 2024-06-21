import 'package:flutter/material.dart';
import 'package:move_as_one/MyHome.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/writeAMessage.dart';
import 'package:move_as_one/admin/adminItems/bookings/bookingsRequested/bookingsRequested.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/myScedule.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/WatchedMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/allMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProgress.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAbout.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/searchMembers.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/workoutCreator.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVideoRecord.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVoiceRecord.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorWorkoutCompleted.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenOne.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenThree.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenTwo.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/checkInQuestions.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/categoryResultsScreen.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectDifficultyScreen.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectWeekdayScreen.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryMain.dart';
import 'package:move_as_one/HomePage.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/Goal.dart';
import 'package:move_as_one/userSide/appointment/appointmentMain.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoCategory.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/displayVideoScreen.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/videoBrowsPage.dart';
import 'package:move_as_one/userSide/generalNotifications.dart/generalNotifications.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/addNewCardMain.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/editCardMain.dart';
import 'package:move_as_one/userSide/payment/paymentCompleted/paymentCompletedMain.dart';
import 'package:move_as_one/userSide/payment/paymentItems/paymentMain.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/language.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/notifications.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/privacyPolicy.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/settingsMain.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/unitOfMeasure.dart';
import 'package:move_as_one/userSide/userProfile/UserProfile.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/editProfileMain.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/myProgressMain.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/userProfileLocked.dart';
import 'package:move_as_one/userSide/workoutPopups/popUpItems/awardEmojiPopUp.dart';
import 'package:move_as_one/userSide/workoutPopups/popUpItems/congratulatedPopUp.dart';
import 'package:move_as_one/userSide/workoutPopups/popUpItems/friendRequestPopup.dart';
import 'package:move_as_one/userSide/workoutPopups/popUpItems/hiFivePopUp.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/completedVideoOverlay.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/QuizOne.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/videoQuizScreen.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/workoutCreatorVideoMain.dart';

void main() {
  runApp( MaterialApp(
    theme: ThemeData(),

    home: 
    //GeneralNotifications()
    //ProfileAbout()
    //MemberProgressMain()
    //MemberProfile()
    //AllMembers()
    //WatchedMembers()
    //SearchMembers()
    //QuizOne()
    //Goal()
    // UserProfile()
                HomePage()
    //MyHome()
    //MyChat()
    //MyScedule()
    //BookingsRequested()
    //ResultsScreenTree()
    //ResultsScreenTwo()
    //ResultsScreenOne()
    //CreatorWorkoutCompleted()
    //CreatorVideoRecord()
    //CreatorVoiceRecord()
    //WorkoutCreator()
    //CheckInQuestions()
    //MyVideosMain()
    //CategoryResultsScreen()
    //SelectWeekdayScreen()
    //SelectDifficultyScreen()
    //WorkoutCategoryMain()
    //WriteAMessage()
    //WorkoutsFullLenght()
    //AppointmentMain()
    //EditProfileMain()
    //MyProgressMain()
    //UserProfileLocked()
    //AwardEmojiPopUp()
                          //FriendRequestPopUp()
    //ConGratulatedPopUp()
                          //HiFivePopUp()
    //PaymentCompleted()
    //AddNewCardMain()
    //EditCardMain()
    //PaymentMain()
    //VideoQuizScreen()
    //CompletedVideoOverlay()
    //WorkoutCreatorVideoMain()
    //DefaultWorkoutDetails()
    //MyWorkouts()
    //DisplayVideoScreen()
    //PrivacyPolicy()
    //Language()
    //Notifications()
    //UnitOfMeasure()
    //SettingsMain(),
  ));
}

