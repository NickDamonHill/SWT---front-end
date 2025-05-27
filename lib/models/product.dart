class Product {
  final String id;
  final String name;
  final String nameEn;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final String descriptionEn;

  Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.price,
    required this.category,
    required this.description,
    required this.descriptionEn,
    this.imageUrl = '',
  });
} 