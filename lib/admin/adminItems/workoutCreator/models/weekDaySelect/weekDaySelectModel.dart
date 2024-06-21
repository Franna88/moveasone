class WeekDaySelectModel {
  final String image;
  final String weekDay;
  final String exerciseType;
  Function() onTap;

  WeekDaySelectModel(
      {required this.image,
      required this.exerciseType,
      required this.weekDay,
      required this.onTap});
}

List weekDaySelection = [
  WeekDaySelectModel(
      image: 'images/placeHolder1.jpg',
      exerciseType: 'Legs',
      weekDay: 'Monday',
      onTap: () {}),
  WeekDaySelectModel(
      image: 'images/placeHolder2.jpg',
      exerciseType: 'Cardio and Core',
      weekDay: 'Tuesday',
      onTap: () {}),
  WeekDaySelectModel(
      image: 'images/placeHolder4.jpg',
      exerciseType: 'Upper Body',
      weekDay: 'Wednesday',
      onTap: () {}),
  WeekDaySelectModel(
      image: 'images/placeHolder1.jpg',
      exerciseType: 'Cardio and Core',
      weekDay: 'Thursday',
      onTap: () {}),
  WeekDaySelectModel(
      image: 'images/placeHolder2.jpg',
      exerciseType: 'Upper Body',
      weekDay: 'Friday',
      onTap: () {}),
];
