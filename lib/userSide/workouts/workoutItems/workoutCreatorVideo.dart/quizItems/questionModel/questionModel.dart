class Question {
  final String question;
  final List<String> answers;

  const Question({required this.answers, required this.question});
}

const List questions = [
  Question(
      answers: ['Good', 'Bad', 'Tired'],
      question: 'How did you feel while Excersising?'),
  Question(
      answers: ['Yes', 'No', 'I Tried But Failed'],
      question: 'Did you do any extra reps or weight?'),
  Question(
      answers: ['Positive', 'Depressed', 'Just Tired'],
      question: 'What is your Current mood?'),
  Question(
      answers: ['Good', 'Bad', 'Tired'],
      question: 'How did you feel while Excersising?'),
  Question(
      answers: ['Yes', 'No', 'I Tried But Failed'],
      question: 'Did you do any extra reps or weight?'),
  Question(
      answers: ['Positive', 'Depressed', 'Just Tired'],
      question: 'What is your Current mood?'),
];
