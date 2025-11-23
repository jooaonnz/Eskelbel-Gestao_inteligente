class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
      };

  factory User.fromRow(Map<String, dynamic> row) {
    return User(
      id: row['id'],
      name: row['name'],
      email: row['email'],
      password: row['password'],
      role: row['role'],
    );
  }
}
