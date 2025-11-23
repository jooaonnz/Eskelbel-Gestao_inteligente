import '../database/db.dart';
import '../models/delivery.dart';

class DeliveryService {
  static Future<List<Delivery>> getAll() async {
    final result = await DB.connection.query("SELECT * FROM deliveries ORDER BY id DESC");
    return result.map((row) => Delivery.fromRow(row.fields)).toList();
  }

  static Future<int> create(Delivery d) async {
    final result = await DB.connection.query('''
      INSERT INTO deliveries 
      (numero, cliente, endereco, cidade, valor, data_prevista, status, observacoes, contato)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      d.numero,
      d.cliente,
      d.endereco,
      d.cidade,
      d.valor,
      d.dataPrevista.toIso8601String(),
      d.status,
      d.observacoes,
      d.contato
    ]);
    return result.insertId!;
  }

  static Future<void> updateStatus(int id, String status) async {
    await DB.connection.query(
      "UPDATE deliveries SET status = ? WHERE id = ?",
      [status, id],
    );
  }

  static Future<void> delete(int id) async {
    await DB.connection.query("DELETE FROM deliveries WHERE id = ?", [id]);
  }
}
