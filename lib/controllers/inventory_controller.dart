import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/inventory_service.dart';

class InventoryController {
  final _service = InventoryService();

  Router get router {
    final router = Router();

    // GET /inventory
    router.get('/', (Request req) async {
      final items = await _service.getAll();
      return Response.ok(
        jsonEncode(items.map((p) => p.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // POST /inventory/add
    router.post('/add', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      await _service.add(body);
      return Response.ok(jsonEncode({'message': 'Produto criado com sucesso'}));
    });

    // DELETE /inventory/delete/<id>
    router.delete('/delete/<id>', (Request req, String id) async {
      await _service.delete(int.parse(id));
      return Response.ok(jsonEncode({'message': 'Produto removido'}));
    });

    // POST /inventory/adjust/<id>
    router.post('/adjust/<id>', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      final amount = body['amount'] ?? 0;

      await _service.adjustStock(int.parse(id), amount);

      return Response.ok(jsonEncode({'message': 'Estoque atualizado'}));
    });

    return router;
  }
}
