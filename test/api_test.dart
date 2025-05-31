import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_services.dart';

void main() {
  group('API Tests', () {
    // Önce kayıt olup sonra giriş yapalım
    String testEmail = "esad@example.com";
    String testPassword = "securepassword123";

    // test('Register and Login Test', () async {
    //   // Önce kayıt ol
    //   final registerResult = await registerUser(
    //     "Test",
    //     "User",
    //     testEmail,
    //     testPassword
    //   );
    //   expect(registerResult, true);

    //   // Sonra giriş yap
    //   final user = await checkUser(testEmail, testPassword);
    //   expect(user, isNotNull);
    // });

    test('Get Products For Home Page Test', () async {
      final products = await getProductsForHomePage();
      expect(products, isNotEmpty);
    });

    test('Get Products By Category Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Kategori ürünlerini getir
      final products = await getProductsByCategory(1);
      expect(products, isNotEmpty);
    });

    test('Favorites Flow Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Favorilere ekle
      final addResult = await addToFavorites(user!.id, 1);
      expect(addResult, true);

      // Favorileri getir
      final favorites = await getFavorites(user.id);
      expect(favorites, isNotEmpty);

      // Favorilerden çıkar
      final removeResult = await removeFromFavorites(user.id, 1);
      expect(removeResult, true);
    });

    test('Get Notifications Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Bildirimleri getir
      final notifications = await getNotifications(user!.id);
      expect(notifications, isNotEmpty);
    });

    test('Get Orders Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Siparişleri getir
      final orders = await getOrders(user!.id);
      expect(orders, isNotEmpty);
    });

    test('Add To Orders Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Sipariş ekle
      final addResult = await addToOrders(user!.id, 1, 1, "Test Address");
      expect(addResult, true);
    });

    test('Purchase Order Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isNotNull);

      // Siparişi satın al
      final purchaseResult = await purchaseOrder(1);
      expect(purchaseResult, true);
    });
    
  });
}
