
class WeekdayListModel {
  final String assetName;
  final String weekday;
  final String exercise;

  WeekdayListModel(
      {required this.assetName, required this.exercise, required this.weekday});
}

final List weekdayExercise = [
  WeekdayListModel(
      assetName: 'images/monday2.png',
      exercise: 'Legs',
      weekday: 'Monday'),
  WeekdayListModel(
      assetName: 'images/tuesday.png',
      exercise: 'Arms',
      weekday: 'Tuesday'),
  WeekdayListModel(
      assetName: 'images/wednesday.png',
      exercise: 'Core',
      weekday: 'Wednesday'),
  WeekdayListModel(
      assetName: 'images/avatar2.png',
      exercise: 'Back',
      weekday: 'Thursday'),
  WeekdayListModel(
      assetName: 'images/memberoptions2.png',
      exercise: 'Arms',
      weekday: 'Friday'),
  WeekdayListModel(
      assetName: 'images/memberoptions3.png',
      exercise: 'Legs',
      weekday: 'Saturday'),
  WeekdayListModel(
      assetName: 'images/memberoptions4.png',
      exercise: 'Chest',
      weekday: 'Sunday'),
];
