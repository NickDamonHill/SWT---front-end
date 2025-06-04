class Order {
  final int id;
  final int customerId;
  final int productId;
  final int amount;
  final DateTime orderDate;
  final String status;
  final String address;

  Order({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.amount,
    required this.orderDate,
    required this.status,
    required this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      amount: json['amount'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'amount': amount,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'address': address,
    };
  }
} 