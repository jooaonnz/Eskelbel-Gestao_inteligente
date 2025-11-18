import '../../lib/database/db.dart';

Future<void> createDeliveriesTable() async {
  final conn = DB.connection;

  await conn.query('''
    CREATE TABLE IF NOT EXISTS deliveries (
      id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      numero VARCHAR(50) NOT NULL,
      cliente VARCHAR(120) NOT NULL,
      endereco VARCHAR(150) NOT NULL,
      cidade VARCHAR(80) NOT NULL,
      valor DOUBLE NOT NULL,
      data_prevista DATETIME NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'pendente',
      observacoes TEXT NULL,
      contato VARCHAR(50) NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ''');
}
