class CategoryResultsModel {
  final String image;
  final String exercise;
  final String exerciseDescription;
  Function() onTap;

  CategoryResultsModel(
      {required this.exercise,
      required this.image,
      required this.exerciseDescription,
      required this.onTap});
}

List categoryResult = [
  CategoryResultsModel(
      exercise: 'Warmup',
      image: 'images/placeHolder1.jpg',
      exerciseDescription:
          'High knees 3x30 seconds\nBackwards lunges 3x10 per leg\nLeg swings 3x30 seconds per leg',
      onTap: () {}),
  CategoryResultsModel(
      exercise: 'Exercise 1',
      image: 'images/placeHolder2.jpg',
      exerciseDescription:
          'High knees 3x30 seconds\nBackwards lunges 3x10 per leg\nLeg swings 3x30 seconds per leg',
      onTap: () {}),
  CategoryResultsModel(
      exercise: 'Rest',
      image: 'images/placeHolder4.jpg',
      exerciseDescription: 'Rest 1 min-1 min 30 seconds',
      onTap: () {}),
  CategoryResultsModel(
      exercise: 'Exercise 2',
      image: 'images/placeHolder1.jpg',
      exerciseDescription: 'Squats 3x15',
      onTap: () {}),
  CategoryResultsModel(
      exercise: 'Rest',
      image: 'images/placeHolder1.jpg',
      exerciseDescription: 'Rest 1 min-1 min 30 seconds',
      onTap: () {}),
];
