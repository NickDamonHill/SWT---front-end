import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/language_provider.dart';
import 'providers/products_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'Schmuck';

  final List<String> _categories = [
    'Schmuck',
    'Kleidung',
    'Wohnen',
    'Kunst',
    'Geschenke',
    'Hochzeit',
    'Spielzeug',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _descriptionEnController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: DateTime.now().toString(), // Temporäre ID-Generierung
        name: _nameController.text,
        nameEn: _nameEnController.text,
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        description: _descriptionController.text,
        descriptionEn: _descriptionEnController.text,
        imageUrl: _imageUrlController.text,
      );

      // Produkt zum Provider hinzufügen
      Provider.of<ProductsProvider>(context, listen: false).addProduct(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produkt wurde erfolgreich erstellt'),
          backgroundColor: Colors.green,
        ),
      );

      // Zurück zur vorherigen Seite
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        title: Text(languageProvider.translate('add_product')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageProvider.toggleLanguage();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Produktname (Deutsch)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Produktname (Deutsch)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Produktnamen ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Produktname (Englisch)
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(
                  labelText: 'Produktname (Englisch)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen englischen Produktnamen ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Preis
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Preis (€)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Preis ein';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Bitte geben Sie eine gültige Zahl ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Kategorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategorie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Beschreibung (Deutsch)
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Beschreibung (Deutsch)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie eine Beschreibung ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Beschreibung (Englisch)
              TextFormField(
                controller: _descriptionEnController,
                decoration: InputDecoration(
                  labelText: 'Beschreibung (Englisch)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie eine englische Beschreibung ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bild-URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Bild-URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie eine Bild-URL ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Vorschau des Bildes
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Speichern-Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7355),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Produkt speichern',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 