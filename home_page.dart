import 'package:flutter/material.dart';
import 'package:swt_front_end/login.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Suchen...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Favoriten-Logik hier implementieren
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Warenkorb-Logik hier implementieren
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategorien-Leiste
            Container(
              height: 50,
              color: const Color(0xFFE6D5C3),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('Schmuck'),
                  _buildCategoryChip('Kleidung'),
                  _buildCategoryChip('Wohnen'),
                  _buildCategoryChip('Kunst'),
                  _buildCategoryChip('Geschenke'),
                  _buildCategoryChip('Hochzeit'),
                  _buildCategoryChip('Spielzeug'),
                ],
              ),
            ),
            // Featured Kategorien
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
                    children: [
                      _buildFeaturedCategory('Schmuck', 'assets/jewelry.jpg'),
                      _buildFeaturedCategory('Kleidung', 'assets/clothing.jpg'),
                      _buildFeaturedCategory('Wohnen', 'assets/home.jpg'),
                      _buildFeaturedCategory('Kunst', 'assets/art.jpg'),
                    ],
                  ),
                ],
              ),
            ),
            // Empfohlene Produkte
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
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildProductCard();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF8B7355)),
      ),
    );
  }

  Widget _buildFeaturedCategory(String title, String imageUrl) {
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
    );
  }

  Widget _buildProductCard() {
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
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produktname',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '29,99 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 20,
                        ),
                        onPressed: () {
                          // Favoriten-Logik hier implementieren
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
  }
}