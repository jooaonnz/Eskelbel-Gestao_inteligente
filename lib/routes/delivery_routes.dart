import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/delivery_service.dart';
import '../models/delivery.dart';

class DeliveryRoutes {
  Router get router {
    final router = Router();

    // GET /deliveries
    router.get('/', (Request req) async {
      final list = await DeliveryService.getAll();
      return Response.ok(
        jsonEncode(list.map((e) => e.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // POST /deliveries
    router.post('/', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final delivery = Delivery(
        numero: body['numero'],
        cliente: body['cliente'],
        endereco: body['endereco'],
        cidade: body['cidade'],
        valor: double.parse(body['valor'].toString()),
        dataPrevista: DateTime.parse(body['data_prevista']),
        status: body['status'] ?? 'pendente',
        observacoes: body['observacoes'],
        contato: body['contato'],
      );

      final newId = await DeliveryService.create(delivery);

      return Response.ok(
        jsonEncode({'id': newId}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // PATCH /deliveries/:id/status
    router.patch('/<id|[0-9]+>/status', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      await DeliveryService.updateStatus(int.parse(id), body['status']);

      return Response.ok(
        jsonEncode({'status': 'ok'}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
