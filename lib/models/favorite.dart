
class Favorite {
  int user_id;
  int product_id;

  Favorite({
    required this.user_id,
    required this.product_id,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      user_id: json['user_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'product_id': product_id,
    };
  }


} 