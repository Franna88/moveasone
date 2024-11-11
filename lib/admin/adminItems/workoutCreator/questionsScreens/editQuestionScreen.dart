import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/ui/answersEditTextfield.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/ui/bottomButtonContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/questionConHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/ui/questionMainContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/ui/questionsMainTextfield.dart';

class EditQuestionScreen extends StatelessWidget {
  const EditQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/placeHolder1.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: widthDevice * 0.80,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'CHECK IN QUESTIONS',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              QuestionMainContainer(
                children: [
                  QuestionConHeader(header: 'EDIT QUESTION'),
                  QuestionsMainTextfield(
                    hintText: 'How did you feel while Exercising?',
                    onChanged: () {
                      //ADD LOGIC
                    },
                  ),
                  AnswersEditTextfield(hintText: 'Good'),
                  AnswersEditTextfield(hintText: 'Bad'),
                  AnswersEditTextfield(hintText: 'Tired'),
                ],
              ),
              BottomButtonContainer(
                buttonText: 'Submit',
                onPressed: () {
                  //ADD LOGIC HERE
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
