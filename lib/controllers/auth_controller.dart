import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/auth_service.dart';

class AuthController {
  final _service = AuthService();

  Router get router {
    final router = Router();

    router.post('/login', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final email = body['email'];
      final password = body['password'];

      final user = await _service.login(email, password);

      if (user == null) {
        return Response.forbidden(jsonEncode({'error': 'Credenciais inválidas'}));
      }

      return Response.ok(jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
      }), headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
