import '../lib/database/db.dart';
import '../lib/migrations/create_users_table.dart';
import '../lib/migrations/create_products_table.dart';
import '../lib/migrations/create_deliveries_table.dart';


Future<void> main() async {
  await DB.connect();

  print('🔧 Iniciando migrações...');

  await createProductsTable();
  print('✔ Tabela products OK');

  await createDeliveriesTable();
  print('✔ Tabela deliveries OK');

  print('🎉 Migrações concluídas!');
  await DB.close();
}

