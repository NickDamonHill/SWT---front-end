import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'favorites_page.dart';
import 'models/product.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
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
          nameEn: 'Handmade Necklace',
          price: 49.99,
          category: 'Schmuck',
          description: 'Elegante Halskette aus hochwertigen Materialien, handgefertigt mit Liebe zum Detail.',
          descriptionEn: 'Elegant necklace made from high-quality materials, handcrafted with attention to detail.',
        ),
        Product(
          id: 'jewelry_2',
          name: 'Vintage Ohrringe',
          nameEn: 'Vintage Earrings',
          price: 29.99,
          category: 'Schmuck',
          description: 'Klassische Ohrringe im Vintage-Stil, perfekt für jeden Anlass.',
          descriptionEn: 'Classic vintage-style earrings, perfect for any occasion.',
        ),
      ],
      'Kleidung': [
        Product(
          id: 'clothing_1',
          name: 'Handgestrickter Pullover',
          nameEn: 'Hand-knitted Sweater',
          price: 89.99,
          category: 'Kleidung',
          description: 'Warm und gemütlich, handgestrickt aus 100% natürlicher Wolle.',
          descriptionEn: 'Warm and cozy, hand-knitted from 100% natural wool.',
        ),
        Product(
          id: 'clothing_2',
          name: 'Gehäkelte Mütze',
          nameEn: 'Crocheted Hat',
          price: 24.99,
          category: 'Kleidung',
          description: 'Stylische Mütze, handgehäkelt mit hochwertigem Garn.',
          descriptionEn: 'Stylish hat, hand-crocheted with high-quality yarn.',
        ),
      ],
      'Wohnen': [
        Product(
          id: 'home_1',
          name: 'Makramee Wandbehang',
          nameEn: 'Macrame Wall Hanging',
          price: 59.99,
          category: 'Wohnen',
          description: 'Handgeknüpfter Wandbehang aus natürlichen Materialien, einzigartiges Design.',
          descriptionEn: 'Hand-knotted wall hanging made from natural materials, unique design.',
        ),
        Product(
          id: 'home_2',
          name: 'Handgetöpferte Vase',
          nameEn: 'Handmade Pottery Vase',
          price: 39.99,
          category: 'Wohnen',
          description: 'Einzigartige Vase aus Keramik, handgetöpfert und glasiert.',
          descriptionEn: 'Unique ceramic vase, handmade and glazed.',
        ),
      ],
      'Kunst': [
        Product(
          id: 'art_1',
          name: 'Aquarell Gemälde',
          nameEn: 'Watercolor Painting',
          price: 149.99,
          category: 'Kunst',
          description: 'Original Aquarell-Gemälde, handgemalt auf hochwertigem Papier.',
          descriptionEn: 'Original watercolor painting, hand-painted on high-quality paper.',
        ),
        Product(
          id: 'art_2',
          name: 'Handgedruckte Grafik',
          nameEn: 'Hand-printed Graphic',
          price: 79.99,
          category: 'Kunst',
          description: 'Limitierte Auflage, handgedruckt mit traditionellen Techniken.',
          descriptionEn: 'Limited edition, hand-printed with traditional techniques.',
        ),
      ],
      'Geschenke': [
        Product(
          id: 'gift_1',
          name: 'Personalisiertes Fotoalbum',
          nameEn: 'Personalized Photo Album',
          price: 34.99,
          category: 'Geschenke',
          description: 'Handgefertigtes Fotoalbum, personalisierbar mit Namen und Datum.',
          descriptionEn: 'Handmade photo album, customizable with name and date.',
        ),
        Product(
          id: 'gift_2',
          name: 'Handgemachte Seife Set',
          nameEn: 'Handmade Soap Set',
          price: 19.99,
          category: 'Geschenke',
          description: 'Set aus 3 handgemachten Seifen mit natürlichen Zutaten.',
          descriptionEn: 'Set of 3 handmade soaps with natural ingredients.',
        ),
      ],
      'Hochzeit': [
        Product(
          id: 'wedding_1',
          name: 'Handgefertigte Einladungen',
          nameEn: 'Handmade Invitations',
          price: 3.99,
          category: 'Hochzeit',
          description: 'Elegante Hochzeitseinladungen, handgefertigt mit Liebe zum Detail.',
          descriptionEn: 'Elegant wedding invitations, handmade with attention to detail.',
        ),
        Product(
          id: 'wedding_2',
          name: 'Blumenkranz',
          nameEn: 'Flower Crown',
          price: 44.99,
          category: 'Hochzeit',
          description: 'Traditioneller Blumenkranz, handgefertigt aus frischen Blumen.',
          descriptionEn: 'Traditional flower crown, handmade from fresh flowers.',
        ),
      ],
      'Spielzeug': [
        Product(
          id: 'toy_1',
          name: 'Gehäkeltes Kuscheltier',
          nameEn: 'Crocheted Plush Toy',
          price: 29.99,
          category: 'Spielzeug',
          description: 'Süßes Kuscheltier, handgehäkelt aus weicher Wolle.',
          descriptionEn: 'Cute plush toy, hand-crocheted from soft wool.',
        ),
        Product(
          id: 'toy_2',
          name: 'Holzspielzeug Set',
          nameEn: 'Wooden Toy Set',
          price: 39.99,
          category: 'Spielzeug',
          description: 'Set aus handgefertigtem Holzspielzeug, sicher und langlebig.',
          descriptionEn: 'Set of handmade wooden toys, safe and durable.',
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
    final languageProvider = context.watch<LanguageProvider>();
    
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
              hintText: languageProvider.translate('search'),
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
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageProvider.toggleLanguage();
            },
          ),
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
                      '${languageProvider.translate('search_results')} (${_searchResults.length})',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_searchResults.isEmpty)
                      Center(
                        child: Text(
                          languageProvider.translate('no_products_found'),
                          style: const TextStyle(fontSize: 16),
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
                    Text(
                      languageProvider.translate('popular_categories'),
                      style: const TextStyle(
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
                    Text(
                      languageProvider.translate('recommended'),
                      style: const TextStyle(
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
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final categoryKey = label.toLowerCase().replaceAll(' ', '_');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(languageProvider.translate(categoryKey)),
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
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final categoryKey = title.toLowerCase().replaceAll(' ', '_');
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
                    languageProvider.translate(categoryKey),
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
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isEnglish = languageProvider.isEnglish;
    final productName = isEnglish ? product.nameEn : product.name;
    final productDescription = isEnglish ? product.descriptionEn : product.description;
    
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
                              productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              productDescription,
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
                                        content: Text('${productName} ${languageProvider.translate('added_to_cart')}'),
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
        final provider = context.read<FavoritesProvider>();
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
        final provider = context.read<FavoritesProvider>();
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