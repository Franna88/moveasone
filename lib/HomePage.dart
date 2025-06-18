import 'package:flutter/material.dart';
import 'dart:ui';

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
                  image: AssetImage('images/new_photos/home_main2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MyUtility(context).height * 0.06,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 16.0),
                    child: Opacity(
                      opacity: 0.25,
                      child: Image.asset(
                        'images/MAO_logo_new.jpeg',
                        height: 220, // Increased size
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main message without the container background
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Reclaim your',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontFamily: 'belight',
                                        fontWeight: FontWeight.bold,
                                        color: colors.lightCoral,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'ultimate potential',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 44,
                                        fontFamily: 'belight',
                                        fontWeight: FontWeight.bold,
                                        color: colors.lemon,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Join a community that moves together',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'BeVietnam',
                                        color: colors.lavender,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          buttonColor: colors.paleTurquoise,
                          width: MyUtility(context).width * 0.8,
                          icon: Icons.arrow_forward_rounded,
                          elevated: true,
                          borderRadius: 30,
                          backgroundOpacity: 0.3,
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
