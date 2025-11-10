class Report {
  final String id;
  final String title;
  final String description;
  final String icon;
  final ReportType type;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
  });
}

enum ReportType { completo, estoque, entregas, financeiro }

class ChartData {
  final String label;
  final double value;
  final String? color;

  ChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class FaturamentoData {
  final String dia;
  final double valor;

  FaturamentoData({
    required this.dia,
    required this.valor,
  });
}

class EntregasData {
  final String mes;
  final int concluidas;
  final int falhas;

  EntregasData({
    required this.mes,
    required this.concluidas,
    required this.falhas,
  });
}
