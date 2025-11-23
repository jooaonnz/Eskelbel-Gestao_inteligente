import 'package:backend_eskelbel/database/db.dart';
import 'package:backend_eskelbel/migrations/create_products_table.dart';
import 'package:backend_eskelbel/migrations/create_deliveries_table.dart';
import 'package:backend_eskelbel/migrations/create_transactions_table.dart';

Future<void> main() async {
  await DB.connect();

  print('🔧 Iniciando migrações...');

  await createTransactionsTable();
  print('✔ Tabela transactions criada');

  await createProductsTable();
  print('✔ Tabela products criada');

  await createDeliveriesTable();
  print('✔ Tabela deliveries criada');

  print('🎉 Migrações concluídas com sucesso!');
  await DB.close();
}
