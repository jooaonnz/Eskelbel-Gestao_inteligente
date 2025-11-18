import '../database/db.dart';
import '../models/product.dart';

class InventoryService {
  Future<List<Product>> getAll() async {
    final results = await DB.connection.query("SELECT * FROM products");
    return results.map((r) => Product.fromMySQL(r.fields)).toList();
  }

  Future<void> add(Map<String, dynamic> data) async {
    await DB.connection.query(
      '''
      INSERT INTO products (nome, codigo, categoria, estoque, estoque_minimo, preco, validade, fornecedor)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        data['nome'],
        data['codigo'],
        data['categoria'],
        data['estoque'],
        data['estoqueMinimo'],
        data['preco'],
        data['validade'],
        data['fornecedor'],
      ],
    );
  }

  Future<void> delete(int id) async {
    await DB.connection.query("DELETE FROM products WHERE id = ?", [id]);
  }

  Future<void> adjustStock(int id, int amount) async {
    await DB.connection.query(
      "UPDATE products SET estoque = estoque + ? WHERE id = ?",
      [amount, id],
    );
  }
}
