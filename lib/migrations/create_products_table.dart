import '../database/db.dart';

Future<void> createProductsTable() async {
  await DB.connection.query('''
    CREATE TABLE IF NOT EXISTS products (
      id INT AUTO_INCREMENT PRIMARY KEY,
      nome VARCHAR(150) NOT NULL,
      codigo VARCHAR(50) NOT NULL,
      categoria VARCHAR(50) NOT NULL,
      estoque INT NOT NULL,
      estoque_minimo INT NOT NULL,
      preco DECIMAL(10,2) NOT NULL,
      validade DATE NULL,
      fornecedor VARCHAR(100) NOT NULL
    );
  ''');

  print("✔ products OK");
}
