
class VideoCategoryModel {
  final String categoryName;
  final bool active;

  VideoCategoryModel( {required this.categoryName, required this.active});
}

List categoryData = [
  VideoCategoryModel(categoryName: 'Upper Body', active: true, ),
  VideoCategoryModel(categoryName: 'Strength', active: false),
  VideoCategoryModel(categoryName: 'Legs', active: false),
  VideoCategoryModel(categoryName: 'Arms', active: false),
  VideoCategoryModel(categoryName: 'Back', active: false),
];