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
    return Review(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rating: json['rating'],
      comment: json['comment'],
      reviewDate: DateTime.parse(json['review_date']),
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
