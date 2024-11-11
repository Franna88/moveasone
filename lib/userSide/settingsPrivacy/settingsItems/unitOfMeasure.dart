import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget1.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

import 'package:move_as_one/userSide/settingsPrivacy/ui/settingOptionsWidget.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

enum UnitMeasure { metric, imperial }

class UnitOfMeasure extends StatefulWidget {
  const UnitOfMeasure({super.key});

  @override
  State<UnitOfMeasure> createState() => _UnitOfMeasureState();
}

class _UnitOfMeasureState extends State<UnitOfMeasure> {
  UnitMeasure? _radioValue = UnitMeasure.metric;
  @override
  Widget build(BuildContext context) {
    return MainContainer(children: [
      HeaderWidget1(
        header: 'UNIT OF MEASURE',
        onPress: () {
          Navigator.pop(context);
        },
        showBackIcon: true,
      ),
      SettingOptionsWidget(
        settingText: 'Metric',
        settingWidget: Transform.scale(
          scale: 1.2,
          child: Radio(
            activeColor: UiColors().teal,
            fillColor: WidgetStateProperty.resolveWith(
              (states) {
                // active
                if (states.contains(WidgetState.selected)) {
                  return UiColors().teal;
                }
                // inactive
                return Colors.grey;
              },
            ),
            value: UnitMeasure.metric,
            groupValue: _radioValue,
            onChanged: (UnitMeasure? value) {
              setState(
                () {
                  _radioValue = value;
                },
              );
            },
          ),
        ),
      ),
      SettingOptionsWidget(
        settingText: 'Imperial',
        settingWidget: Transform.scale(
          scale: 1.2,
          child: Radio(
            fillColor: WidgetStateProperty.resolveWith(
              (states) {
                // active
                if (states.contains(WidgetState.selected)) {
                  return UiColors().teal;
                }
                // inactive
                return Colors.grey;
              },
            ),
            activeColor: UiColors().teal,
            value: UnitMeasure.imperial,
            groupValue: _radioValue,
            onChanged: (UnitMeasure? value) {
              setState(
                () {
                  _radioValue = value;
                },
              );
            },
          ),
        ),
      )
    ]);
  }
}
