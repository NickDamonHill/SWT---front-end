import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/main.dart';
import '../lib/providers/favorites_provider.dart';
import '../lib/home_page.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the HomePage is loaded
    expect(find.byType(HomePage), findsOneWidget);

    // Verify that the FavoritesProvider is properly initialized
    expect(find.byType(ChangeNotifierProvider<FavoritesProvider>), findsOneWidget);
  });
} 