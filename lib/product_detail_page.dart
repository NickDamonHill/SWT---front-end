import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'cart_page.dart';
import 'providers/language_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final isEnglish = languageProvider.isEnglish;
    final productName = isEnglish ? product.nameEn : product.name;
    final productDescription = isEnglish ? product.descriptionEn : product.description;
    final categoryKey = product.category.toLowerCase().replaceAll(' ', '_');
    final categoryName = languageProvider.translate(categoryKey);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        title: Text(productName),
        actions: [
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              color: const Color(0xFFD4C4B5),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${product.price.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B7355),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4C4B5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    languageProvider.translate('description'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seller Information
                  Text(
                    languageProvider.translate('seller'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFD4C4B5),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Handmade Crafts',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                languageProvider.translate('seller_since').replaceAll('{years}', '${DateTime.now().year - 2020}'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, child) {
                            final isFavorite = favoritesProvider.isFavorite(product);
                            return ElevatedButton.icon(
                              onPressed: () {
                                if (!isFavorite) {
                                  _showAddToListDialog(context, product);
                                } else {
                                  _showRemoveFromListsDialog(context, product);
                                }
                              },
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              label: Text(
                                isFavorite 
                                  ? languageProvider.translate('remove_from_favorites')
                                  : languageProvider.translate('add_to_favorites'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF8B7355),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(languageProvider.translate('added_to_cart').replaceAll('{product}', product.name)),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: languageProvider.translate('go_to_cart'),
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
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: Text(languageProvider.translate('add_to_cart')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B7355),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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