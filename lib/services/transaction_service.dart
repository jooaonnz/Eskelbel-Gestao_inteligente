import '../database/db.dart';
import '../models/transaction.dart';

class TransactionService {
  static Future<List<TransactionModel>> getAll() async {
    final result = await DB.connection.query(
      'SELECT * FROM transactions ORDER BY vencimento DESC',
    );
    return result.map((r) => TransactionModel.fromRow(r.fields)).toList();
  }

  static Future<int> create(TransactionModel t) async {
    final result = await DB.connection.query('''
      INSERT INTO transactions
      (tipo, descricao, cliente, valor, vencimento, status, categoria)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      t.tipo,
      t.descricao,
      t.cliente,
      t.valor,
      t.vencimento.toIso8601String(),
      t.status,
      t.categoria,
    ]);
    return result.insertId!;
  }

  static Future<void> updateStatus(int id, String status) async {
    await DB.connection.query(
      'UPDATE transactions SET status = ? WHERE id = ?',
      [status, id],
    );
  }

  static Future<void> delete(int id) async {
    await DB.connection.query('DELETE FROM transactions WHERE id = ?', [id]);
  }
}
