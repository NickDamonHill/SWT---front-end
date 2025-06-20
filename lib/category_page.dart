import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final List<Product> products;

  const CategoryPage({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final isEnglish = languageProvider.isEnglish;
    final categoryKey = category.toLowerCase().replaceAll(' ', '_');
    final categoryName = languageProvider.translate(categoryKey);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageProvider.toggleLanguage();
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    if (cart.itemCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index], context);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final isEnglish = languageProvider.isEnglish;
    
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(product);
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4C4B5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: product.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish ? product.nameEn : product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEnglish ? product.descriptionEn : product.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shopping_cart_outlined),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context, listen: false)
                                        .addItem(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} wurde zum Warenkorb hinzugefügt'),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'Zum Warenkorb',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const CartPage()),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (!isFavorite) {
                                      _showAddToListDialog(context, product);
                                    } else {
                                      _showRemoveFromListsDialog(context, product);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddToListDialog(BuildContext context, Product product) {
    final languageProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(languageProvider.translate('add_to_list')),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<FavoritesProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.lists.length,
                  itemBuilder: (context, index) {
                    final list = provider.lists[index];
                    final isInList = list.containsProduct(product);
                    return ListTile(
                      title: Text(list.name),
                      trailing: isInList
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        provider.toggleFavorite(product, list.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(languageProvider.translate('close')),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveFromListsDialog(BuildContext context, Product product) {
    final languageProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(languageProvider.translate('remove_from_lists')),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<FavoritesProvider>(
              builder: (context, provider, child) {
                final listsWithProduct = provider.lists
                    .where((list) => list.containsProduct(product))
                    .toList();

                if (listsWithProduct.isEmpty) {
                  return Text(languageProvider.translate('product_in_no_list'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listsWithProduct.length,
                  itemBuilder: (context, index) {
                    final list = listsWithProduct[index];
                    return ListTile(
                      title: Text(list.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () {
                          provider.toggleFavorite(product, list.id);
                          if (!provider.isFavorite(product)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(languageProvider.translate('close')),
            ),
          ],
        );
      },
    );
  }
} 