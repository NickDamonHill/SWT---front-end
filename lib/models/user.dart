class User {
  final int id;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
  });

  String get fullName {
    return '$firstname $lastname';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstname: json['first_name'] as String,
      lastname: json['last_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstname,
      'last_name': lastname,
    };
  }
}
