import 'package:intl/intl.dart';

class Review {
  final int id;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final DateTime reviewDate;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.reviewDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // RFC 2822 formatındaki tarihi işle
    final dateStr = json['review_date'] as String;
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss z');
    final date = dateFormat.parse(dateStr);
    
    return Review(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rating: json['rating'],
      comment: json['comment'],
      reviewDate: date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'review_date': reviewDate.toIso8601String(),
    };
  }
}
