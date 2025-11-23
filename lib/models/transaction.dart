class TransactionModel {
  final int? id;
  final String tipo; // "receber" ou "pagar"
  final String descricao;
  final String? cliente;
  final double valor;
  final DateTime vencimento;
  final String status; // pendente, pago, atrasado
  final String categoria;

  TransactionModel({
    this.id,
    required this.tipo,
    required this.descricao,
    this.cliente,
    required this.valor,
    required this.vencimento,
    required this.status,
    required this.categoria,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'descricao': descricao,
        'cliente': cliente,
        'valor': valor,
        'vencimento': vencimento.toIso8601String(),
        'status': status,
        'categoria': categoria,
      };

  factory TransactionModel.fromRow(Map<String, dynamic> row) {
    return TransactionModel(
      id: row['id'],
      tipo: row['tipo'],
      descricao: row['descricao'],
      cliente: row['cliente'],
      valor: double.parse(row['valor'].toString()),
      vencimento: DateTime.parse(row['vencimento'].toString()),
      status: row['status'],
      categoria: row['categoria'],
    );
  }
}
