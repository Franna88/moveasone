class DifficultyModel {
  final String difficultyImage;
  final String difficultyLevel;
  final String memberCount;
  Function() onTap;

  DifficultyModel(
      {required this.difficultyImage,
      required this.difficultyLevel,
      required this.memberCount,
      required this.onTap});
}

List difficultyItems = [
  DifficultyModel(
    difficultyImage: 'images/placeHolder4.jpg',
    difficultyLevel: 'Beginner',
    memberCount: '15 Members',
    onTap: () {
      //ADD LOGIC
    },
  ),
  DifficultyModel(
    difficultyImage: 'images/placeHolder1.jpg',
    difficultyLevel: 'Intermediate',
    memberCount: '12 Members',
    onTap: () {
      //ADD LOGIC
    },
  ),
  DifficultyModel(
    difficultyImage: 'images/placeHolder2.jpg',
    difficultyLevel: 'Advanced',
    memberCount: '8 Members',
    onTap: () {
      //ADD LOGIC
    },
  ),
];
