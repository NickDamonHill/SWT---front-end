import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'models/favorite.dart';
import 'models/product.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5DC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD4C4B5),
          title: const Text('Meine Favoriten'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Alle Listen'),
              Tab(text: 'Listen verwalten'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            list.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (list.products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Keine Produkte in dieser Liste'),
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
              return _buildProductCard(product, list.id);
            },
          ),
      ],
    );
  }

  Widget _buildListManagement() {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.lists.length,
          itemBuilder: (context, index) {
            final list = provider.lists[index];
            return ListTile(
              title: Text(list.name),
              subtitle: Text('${list.products.length} Produkte'),
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

  Widget _buildProductCard(Product product, String listId) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        return Container(
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
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              provider.toggleFavorite(product, listId);
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
        );
      },
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neue Liste erstellen'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Listenname',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<FavoritesProvider>().createList(textController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Erstellen'),
          ),
        ],
      ),
    );
  }

  void _showRenameListDialog(BuildContext context, FavoriteList list) {
    final textController = TextEditingController(text: list.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liste umbenennen'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Neuer Name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<FavoritesProvider>().renameList(list.id, textController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Umbenennen'),
          ),
        ],
      ),
    );
  }

  void _showDeleteListDialog(BuildContext context, FavoriteList list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liste löschen'),
        content: Text('Möchten Sie die Liste "${list.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().deleteList(list.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
} 