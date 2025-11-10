enum DeliveryStatus { pendente, emrota, concluida, atrasada }

class Delivery {
  final String id;
  final String numero;
  final String cliente;
  final String endereco;
  final String cidade;
  final double valor;
  final DateTime dataPrevista;
  DeliveryStatus status;
  final String? observacoes;
  final String? contato;

  Delivery({
    required this.id,
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

  bool get isAtrasada {
    return status == DeliveryStatus.atrasada ||
        (status == DeliveryStatus.pendente && dataPrevista.isBefore(DateTime.now()));
  }

  int get horasRestantes {
    return dataPrevista.difference(DateTime.now()).inHours;
  }

  Delivery copyWith({
    String? id,
    String? numero,
    String? cliente,
    String? endereco,
    String? cidade,
    double? valor,
    DateTime? dataPrevista,
    DeliveryStatus? status,
    String? observacoes,
    String? contato,
  }) {
    return Delivery(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      cliente: cliente ?? this.cliente,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      valor: valor ?? this.valor,
      dataPrevista: dataPrevista ?? this.dataPrevista,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      contato: contato ?? this.contato,
    );
  }
}
