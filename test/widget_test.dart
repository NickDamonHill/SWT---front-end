import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swt_front_end/main.dart';
import 'package:swt_front_end/providers/favorites_provider.dart';
import 'package:swt_front_end/home_page.dart';

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