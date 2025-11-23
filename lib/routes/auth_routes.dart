import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/auth_service.dart';

class AuthRoutes {
  Router get router {
    final router = Router();

    // POST /auth/register
    router.post('/register', (Request req) async {
      final data = jsonDecode(await req.readAsString());
      final id = await AuthService.register(
        data['name'],
        data['email'],
        data['password'],
      );

      if (id == null) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao registrar usuário'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(jsonEncode({'id': id}),
          headers: {'Content-Type': 'application/json'});
    });

    // POST /auth/login
    router.post('/login', (Request req) async {
      final data = jsonDecode(await req.readAsString());
      final token = await AuthService.login(
        data['email'],
        data['password'],
      );

      if (token == null) {
        return Response.forbidden(
          jsonEncode({'error': 'Credenciais inválidas'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(jsonEncode({'token': token}),
          headers: {'Content-Type': 'application/json'});
    });

    // GET /auth/verify
    router.get('/verify', (Request req) async {
      final authHeader = req.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(jsonEncode({'error': 'Token ausente'}));
      }

      final token = authHeader.substring(7);
      final claims = AuthService.verifyToken(token);

      if (claims == null) {
        return Response.forbidden(jsonEncode({'error': 'Token inválido'}));
      }

      return Response.ok(
        jsonEncode({'valid': true, 'user': claims.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
