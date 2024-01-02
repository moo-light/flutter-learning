class User {
  final int id;
  final String role;
  final String email;
  final String name;
  final String password;

  User({
    required this.id,
    required this.role,
    required this.email,
    required this.name,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

