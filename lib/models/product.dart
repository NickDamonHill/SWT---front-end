class Product {
  final int id;
  final String name;
  final double price;
  final int categoryId;
  final int sellerId;
  final int amount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.sellerId,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'] is String ? double.parse(json['price']) : json['price'].toDouble(),
      categoryId: json['category_id'],
      sellerId: json['seller_id'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category_id': categoryId,
      'seller_id': sellerId,
      'amount': amount,
    };
  }
} 