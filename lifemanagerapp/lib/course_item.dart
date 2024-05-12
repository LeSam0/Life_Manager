class CourseItem {
  final String category;
  final String name;
  final double price;
  final String categorie_id;
  final String id;
  final int quantite;
  bool isChecked;


  CourseItem({
    required this.name,
    required this.price,
    required this.category,
    required this.categorie_id,
    required this.id,
    required this.quantite,
    required this.isChecked,
  });
}
