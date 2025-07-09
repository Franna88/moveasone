import 'package:flutter/material.dart';

import 'package:move_as_one/commonUi/ModernGlassButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';
import 'package:move_as_one/Services/debug_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UiColors colors = UiColors();

  @override
  void initState() {
    super.initState();
    DebugService().logWidgetLifecycle('HomePage', 'initState');
    DebugService().logUserAction('view_home_page', screen: 'HomePage');
  }

  @override
  Widget build(BuildContext context) {
    DebugService().logWidgetLifecycle('HomePage', 'build');
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Removed gradient overlay to let the image show through clearly
          color: Colors.transparent,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image without opacity reduction
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/new_photos/PHOTO-2025-06-18-11-52-52.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MyUtility(context).height * 0.005,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 16.0),
                    child: Opacity(
                      opacity: 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          'images/MAO_reavamp.png',
                          height: 280, // Increased size
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  // Buttons area
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        // Get Started button with frosted glass effect
                        ModernGlassButton(
                          buttonText: 'Get Started',
                          onTap: () {
                            DebugService().logUserAction('tap_get_started',
                                screen: 'HomePage');
                            DebugService().logNavigation('HomePage', 'Signin');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signin()),
                            );
                          },
                          buttonColor: colors.primaryBlue,
                          width: MyUtility(context).width * 0.8,
                          icon: Icons.arrow_forward_rounded,
                          elevated: true,
                          borderRadius: 30,
                          backgroundOpacity: 0.4,
                        ),
                      ],
                    ),
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
