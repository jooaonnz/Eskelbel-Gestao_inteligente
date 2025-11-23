import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class TransactionController {
  final _service = TransactionService();

  Router get router {
    final router = Router();

    // GET /financial
    router.get('/', (Request req) async {
      final list = await _service.getAll();
      return Response.ok(
        jsonEncode(list.map((t) => t.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /financial/totals
    router.get('/totals', (Request req) async {
      final totals = await _service.getTotals();
      return Response.ok(jsonEncode(totals),
          headers: {'Content-Type': 'application/json'});
    });

    // POST /financial
    router.post('/', (Request req) async {
      final data = jsonDecode(await req.readAsString());
      final transaction = Transaction(
        tipo: data['tipo'],
        descricao: data['descricao'],
        cliente: data['cliente'],
        valor: double.parse(data['valor'].toString()),
        vencimento: DateTime.parse(data['vencimento']),
        status: data['status'] ?? 'pendente',
        categoria: data['categoria'],
      );
      final id = await _service.create(transaction);
      return Response.ok(jsonEncode({'id': id}),
          headers: {'Content-Type': 'application/json'});
    });

    // PATCH /financial/:id/status
    router.patch('/<id|[0-9]+>/status', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      await _service.updateStatus(int.parse(id), body['status']);
      return Response.ok(jsonEncode({'updated': true}),
          headers: {'Content-Type': 'application/json'});
    });

    // DELETE /financial/:id
    router.delete('/<id|[0-9]+>', (Request req, String id) async {
      await _service.delete(int.parse(id));
      return Response.ok(jsonEncode({'deleted': true}),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
