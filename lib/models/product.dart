class Product {
  final int? id;
  final String nome;
  final String codigo;
  final String categoria;
  final int estoque;
  final int estoqueMinimo;
  final double preco;
  final String? validade;
  final String fornecedor;

  Product({
    this.id,
    required this.nome,
    required this.codigo,
    required this.categoria,
    required this.estoque,
    required this.estoqueMinimo,
    required this.preco,
    this.validade,
    required this.fornecedor,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'codigo': codigo,
        'categoria': categoria,
        'estoque': estoque,
        'estoque_minimo': estoqueMinimo,
        'preco': preco,
        'validade': validade,
        'fornecedor': fornecedor,
      };

  factory Product.fromRow(Map<String, dynamic> row) {
    return Product(
      id: row['id'],
      nome: row['nome'],
      codigo: row['codigo'],
      categoria: row['categoria'],
      estoque: row['estoque'],
      estoqueMinimo: row['estoque_minimo'],
      preco: double.parse(row['preco'].toString()),
      validade: row['validade']?.toString(),
      fornecedor: row['fornecedor'],
    );
  }
}
