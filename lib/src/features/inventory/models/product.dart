class Product {
  final String id;
  final String nome;
  final String codigo;
  final String categoria;
  int estoque;
  final int estoqueMinimo;
  final double preco;
  final String? validade;
  final String fornecedor;

  Product({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.categoria,
    required this.estoque,
    required this.estoqueMinimo,
    required this.preco,
    this.validade,
    required this.fornecedor,
  });

  bool get isLowStock => estoque < estoqueMinimo;

  bool get isExpiring {
    if (validade == null) return false;
    final expiryDate = DateTime.parse(validade!);
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 15 && daysUntilExpiry >= 0;
  }

  int get daysUntilExpiry {
    if (validade == null) return 0;
    final expiryDate = DateTime.parse(validade!);
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Product copyWith({
    String? id,
    String? nome,
    String? codigo,
    String? categoria,
    int? estoque,
    int? estoqueMinimo,
    double? preco,
    String? validade,
    String? fornecedor,
  }) {
    return Product(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      categoria: categoria ?? this.categoria,
      estoque: estoque ?? this.estoque,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      preco: preco ?? this.preco,
      validade: validade ?? this.validade,
      fornecedor: fornecedor ?? this.fornecedor,
    );
  }
}
