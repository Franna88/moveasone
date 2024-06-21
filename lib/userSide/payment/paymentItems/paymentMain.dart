import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/greyDivider.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/payment/paymentItems/ui/addCardButton.dart';
import 'package:move_as_one/userSide/payment/commonUi/blackButton.dart';
import 'package:move_as_one/userSide/payment/paymentItems/ui/cardListview.dart';
import 'package:move_as_one/userSide/payment/paymentItems/ui/estimatedCost.dart';
import 'package:move_as_one/userSide/payment/commonUi/paymentDate.dart';
import 'package:move_as_one/userSide/payment/commonUi/paymentTime.dart';
import 'package:move_as_one/userSide/payment/commonUi/trainerDetails.dart';
import 'package:move_as_one/userSide/payment/commonUi/workoutDetailsPayment.dart';

class PaymentMain extends StatefulWidget {
  const PaymentMain({super.key});

  @override
  State<PaymentMain> createState() => _PaymentMainState();
}

class _PaymentMainState extends State<PaymentMain> {
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
              HeaderWidget(header: 'PAYMENT'),
              Container(
                height: heightDevice * 0.78,
                width: widthDevice,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Payment Method',
                          style: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AddCardButton(
                              onTap: () {
                                //ADD LOGIC
                              },
                            ),
                            Expanded(child: CardListView())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 20),
                        child: Text(
                          'Order Details',
                          style: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 17),
                        ),
                      ),
                      GreyDivider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 20),
                        child: TrainerDetail(
                          trainerName: 'Lena Rosser',
                          trainerTag: 'Functional Strength',
                          trainerRating: '4.7',
                          ratingContainerColor: UiColors().teal,
                          trainerImage: 'images/comment1.jpg',
                        ),
                      ),
                      GreyDivider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 20),
                        child: WorkoutDetailsPaymnet(
                            workoutName: 'Run Warmup',
                            workoutDificulty: 'Intermediate',
                            workoutImage: 'images/placeHolder1.jpg'),
                      ),
                      GreyDivider(),
                      //PAYMENT DATE
                      PaymentDate(paymentDate: '20 October 2021 - Wednesday'),
                      //PAYMENT TIME
                      PaymentTime(paymentTime: '09:30 AM'),
                      GreyDivider(),
                      EstimatedCost(estimatedCost: '\$ 19.99'),
                      GreyDivider(),
                    ],
                  ),
                ),
              ),
              GreyDivider(),
              const SizedBox(height: 20,),
              Center(
                child: BlackButton(buttonText: 'Confirm', onTap: () {
                  //ADD LOGIC
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
