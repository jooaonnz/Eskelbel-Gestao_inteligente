import '../database/db.dart';
import '../models/product.dart';

class ProductService {
  static Future<List<Product>> getAll() async {
    final result = await DB.connection.query('SELECT * FROM products ORDER BY id DESC');
    return result.map((row) => Product.fromRow(row.fields)).toList();
  }

  static Future<int> create(Product p) async {
    final result = await DB.connection.query('''
      INSERT INTO products 
      (nome, codigo, categoria, estoque, estoque_minimo, preco, validade, fornecedor)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      p.nome,
      p.codigo,
      p.categoria,
      p.estoque,
      p.estoqueMinimo,
      p.preco,
      p.validade,
      p.fornecedor
    ]);

    return result.insertId!;
  }

  static Future<void> delete(int id) async {
    await DB.connection.query('DELETE FROM products WHERE id = ?', [id]);
  }

  static Future<void> adjustStock(int id, int amount) async {
    await DB.connection.query('UPDATE products SET estoque = estoque + ? WHERE id = ?', [amount, id]);
  }
}
