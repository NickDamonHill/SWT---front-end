import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/favorite_list.dart';
import 'language_provider.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteList> _lists = [
    FavoriteList(id: 'default', name: 'my_favorites')
  ];
  
  List<FavoriteList> get lists => List.unmodifiable(_lists);
  
  FavoriteList? getList(String id) {
    return _lists.firstWhere((list) => list.id == id);
  }

  void createList(String name) {
    final id = 'list_${DateTime.now().millisecondsSinceEpoch}';
    _lists.add(FavoriteList(id: id, name: name));
    notifyListeners();
  }

  void deleteList(String id) {
    if (id != 'default') {
      _lists.removeWhere((list) => list.id == id);
      notifyListeners();
    }
  }

  void renameList(String id, String newName) {
    final list = getList(id);
    if (list != null) {
      list.name = newName;
      notifyListeners();
    }
  }

  bool isInAnyList(Product product) {
    return _lists.any((list) => list.containsProduct(product));
  }

  List<String> getListsContainingProduct(Product product) {
    return _lists
        .where((list) => list.containsProduct(product))
        .map((list) => list.id)
        .toList();
  }

  void toggleFavorite(Product product, String listId) {
    final list = getList(listId);
    if (list != null) {
      if (list.containsProduct(product)) {
        list.removeProduct(product);
      } else {
        list.addProduct(product);
      }
      notifyListeners();
    }
  }

  bool isFavorite(Product product) {
    return isInAnyList(product);
  }
} 