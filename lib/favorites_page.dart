import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/language_provider.dart';
import 'models/favorite_list.dart';
import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final isEnglish = languageProvider.isEnglish;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5DC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD4C4B5),
          title: Text(languageProvider.translate('my_favorites')),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                languageProvider.toggleLanguage();
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: languageProvider.translate('all_lists')),
              Tab(text: languageProvider.translate('manage_lists')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateListDialog(context),
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            _buildListsView(),
            _buildListManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildListsView() {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.lists.length,
          itemBuilder: (context, index) {
            final list = provider.lists[index];
            return _buildListSection(list);
          },
        );
      },
    );
  }

  Widget _buildListSection(FavoriteList list) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                list.id == 'default' ? languageProvider.translate(list.name) : list.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (list.products.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(languageProvider.translate('no_products_in_list')),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: list.products.length,
                itemBuilder: (context, index) {
                  final product = list.products[index];
                  return _buildProductCard(product, context, list.id);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildListManagement() {
    return Consumer2<FavoritesProvider, LanguageProvider>(
      builder: (context, provider, languageProvider, child) {
        return ListView.builder(
          itemCount: provider.lists.length,
          itemBuilder: (context, index) {
            final list = provider.lists[index];
            return ListTile(
              title: Text(list.id == 'default' ? languageProvider.translate(list.name) : list.name),
              subtitle: Text('${list.products.length} ${languageProvider.translate('products')}'),
              trailing: list.id == 'default'
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showRenameListDialog(context, list),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteListDialog(context, list),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product, BuildContext context, String listId) {
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
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4C4B5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
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
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                favoritesProvider.toggleFavorite(product, listId);
                              },
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

  void _showCreateListDialog(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.translate('create_list')),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: languageProvider.translate('list_name'),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<FavoritesProvider>().createList(textController.text);
                Navigator.pop(context);
              }
            },
            child: Text(languageProvider.translate('create')),
          ),
        ],
      ),
    );
  }

  void _showRenameListDialog(BuildContext context, FavoriteList list) {
    final languageProvider = context.read<LanguageProvider>();
    final textController = TextEditingController(text: list.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.translate('rename_list')),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: languageProvider.translate('new_name'),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<FavoritesProvider>().renameList(list.id, textController.text);
                Navigator.pop(context);
              }
            },
            child: Text(languageProvider.translate('rename')),
          ),
        ],
      ),
    );
  }

  void _showDeleteListDialog(BuildContext context, FavoriteList list) {
    final languageProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.translate('delete_list')),
        content: Text(
          languageProvider.translate('delete_list_confirmation')
              .replaceAll('{listName}', list.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().deleteList(list.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(languageProvider.translate('delete')),
          ),
        ],
      ),
    );
  }
} 