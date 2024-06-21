import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/greyDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/payment/commonUi/blackButton.dart';
import 'package:move_as_one/userSide/payment/commonUi/paymentDate.dart';
import 'package:move_as_one/userSide/payment/commonUi/paymentTime.dart';
import 'package:move_as_one/userSide/payment/commonUi/trainerDetails.dart';
import 'package:move_as_one/userSide/payment/commonUi/workoutDetailsPayment.dart';
import 'package:move_as_one/userSide/payment/paymentCompleted/ui/completedContainer.dart';


class PaymentCompleted extends StatelessWidget {
  const PaymentCompleted({super.key});

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
              SizedBox(height: heightDevice * 0.10,),
              CompletedContainer(),
              Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 20),
                        child: TrainerDetail(
                          trainerName: 'Lena Rosser',
                          trainerTag: 'Functional Strength',
                          trainerRating: '4.7',
                          ratingContainerColor: UiColors().purp,
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
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaymentTime(paymentTime: '09:30 AM'),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.notifications_outlined, size: 30,),
                          )
                        ],
                      ),
                      GreyDivider(),
                      Spacer(),
                      Center(
                        child: BlackButton(buttonText: 'Done', onTap: (){
                          //ADD LOGIC HERE
                        }),
                      ),
                      const SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
