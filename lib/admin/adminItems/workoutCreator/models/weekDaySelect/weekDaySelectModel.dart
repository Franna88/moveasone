class WeekDaySelectModel {
  final String image;
  final String weekDay;
  final String exerciseType;
  bool selected;

  WeekDaySelectModel({
    required this.image,
    required this.exerciseType,
    required this.weekDay,
    this.selected = false,
  });
}

List weekDaySelection = [
  WeekDaySelectModel(
    image: 'images/placeHolder1.jpg',
    exerciseType: 'Legs',
    weekDay: 'Monday',
  ),
  WeekDaySelectModel(
    image: 'images/placeHolder2.jpg',
    exerciseType: 'Cardio and Core',
    weekDay: 'Tuesday',
  ),
  WeekDaySelectModel(
    image: 'images/placeHolder4.jpg',
    exerciseType: 'Upper Body',
    weekDay: 'Wednesday',
  ),
  WeekDaySelectModel(
    image: 'images/placeHolder1.jpg',
    exerciseType: 'Cardio and Core',
    weekDay: 'Thursday',
  ),
  WeekDaySelectModel(
    image: 'images/placeHolder2.jpg',
    exerciseType: 'Upper Body',
    weekDay: 'Friday',
  ),
];
