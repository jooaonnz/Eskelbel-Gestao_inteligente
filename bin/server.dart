import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:backend_eskelbel/database/db.dart';
import 'package:backend_eskelbel/routes/auth_routes.dart';
import 'package:backend_eskelbel/routes/delivery_routes.dart';
import 'package:backend_eskelbel/routes/product_routes.dart';
import 'package:backend_eskelbel/routes/transaction_routes.dart';
import 'package:backend_eskelbel/routes/dashboard_routes.dart';
import 'package:backend_eskelbel/controllers/deliveries_controller.dart';




Future<void> main() async {
  print('🚀 Iniciando servidor...');

  // Conectar ao banco MySQL
  await DB.connect();

  // Roteador principal
  final router = Router();

  // ROTAS
  router.mount('/auth/', AuthRoutes().router);
  router.mount('/deliveries/', DeliveryRoutes().router);
  router.mount('/products/', ProductRoutes().router);
  router.mount('/transactions/', TransactionRoutes().router);
  router.mount('/dashboard/', DashboardRoutes().router);
  router.mount('/deliveries/', DeliveriesController().router);



  // Pipeline com middlewares (log e CORS)
  final handler = Pipeline()
      .addMiddleware(logRequests()) // Log de cada requisição
      .addMiddleware(_corsMiddleware) // Libera acesso para Flutter / web
      .addHandler(router);

  // Inicia o servidor
  final server = await io.serve(
    handler,
    InternetAddress.anyIPv4, // Acessível por emuladores e rede local
    8080,
  );

  print('🔥 Servidor rodando em: http://localhost:${server.port}');
}

//
// Middleware de CORS — permite requisições externas
//
Middleware get _corsMiddleware {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }

      final response = await handler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};
