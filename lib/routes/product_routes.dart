import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductRoutes {
  Router get router {
    final router = Router();

    // GET /products
    router.get('/', (Request req) async {
      final list = await ProductService.getAll();
      return Response.ok(jsonEncode(list.map((e) => e.toJson()).toList()),
          headers: {'Content-Type': 'application/json'});
    });

    // POST /products
    router.post('/', (Request req) async {
      final data = jsonDecode(await req.readAsString());
      final product = Product(
        nome: data['nome'],
        codigo: data['codigo'],
        categoria: data['categoria'],
        estoque: data['estoque'],
        estoqueMinimo: data['estoque_minimo'],
        preco: double.parse(data['preco'].toString()),
        validade: data['validade'],
        fornecedor: data['fornecedor'],
      );

      final id = await ProductService.create(product);
      return Response.ok(jsonEncode({'id': id}),
          headers: {'Content-Type': 'application/json'});
    });

    // DELETE /products/:id
    router.delete('/<id|[0-9]+>', (Request req, String id) async {
      await ProductService.delete(int.parse(id));
      return Response.ok(jsonEncode({'deleted': true}),
          headers: {'Content-Type': 'application/json'});
    });

    // PATCH /products/:id/stock
    router.patch('/<id|[0-9]+>/stock', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      final amount = body['amount'] as int;
      await ProductService.adjustStock(int.parse(id), amount);
      return Response.ok(jsonEncode({'adjusted': true}),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
