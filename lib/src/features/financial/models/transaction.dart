enum TransactionType { receber, pagar }

enum TransactionStatus { pendente, pago, atrasado }

class Transaction {
  final String id;
  final TransactionType tipo;
  final String descricao;
  final String? cliente;
  final double valor;
  final DateTime vencimento;
  TransactionStatus status;
  final String categoria;

  Transaction({
    required this.id,
    required this.tipo,
    required this.descricao,
    this.cliente,
    required this.valor,
    required this.vencimento,
    required this.status,
    required this.categoria,
  });

  bool get isAtrasado {
    return status == TransactionStatus.atrasado ||
        (status == TransactionStatus.pendente && vencimento.isBefore(DateTime.now()));
  }

  int get diasAteVencimento {
    return vencimento.difference(DateTime.now()).inDays;
  }

  bool get estaMuitoProximo {
    return diasAteVencimento <= 3 && diasAteVencimento >= 0;
  }

  Transaction copyWith({
    String? id,
    TransactionType? tipo,
    String? descricao,
    String? cliente,
    double? valor,
    DateTime? vencimento,
    TransactionStatus? status,
    String? categoria,
  }) {
    return Transaction(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      cliente: cliente ?? this.cliente,
      valor: valor ?? this.valor,
      vencimento: vencimento ?? this.vencimento,
      status: status ?? this.status,
      categoria: categoria ?? this.categoria,
    );
  }
}
