import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/delivery.dart';
import '../services/delivery_service.dart';

class DeliveriesController {
  Router get router {
    final router = Router();

    // GET /deliveries  -> lista todas as entregas
    router.get('/', (Request req) async {
      final list = await DeliveryService.getAll();

      return Response.ok(
        jsonEncode(list.map((d) => d.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // POST /deliveries  -> cria uma entrega nova
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

      final id = await DeliveryService.create(delivery);

      return Response.ok(
        jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // PATCH /deliveries/<id>/status  -> atualiza status (Pendente/Em rota/Concluída/Atrasada)
    router.patch('/<id|[0-9]+>/status', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      final status = body['status'] as String;

      await DeliveryService.updateStatus(int.parse(id), status);

      return Response.ok(
        jsonEncode({'updated': true}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // DELETE /deliveries/<id>  -> opcional (excluir entrega)
    router.delete('/<id|[0-9]+>', (Request req, String id) async {
      await DeliveryService.delete(int.parse(id));
      return Response.ok(
        jsonEncode({'deleted': true}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
