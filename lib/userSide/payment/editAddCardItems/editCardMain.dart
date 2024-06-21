import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/userSide/payment/commonUi/blackButton.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/ui/cardDisplayContainer.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/ui/checkBoxWidget.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/ui/numberTextField.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/ui/smallNumberTextField.dart';
import 'package:move_as_one/userSide/payment/editAddCardItems/ui/stringTextField.dart';

class EditCardMain extends StatelessWidget {
  const EditCardMain({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: heightDevice,
          width: widthDevice,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderWidget(header: 'EDIT CARD'),
              Container(
                height: heightDevice * 0.88,
                width: widthDevice,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CardDisplayContainer(),
                      const SizedBox(
                        height: 30,
                      ),
                      StringTextField(
                        labelText: 'Card Holder Name',
                        onChanged: () {
                          //ADD LOGIC HERE
                        },
                      ),
                      NumberTextField(
                        labelText: 'Card Number',
                        fieldWidth: widthDevice,
                        onChanged: () {
                          //ADD LOGIC HERE
                        },
                      ),
                      Row(
                        children: [
                          SmallNumberTextField(
                            labelText: 'Expiry (MM/YY)',
                            fieldWidth: widthDevice * 0.43,
                            onChanged: () {
                              //ADD LOGIC HERE
                            },
                          ),
                          SmallNumberTextField(
                            labelText: 'CVC',
                            fieldWidth: widthDevice * 0.43,
                            onChanged: () {
                              //ADD LOGIC HERE
                            },
                          ),
                        ],
                      ),
                      CheckBoxWidget(
                          description: 'Set as default payment card',
                          checkboxValue: false),
                      SizedBox(
                        height: heightDevice * 0.10,
                      ),
                      BlackButton(
                          buttonText: 'Save',
                          onTap: () {
                            //ADD LOGIC HERE
                          }),
                      SizedBox(
                        height: heightDevice * 0.03,
                      ),
                      TextButton(
                        onPressed: () {
                          //ADD LOGIC HERE
                        },
                        child: Text(
                          'Delete Card',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 244, 54, 117),
                              fontSize: 16),
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
