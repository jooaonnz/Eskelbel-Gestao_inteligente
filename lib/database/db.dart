import 'package:mysql1/mysql1.dart';

class DB {
  static MySqlConnection? _conn;

  static Future<void> connect() async {
    _conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'eskel',       // <-- NOVO
        password: '1234',    // <-- NOVO
        db: 'eskelbel',
      ),
    );
    print("MySQL conectado!");
  }
  static Future<void> close() async {
  await connection.close();
}


  static MySqlConnection get connection => _conn!;
}
