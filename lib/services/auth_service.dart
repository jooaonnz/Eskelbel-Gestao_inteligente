import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../database/db.dart';
import '../models/user.dart';

class AuthService {
  static const _jwtSecret = 'CHAVE_SECRETA_TOP'; // troque por algo forte

  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future<int?> register(String name, String email, String password) async {
    final hashed = _hashPassword(password);

    try {
      final result = await DB.connection.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [name, email, hashed],
      );
      return result.insertId;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return null;
    }
  }

  static Future<String?> login(String email, String password) async {
    final hashed = _hashPassword(password);
    final result = await DB.connection.query(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, hashed],
    );

    if (result.isEmpty) return null;

    final user = User.fromRow(result.first.fields);

    final claimSet = JwtClaim(
      subject: user.email,
      otherClaims: <String, dynamic>{
        'id': user.id,
        'name': user.name,
        'role': user.role,
      },
      maxAge: const Duration(hours: 2),
    );

    final token = issueJwtHS256(claimSet, _jwtSecret);
    return token;
  }

  static JwtClaim? verifyToken(String token) {
    try {
      return verifyJwtHS256Signature(token, _jwtSecret);
    } catch (_) {
      return null;
    }
  }
}
