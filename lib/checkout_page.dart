import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _selectedPaymentMethod = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _showPaymentConfirmation(BuildContext context, CartProvider cart) {
    if (_selectedPaymentMethod.isEmpty) {
      final languageProvider = context.read<LanguageProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageProvider.translate('select_payment_method')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final languageProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.translate('order_successful')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languageProvider.translate('order_successful_message')),
            const SizedBox(height: 8),
            Text('${languageProvider.translate('payment_method_label')} $_selectedPaymentMethod'),
            const SizedBox(height: 8),
            Text(languageProvider.translate('email_confirmation')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(languageProvider.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        title: Text(languageProvider.translate('checkout_title')),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                languageProvider.translate('cart_empty'),
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.translate('shipping_address_title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: languageProvider.translate('name'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageProvider.translate('name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: languageProvider.translate('email'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageProvider.translate('email_required');
                      }
                      if (!value.contains('@')) {
                        return languageProvider.translate('email_invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: languageProvider.translate('address'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageProvider.translate('address_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: languageProvider.translate('city'),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageProvider.translate('city_required');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _zipController,
                          decoration: InputDecoration(
                            labelText: languageProvider.translate('zip'),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageProvider.translate('zip_required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    languageProvider.translate('payment_method_title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png',
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(languageProvider.translate('visa')),
                            ],
                          ),
                          value: 'Visa',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(languageProvider.translate('mastercard')),
                            ],
                          ),
                          value: 'Mastercard',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/1280px-PayPal.svg.png',
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(languageProvider.translate('paypal')),
                            ],
                          ),
                          value: 'PayPal',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    languageProvider.translate('order_summary_title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...cart.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${languageProvider.isEnglish ? item.product.nameEn : item.product.name} (${item.quantity}x)',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      '${item.totalPrice.toStringAsFixed(2)} €',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageProvider.translate('total_label'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${cart.totalAmount.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showPaymentConfirmation(context, cart);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4C4B5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        languageProvider.translate('complete_order'),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 