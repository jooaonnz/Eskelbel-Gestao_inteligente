import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionRoutes {
  Router get router {
    final router = Router();

    // GET /transactions
    router.get('/', (Request req) async {
      final list = await TransactionService.getAll();
      return Response.ok(jsonEncode(list.map((e) => e.toJson()).toList()),
          headers: {'Content-Type': 'application/json'});
    });

    // POST /transactions
    router.post('/', (Request req) async {
      final data = jsonDecode(await req.readAsString());
      final t = Transaction(
        tipo: data['tipo'],
        descricao: data['descricao'],
        cliente: data['cliente'],
        valor: double.parse(data['valor'].toString()),
        vencimento: DateTime.parse(data['vencimento']),
        status: data['status'],
        categoria: data['categoria'],
      );
      final id = await TransactionService.create(t);
      return Response.ok(jsonEncode({'id': id}),
          headers: {'Content-Type': 'application/json'});
    });

    // PATCH /transactions/:id/status
    router.patch('/<id|[0-9]+>/status', (Request req, String id) async {
      final data = jsonDecode(await req.readAsString());
      await TransactionService.updateStatus(int.parse(id), data['status']);
      return Response.ok(jsonEncode({'updated': true}),
          headers: {'Content-Type': 'application/json'});
    });

    // GET /transactions/resumo
    router.get('/resumo', (Request req) async {
      final resumo = await TransactionService.getResumo();
      return Response.ok(jsonEncode(resumo),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
