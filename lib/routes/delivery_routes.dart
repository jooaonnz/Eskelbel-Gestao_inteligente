import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/delivery_service.dart';
import '../models/delivery.dart';

class DeliveryRoutes {
  Handler get router {
    final router = Router();

    // GET /deliveries
    router.get('/', (Request req) async {
      final list = await DeliveryService.getAll();
      return Response.ok(jsonEncode(list.map((e) => e.toJson()).toList()),
          headers: {'Content-Type': 'application/json'});
    });

    // POST /deliveries
    router.post('/', (Request req) async {
      final body = jsonDecode(await req.readAsString());

      final delivery = Delivery(
        numero: body['numero'],
        cliente: body['cliente'],
        endereco: body['endereco'],
        cidade: body['cidade'],
        valor: body['valor'],
        dataPrevista: DateTime.parse(body['data_prevista']),
        status: body['status'],
        observacoes: body['observacoes'],
        contato: body['contato'],
      );

      final newId = await DeliveryService.create(delivery);

      return Response.ok(jsonEncode({'id': newId}),
          headers: {'Content-Type': 'application/json'});
    });

    // PUT /deliveries/:id/status
    router.put('/<id>/status', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      await DeliveryService.updateStatus(int.parse(id), body['status']);

      return Response.ok(jsonEncode({'status': 'ok'}),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
