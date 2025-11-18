import '../database/db.dart';

Future<void> createUsersTable() async {
  await DB.connection.query('''
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL,
      password VARCHAR(255) NOT NULL,
      role ENUM('admin','estoquista','motorista','financeiro') NOT NULL DEFAULT 'admin'
    );
  ''');

  print("✔ users OK");
}
