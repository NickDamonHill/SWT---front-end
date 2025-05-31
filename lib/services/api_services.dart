import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/notification.dart';
import '../models/order.dart';

var client = http.Client();

const hostAddress = "https://stc-backend-bb4a69ac964c.herokuapp.com";
const version = "56";

Future<User?> checkUser(String email, String password) async {
  const host = "$hostAddress/login";

  var resp = await client.post(Uri.parse(host),
      body: jsonEncode(<String, String>{"email": email, "password": password}),
      headers: {"Content-Type": "application/json"});
  print(resp.body);
  if (resp.statusCode == 200) {
    final jsonData = jsonDecode(resp.body);
    // Check if the response contains an error message
    if (jsonData is Map<String, dynamic> && jsonData.containsKey('error')) {
      print('API returned error: ${jsonData['error']}');
      return null;
    }

    try {
      final userData = User.fromJson(jsonData);
      return userData;
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  } else if (resp.statusCode == 401) {
    return null;
  } else if (resp.statusCode == 404) {
    return null;
  } else {
    print('Login failed with status code: ${resp.statusCode}');
    return null;
  }
}

Future<bool> registerUser(String firstname, String lastname, String email,
    String password) async {
  final host = "$hostAddress/register";
  print(jsonEncode({
    "first_name": firstname,
    "last_name": lastname,
    "email": email,
    "password": password,
  }));
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "first_name": firstname,
        "last_name": lastname,
        "email": email,
        "password": password,
      }),
      headers: {"Content-Type": "application/json"},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error registering employee: $e');
    return false;
  }
}

// Get some products for home page
Future<List<Product>> getProductsForHomePage() async {
  final host = "$hostAddress/homepage";
  try {
    var resp = await client.get(
    Uri.parse(host),
    headers: {"Accept": "application/json"},
  );
  print(resp.body);
  if (resp.statusCode == 200) {
    List<Product> productList = [];
    final List<dynamic> data = jsonDecode(resp.body);
    for (var e in data) {
      productList.add(Product.fromJson(e));
    }
    return productList;
  } else {
    throw Exception('Failed to load products for home page');
  }
  } catch (e) {
    print('Error getting products for home page: $e');
    return [];
  }
}

// Get products by category
Future<List<Product>> getProductsByCategory(int categoryId) async {
  final host = "$hostAddress/categories/$categoryId";
  try {
    var resp = await client.get(
    Uri.parse(host),
    headers: {"Accept": "application/json"},
  );
  
  if (resp.statusCode == 200) {
    List<Product> productList = [];
    final List<dynamic> data = jsonDecode(resp.body);
    for (var e in data) {
      productList.add(Product.fromJson(e));
    }
    
    return productList;
  } else {
    throw Exception('Failed to load products for home page');
  }
  } catch (e) {
    print('Error getting products for home page: $e');
    return [];
  }
}

// Add product
Future<bool> addProduct(int userId, String name, double price, int categoryId, int amount) async {
  final host = "$hostAddress/addProduct";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "user_id": userId,
        "name": name,
        "price": price,
        "category_id": categoryId,
        "amount": amount,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error adding product: $e');
    return false;
  }
}

// Remove product
Future<bool> removeProduct(int userId, int productId) async {
  final host = "$hostAddress/removeProduct/$productId";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({"user_id": userId}),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error removing product: $e');
    return false;
  }
}

// Get product reviews
Future<List<Review>> getProductReviews(int productId) async {
  final host = "$hostAddress/reviews/$productId";
  try {
    var resp = await client.post(
      Uri.parse(host),
      headers: {"Content-Type": "application/json"},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  } catch (e) {
    print('Error getting reviews: $e');
    return [];
  }
}

// Add review
Future<bool> addReview(int productId, int userId, int rating, String comment) async {
  final host = "$hostAddress/reviews/$productId/add";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "user_id": userId,
        "rating": rating,
        "comment": comment,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error adding review: $e');
    return false;
  }
}

// Remove review
Future<bool> removeReview(int reviewId) async {
  final host = "$hostAddress/reviews/$reviewId/remove";
  try {
    var resp = await client.post(
      Uri.parse(host),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error removing review: $e');
    return false;
  }
}

// Get favorites
Future<List<Product>> getFavorites(int userId) async {
  final host = "$hostAddress/favorites";
  try {
    var resp = await client.get(
      Uri.parse(host),
      headers: {"Accept": "application/json"},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  } catch (e) {
    print('Error getting favorites: $e');
    return [];
  }
}

// Add to favorites
Future<bool> addToFavorites(int userId, int productId) async {
  final host = "$hostAddress/favorites/add";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "user_id": userId,
        "product_id": productId,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error adding to favorites: $e');
    return false;
  }
}

// Remove from favorites
Future<bool> removeFromFavorites(int userId, int productId) async {
  final host = "$hostAddress/favorites/remove";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "user_id": userId,
        "product_id": productId,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error removing from favorites: $e');
    return false;
  }
}

// Get notifications
Future<List<Notification>> getNotifications(int userId) async {
  final host = "$hostAddress/notification/$userId";
  try {
    var resp = await client.get(
      Uri.parse(host),
      headers: {"Accept": "application/json"},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Notification.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  } catch (e) {
    print('Error getting notifications: $e');
    return [];
  }
}

// Mark notification as read
Future<bool> markNotificationAsRead(int notificationId) async {
  final host = "$hostAddress/notificationIsRead/$notificationId";
  try {
    var resp = await client.get(
      Uri.parse(host),
      headers: {"Accept": "application/json"},
    );
    print(resp.body);
    return resp.statusCode == 200;
  } catch (e) {
    print('Error marking notification as read: $e');
    return false;
  }
}

// Get orders
Future<List<Order>> getOrders(int userId) async {
  final host = "$hostAddress/orders";
  try {
    var resp = await client.get(
      Uri.parse(host),
      headers: {"Accept": "application/json"},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  } catch (e) {
    print('Error getting orders: $e');
    return [];
  }
}

// Add to orders
Future<bool> addToOrders(int userId, int productId, int amount, String address) async {
  final host = "$hostAddress/addToOrders";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({
        "user_id": userId,
        "product_id": productId,
        "amount": amount,
        "address": address,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error adding to orders: $e');
    return false;
  }
}

// Purchase order
Future<bool> purchaseOrder(int orderId) async {
  final host = "$hostAddress/purchase";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({"order_id": orderId}),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error purchasing order: $e');
    return false;
  }
}

// Cancel order
Future<bool> cancelOrder(int orderId) async {
  final host = "$hostAddress/cancelOrder";
  try {
    var resp = await client.post(
      Uri.parse(host),
      body: jsonEncode({"order_id": orderId}),
      headers: {"Content-Type": "application/json"},
    );
    return resp.statusCode == 200;
  } catch (e) {
    print('Error canceling order: $e');
    return false;
  }
}

