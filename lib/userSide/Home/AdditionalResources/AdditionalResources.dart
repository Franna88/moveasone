import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResourcesComponents/AdditionalContainer.dart';
import 'package:move_as_one/myutility.dart';

class AdditionalResources extends StatefulWidget {
  final bool showAll; // Parameter to control if we show all cards or just one

  const AdditionalResources({super.key, this.showAll = false});

  @override
  State<AdditionalResources> createState() => _AdditionalResourcesState();
}

class _AdditionalResourcesState extends State<AdditionalResources> {
  @override
  Widget build(BuildContext context) {
    // If this is the standalone page (showAll = true), use Scaffold
    if (widget.showAll) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Additional Resources'),
          backgroundColor: Color(0xFF6699CC),
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AdditionsalContainer(
                            image: 'images/nutrision.png',
                            header: "Nutrition Tip",
                            discription: "Healthy Lifestyle"),
                        SizedBox(height: 16.0),
                        AdditionsalContainer(
                            image: 'images/nutrision2.png',
                            header: "Nutrition Tip",
                            discription: "Healthy Lifestyle"),
                        SizedBox(height: 16.0),
                        AdditionsalContainer(
                            image: 'images/nutrision.png',
                            header: "Workout Guide",
                            discription: "Fitness Tips"),
                        SizedBox(height: 16.0),
                        AdditionsalContainer(
                            image: 'images/nutrision2.png',
                            header: "Wellness Tips",
                            discription: "Mind & Body"),
                        SizedBox(height: 16.0),
                        AdditionsalContainer(
                            image: 'images/nutrision.png',
                            header: "Recovery Guide",
                            discription: "Rest & Restore"),
                        SizedBox(height: 32.0), // Extra bottom padding
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

    // Home page version - show only one card
    return Column(
      children: [
        // Removed the header section completely
        // Show only one card on home page
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AdditionsalContainer(
              image: 'images/nutrision.png',
              header: "Nutrition Tip",
              discription: "Healthy Lifestyle"),
        ),
      ],
    );
  }
}
