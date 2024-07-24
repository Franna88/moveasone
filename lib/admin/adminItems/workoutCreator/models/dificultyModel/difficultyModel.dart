class DifficultyModel {
  final String difficultyImage;
  final String difficultyLevel;
  final String memberCount;
  bool selected;

  DifficultyModel({
    required this.difficultyImage,
    required this.difficultyLevel,
    required this.memberCount,
    this.selected = false,
  });
}

List<DifficultyModel> difficultyItems = [
  DifficultyModel(
    difficultyImage: 'images/placeHolder4.jpg',
    difficultyLevel: 'Beginner',
    memberCount: '15 Members',
  ),
  DifficultyModel(
    difficultyImage: 'images/placeHolder1.jpg',
    difficultyLevel: 'Intermediate',
    memberCount: '12 Members',
  ),
  DifficultyModel(
    difficultyImage: 'images/placeHolder2.jpg',
    difficultyLevel: 'Advanced',
    memberCount: '8 Members',
  ),
];
