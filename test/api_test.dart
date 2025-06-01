import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_services.dart';
import '../lib/models/user.dart';
import '../lib/models/product.dart';
import '../lib/models/review.dart';
import '../lib/models/notification.dart';
import '../lib/models/order.dart';

void main() {
  group('API Tests', () {
    // Önce kayıt olup sonra giriş yapalım
    String testEmail = "esad@example.com";
    String testPassword = "securepassword123";

    test('Register and Login Test', () async {
      // Önce kayıt ol
      final registerResult = await registerUser(
        "Test",
        "User",
        testEmail,
        testPassword
      );
      expect(registerResult, false);

      // Sonra giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());
    });

    test('Get Products For Home Page Test', () async {
      final products = await getProductsForHomePage();
      print(products);
      expect(products, isNotEmpty);
    });

    test('Get Products By Category Test', () async {
      // Kategori ürünlerini getir
      final products = await getProductsByCategory(1);
      print(products);
      expect(products, isA<List<Product>>());
    });

    test('Get Products By User Test', () async {
      final products = await getProductsByUser(1);
      print(products);
      expect(products, isA<List<Product>>());
    });

    test('Add Product Test', () async {
      final addResult = await addProduct(1, "Test Product", 100, 1, 50);
      expect(addResult, true);
    });

    test('Get Product Reviews Test', () async {
      final reviews = await getProductReviews(2);
      expect(reviews, isA<List<Review>>());
    });

    test('Add and Remove Review Test', () async {
      final addResult = await addReview(2, 2, 5, "Test Review");
      expect(addResult, true);

      final removeResult = await removeReview(2);
      expect(removeResult, true);
    });

    

    test('Favorites Flow Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());

      // Favorilere ekle
      final addResult = await addToFavorites(user!.id, 2);
      expect(addResult, true);

      // Favorileri getir
      final favorites = await getFavorites(user.id);
      expect(favorites, isA<List<Product>>());

      // Favorilerden çıkar
      final removeResult = await removeFromFavorites(user.id, 2);
      expect(removeResult, true);
    });

    test('Get Notifications Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());

      // Bildirimleri getir
      final notifications = await getNotifications(user!.id);
      expect(notifications, isA<List<Notification>>());
    });

    test('Mark Notification As Read Test', () async {
      final markResult = await markNotificationAsRead(1);
      expect(markResult, true);
    });

    test('Get Orders Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());

      // Siparişleri getir
      final orders = await getOrders(user!.id);
      expect(orders, isA<List<Order>>());
    });

    test('Add To Orders Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());

      // Sipariş ekle
      final addResult = await addToOrders(user!.id, 4, 3, "Test Address");
      expect(addResult, true);
    });

    test('Purchase Order Test', () async {
      // Önce giriş yap
      final user = await checkUser(testEmail, testPassword);
      expect(user, isA<User>());

      // Siparişi satın al
      final purchaseResult = await purchaseOrder(1);
      expect(purchaseResult, true);
    });

    test('Cancel Order Test', () async {
      final cancelResult = await cancelOrder(2);
      expect(cancelResult, true);
    });
  });
}
