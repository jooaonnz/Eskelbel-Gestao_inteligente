import 'package:mysql1/mysql1.dart';
import '../database/db.dart';
import '../models/user.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    final result = await DB.connection.query(
      'SELECT * FROM users WHERE email = ? AND password = ? LIMIT 1',
      [email, password],
    );

    if (result.isEmpty) return null;

    return User.fromMySQL(result.first.fields);
  }
}
