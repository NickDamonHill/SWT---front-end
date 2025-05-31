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
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
