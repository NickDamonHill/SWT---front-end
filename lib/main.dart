import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'providers/favorites_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        title: 'SWT Frontend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: const Color(0xFFF5F5DC),
        ),
        home: HomePage(),
      ),
    );
  }
}