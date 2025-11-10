import 'package:flutter/material.dart';

class AdminReportsView extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminReportsView({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  String selectedPeriod = 'mes';

  // Dados de faturamento diário
  final List<Map<String, dynamic>> faturamentoDados = [
    {'nome': 'Seg', 'valor': 4500},
    {'nome': 'Ter', 'valor': 5200},
    {'nome': 'Qua', 'valor': 4800},
    {'nome': 'Qui', 'valor': 6100},
    {'nome': 'Sex', 'valor': 7300},
    {'nome': 'Sáb', 'valor': 3200},
  ];

  // Dados de vendas por categoria
  final List<Map<String, dynamic>> categoriaDados = [
    {'nome': 'Alimentos', 'valor': 45800, 'cor': Color(0xFF3b82f6)},
    {'nome': 'Bebidas', 'valor': 28300, 'cor': Color(0xFF10b981)},
    {'nome': 'Limpeza', 'valor': 15200, 'cor': Color(0xFFf59e0b)},
    {'nome': 'Higiene', 'valor': 12400, 'cor': Color(0xFF8b5cf6)},
  ];

  // Dados de entregas (6 últimos meses)
  final List<Map<String, dynamic>> entregasDados = [
    {'mes': 'Jun', 'concluidas': 145, 'falhas': 8},
    {'mes': 'Jul', 'concluidas': 168, 'falhas': 5},
    {'mes': 'Ago', 'concluidas': 182, 'falhas': 7},
    {'mes': 'Set', 'concluidas': 195, 'falhas': 4},
    {'mes': 'Out', 'concluidas': 210, 'falhas': 6},
    {'mes': 'Nov', 'concluidas': 189, 'falhas': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          _buildHeader(context),
          const SizedBox(height: 24),

          // Controles
          _buildControls(context),
          const SizedBox(height: 24),

          // KPI Cards
          _buildKPICards(context),
          const SizedBox(height: 24),

          // Gráfico de Faturamento Diário
          _buildFaturamentoCard(context),
          const SizedBox(height: 24),

          // Gráfico de Categorias
          _buildCategoriaCard(context),
          const SizedBox(height: 24),

          // Gráfico de Entregas
          _buildEntregasCard(context),
          const SizedBox(height: 24),

          // Relatórios Disponíveis
          _buildReportButtons(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, size: 28, color: Colors.blue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Relatórios e Análises',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Visualize indicadores e gere relatórios',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Seletor de período
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Período',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedPeriod,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'semana', child: Text('Esta Semana')),
                      DropdownMenuItem(value: 'mes', child: Text('Este Mês')),
                      DropdownMenuItem(value: 'trimestre', child: Text('Este Trimestre')),
                      DropdownMenuItem(value: 'ano', child: Text('Este Ano')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedPeriod = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Botões de Exportação
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Relatório PDF gerado com sucesso!')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 18),
                      const SizedBox(width: 8),
                      Text('PDF'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Relatório Excel exportado com sucesso!')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 18),
                      const SizedBox(width: 8),
                      Text('Excel'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICards(BuildContext context) {
    // Calcular totais
    double totalFaturamento =
        faturamentoDados.fold(0.0, (sum, item) => sum + item['valor']);
    int totalEntregas =
        entregasDados.fold(0, (sum, item) => sum + item['concluidas'] as int);
    double lucroLiquido = totalFaturamento * 0.35; // Margem estimada 35%

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildKPICard(
          title: 'Faturamento',
          value: 'R\$ ${(totalFaturamento / 1000).toStringAsFixed(0)}k',
          subtitle: '+8% vs mês anterior',
          icon: Icons.attach_money,
          color: Colors.green,
          showTrending: true,
        ),
        _buildKPICard(
          title: 'Lucro Líquido',
          value: 'R\$ ${(lucroLiquido / 1000).toStringAsFixed(1)}k',
          subtitle: 'Margem: 22%',
          icon: Icons.trending_up,
          color: Colors.blue,
          showTrending: false,
        ),
        _buildKPICard(
          title: 'Entregas',
          value: '$totalEntregas entregas',
          subtitle: '98,4% taxa sucesso',
          icon: Icons.local_shipping,
          color: Colors.orange,
          showTrending: false,
        ),
        _buildKPICard(
          title: 'Produtos',
          value: '347 itens',
          subtitle: '5 abaixo mínimo',
          icon: Icons.inventory,
          color: Colors.purple,
          showTrending: false,
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool showTrending,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Row(
              children: [
                if (showTrending)
                  Icon(Icons.trending_up, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: showTrending ? color : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaturamentoCard(BuildContext context) {
    double maxValue =
        faturamentoDados.fold(0, (max, item) => item['valor'] > max ? item['valor'] : max);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Faturamento Diário',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: faturamentoDados.map((item) {
                  double height = (item['valor'] / maxValue) * 150;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['nome'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(BuildContext context) {
    double totalVendas =
        categoriaDados.fold(0.0, (sum, item) => sum + item['valor']);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Vendas por Categoria',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Legenda circular (pseudo pie chart)
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      data: categoriaDados,
                      total: totalVendas,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Legenda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(categoriaDados.length, (index) {
                      final item = categoriaDados[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item['cor'],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nome'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${(item['valor'] / 1000).toStringAsFixed(1)}k',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntregasCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Histórico de Entregas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Mês')),
                  DataColumn(label: Text('Concluídas')),
                  DataColumn(label: Text('Falhas')),
                  DataColumn(label: Text('Taxa de Sucesso')),
                ],
                rows: entregasDados.map((item) {
                  int total = item['concluidas'] + item['falhas'];
                  double taxa = (item['concluidas'] / total) * 100;
                  return DataRow(cells: [
                    DataCell(Text(item['mes'])),
                    DataCell(Text(
                      item['concluidas'].toString(),
                      style: const TextStyle(color: Colors.green),
                    )),
                    DataCell(Text(
                      item['falhas'].toString(),
                      style: const TextStyle(color: Colors.red),
                    )),
                    DataCell(
                      Text('${taxa.toStringAsFixed(1)}%'),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gerar Relatórios',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildReportButton(
              label: 'Relatório Completo\nMensal',
              icon: Icons.description,
              color: Colors.blue,
            ),
            _buildReportButton(
              label: 'Análise de\nEstoque',
              icon: Icons.analytics,
              color: Colors.green,
            ),
            _buildReportButton(
              label: 'Performance de\nEntregas',
              icon: Icons.local_shipping,
              color: Colors.orange,
            ),
            _buildReportButton(
              label: 'Demonstrativo\nFinanceiro',
              icon: Icons.account_balance,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gerando: $label')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter para criar o gráfico de pizza simplificado
class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  PieChartPainter({
    required this.data,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -90 * (3.14159 / 180);

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i]['valor'] / total) * 2 * 3.14159;

      paint.color = data[i]['cor'];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
