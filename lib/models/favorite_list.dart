import 'product.dart';

class FavoriteList {
  String id;
  String name;
  List<Product> products;

  FavoriteList({
    required this.id,
    required this.name,
    List<Product>? products,
  }) : products = products ?? [];

  void addProduct(Product product) {
    if (!products.any((p) => p.id == product.id)) {
      products.add(product);
    }
  }

  void removeProduct(Product product) {
    products.removeWhere((p) => p.id == product.id);
  }

  bool containsProduct(Product product) {
    return products.any((p) => p.id == product.id);
  }
} 