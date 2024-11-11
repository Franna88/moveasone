import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/settingOptionsWidget.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class LanguageListView extends StatefulWidget {
  const LanguageListView({super.key});

  @override
  State<LanguageListView> createState() => _LanguageListViewState();
}

class _LanguageListViewState extends State<LanguageListView> {
  final List<String> languageItems = [
    'English',
    'Spanish',
    'Chinese',
    'Japanese',
    'French',
    'German',
    'Russian',
    'Portugues',
    'Italian',
    'Korean',
  ];
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = languageItems[0];
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.75,
      child: ListView.builder(
        itemCount: languageItems.length,
        itemBuilder: (context, index) {
          return SettingOptionsWidget(
            settingText: languageItems[index],
            settingWidget: Transform.scale(
              scale: 1.2,
              child: Radio(
                activeColor: UiColors().purp,
                fillColor: WidgetStateProperty.resolveWith(
                  (states) {
                    // active
                    if (states.contains(WidgetState.selected)) {
                      return UiColors().purp;
                    }
                    // inactive
                    return Colors.grey;
                  },
                ),
                value: languageItems[index],
                groupValue: selectedValue,
                onChanged: (newValue) {
                  setState(
                    () {
                      selectedValue = newValue!;
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
