import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:backend_eskelbel/database/db.dart';
import 'package:backend_eskelbel/routes/delivery_routes.dart';


Future<void> main() async {
  print('🚀 Iniciando servidor...');

  
  await DB.connect();

  final router = Router();

  
  router.mount('/deliveries/', DeliveryRoutes().router);


  final handler = Pipeline()
      .addMiddleware(logRequests())   
      .addMiddleware(_corsMiddleware) 
      .addHandler(router);

  
  final server = await io.serve(
    handler,
    InternetAddress.anyIPv4, 
    8080,
  );

  print('🔥 Servidor rodando em http://localhost:${server.port}');
}


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
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};
