import '../database/db.dart';

Future<void> createTransactionsTable() async {
  await DB.connection.query('''
    CREATE TABLE IF NOT EXISTS transactions (
      id INT AUTO_INCREMENT PRIMARY KEY,
      tipo VARCHAR(20) NOT NULL,
      descricao VARCHAR(255) NOT NULL,
      cliente VARCHAR(100) NULL,
      valor DECIMAL(10,2) NOT NULL,
      vencimento DATETIME NOT NULL,
      status VARCHAR(20) NOT NULL,
      categoria VARCHAR(100) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=INNODB;
  ''');
}
