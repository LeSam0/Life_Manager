class DepenseItem {
  final String id;
  final String name;
  final double montant;
  final DateTime date;
  final String description;
  final String sousCategorieId;
  final String sousCategorieName;
  final String categorieId;
  final String categorieName;

  DepenseItem(
    {required this.id,
    required this.name,
    required this.montant,
    required this.date,
    required this.description,
    required this.sousCategorieId,
    required this.sousCategorieName,
    required this.categorieId,
    required this.categorieName,
    }
  );
}

