class Delivery {
  final int? id;
  final String numero;
  final String cliente;
  final String endereco;
  final String cidade;
  final double valor;
  final DateTime dataPrevista;
  final String status;
  final String? observacoes;
  final String? contato;

  Delivery({
    this.id,
    required this.numero,
    required this.cliente,
    required this.endereco,
    required this.cidade,
    required this.valor,
    required this.dataPrevista,
    required this.status,
    this.observacoes,
    this.contato,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'numero': numero,
        'cliente': cliente,
        'endereco': endereco,
        'cidade': cidade,
        'valor': valor,
        'data_prevista': dataPrevista.toIso8601String(),
        'status': status,
        'observacoes': observacoes,
        'contato': contato,
      };

  factory Delivery.fromRow(Map row) {
    return Delivery(
      id: row['id'],
      numero: row['numero'],
      cliente: row['cliente'],
      endereco: row['endereco'],
      cidade: row['cidade'],
      valor: row['valor'],
      dataPrevista: row['data_prevista'],
      status: row['status'],
      observacoes: row['observacoes'],
      contato: row['contato'],
    );
  }
}
