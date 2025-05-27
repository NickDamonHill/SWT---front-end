import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'favorites_page.dart';
import 'models/product.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Map<String, List<Product>> _sampleProducts;
  late final List<Product> _allProducts;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Sample products for each category
    _sampleProducts = {
      'Schmuck': [
        Product(
          id: 'jewelry_1',
          name: 'Handgefertigte Halskette',
          price: 49.99,
          category: 'Schmuck',
          description: 'Elegante Halskette aus hochwertigen Materialien, handgefertigt mit Liebe zum Detail.',
        ),
        Product(
          id: 'jewelry_2',
          name: 'Vintage Ohrringe',
          price: 29.99,
          category: 'Schmuck',
          description: 'Klassische Ohrringe im Vintage-Stil, perfekt für jeden Anlass.',
        ),
      ],
      'Kleidung': [
        Product(
          id: 'clothing_1',
          name: 'Handgestrickter Pullover',
          price: 89.99,
          category: 'Kleidung',
          description: 'Warm und gemütlich, handgestrickt aus 100% natürlicher Wolle.',
        ),
        Product(
          id: 'clothing_2',
          name: 'Gehäkelte Mütze',
          price: 24.99,
          category: 'Kleidung',
          description: 'Stylische Mütze, handgehäkelt mit hochwertigem Garn.',
        ),
      ],
      'Wohnen': [
        Product(
          id: 'home_1',
          name: 'Makramee Wandbehang',
          price: 59.99,
          category: 'Wohnen',
          description: 'Handgeknüpfter Wandbehang aus natürlichen Materialien, einzigartiges Design.',
        ),
        Product(
          id: 'home_2',
          name: 'Handgetöpferte Vase',
          price: 39.99,
          category: 'Wohnen',
          description: 'Einzigartige Vase aus Keramik, handgetöpfert und glasiert.',
        ),
      ],
      'Kunst': [
        Product(
          id: 'art_1',
          name: 'Aquarell Gemälde',
          price: 149.99,
          category: 'Kunst',
          description: 'Original Aquarell-Gemälde, handgemalt auf hochwertigem Papier.',
        ),
        Product(
          id: 'art_2',
          name: 'Handgedruckte Grafik',
          price: 79.99,
          category: 'Kunst',
          description: 'Limitierte Auflage, handgedruckt mit traditionellen Techniken.',
        ),
      ],
      'Geschenke': [
        Product(
          id: 'gift_1',
          name: 'Personalisiertes Fotoalbum',
          price: 34.99,
          category: 'Geschenke',
          description: 'Handgefertigtes Fotoalbum, personalisierbar mit Namen und Datum.',
        ),
        Product(
          id: 'gift_2',
          name: 'Handgemachte Seife Set',
          price: 19.99,
          category: 'Geschenke',
          description: 'Set aus 3 handgemachten Seifen mit natürlichen Zutaten.',
        ),
      ],
      'Hochzeit': [
        Product(
          id: 'wedding_1',
          name: 'Handgefertigte Einladungen',
          price: 3.99,
          category: 'Hochzeit',
          description: 'Elegante Hochzeitseinladungen, handgefertigt mit Liebe zum Detail.',
        ),
        Product(
          id: 'wedding_2',
          name: 'Blumenkranz',
          price: 44.99,
          category: 'Hochzeit',
          description: 'Traditioneller Blumenkranz, handgefertigt aus frischen Blumen.',
        ),
      ],
      'Spielzeug': [
        Product(
          id: 'toy_1',
          name: 'Gehäkeltes Kuscheltier',
          price: 29.99,
          category: 'Spielzeug',
          description: 'Süßes Kuscheltier, handgehäkelt aus weicher Wolle.',
        ),
        Product(
          id: 'toy_2',
          name: 'Holzspielzeug Set',
          price: 39.99,
          category: 'Spielzeug',
          description: 'Set aus handgefertigtem Holzspielzeug, sicher und langlebig.',
        ),
      ],
    };

    // Create a flat list of all products for the recommended section
    _allProducts = _sampleProducts.values.expand((products) => products).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _isSearching = true;
      _searchResults = _allProducts.where((product) {
        return product.name.toLowerCase().contains(lowercaseQuery) ||
            product.category.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        elevation: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Suchen...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            onChanged: _performSearch,
          ),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final hasAnyFavorites = favoritesProvider.lists
                  .any((list) => list.products.isNotEmpty);
              return IconButton(
                icon: Icon(
                  hasAnyFavorites ? Icons.favorite : Icons.favorite_border,
                  color: hasAnyFavorites ? Colors.red : null,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesPage()),
                  );
                },
              );
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
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const LoginDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearching) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suchergebnisse (${_searchResults.length})',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_searchResults.isEmpty)
                      const Center(
                        child: Text(
                          'Keine Produkte gefunden',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_searchResults[index]);
                        },
                      ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                height: 50,
                color: const Color(0xFFE6D5C3),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _sampleProducts.keys.map((category) {
                    return _buildCategoryChip(category, context);
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beliebte Kategorien',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: _sampleProducts.keys.take(4).map((category) {
                        return _buildFeaturedCategory(category, context);
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Empfohlen für dich',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: _allProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_allProducts[index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(label),
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF8B7355)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(
                category: label,
                products: _sampleProducts[label] ?? [],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCategory(String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              category: title,
              products: _sampleProducts[title] ?? [],
            ),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                color: const Color(0xFFD4C4B5),
                height: double.infinity,
                width: double.infinity,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black54,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
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
    showDialog(
      context: context,
      builder: (context) {
        final provider = context.read<FavoritesProvider>();
        return AlertDialog(
          title: const Text('Zu Liste hinzufügen'),
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
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveFromListsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        final provider = context.read<FavoritesProvider>();
        return AlertDialog(
          title: const Text('Aus Listen entfernen'),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<FavoritesProvider>(
              builder: (context, provider, child) {
                final listsWithProduct = provider.lists
                    .where((list) => list.containsProduct(product))
                    .toList();

                if (listsWithProduct.isEmpty) {
                  return const Text('Dieses Produkt ist in keiner Liste');
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
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }
}