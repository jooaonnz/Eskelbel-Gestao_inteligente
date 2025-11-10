import 'package:flutter/material.dart';
import '../../../shared/widgets/user_menu.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> user;
  const DashboardPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = {
      'faturamentoMensal': 145680.50,
      'faturamentoHoje': 8450.00,
      'lucroMensal': 32140.20,
      'entregasConcluidas': 47,
      'entregasPendentes': 12,
      'produtosVencendo': 8,
      'estoqueMinimo': 5,
      'inadimplentes': 3,
    };

    final recentActivities = [
      {'id': 1, 'type': 'entrega', 'msg': 'Entrega #1247 concluída - Cliente: Mercado Central', 'time': '5 min atrás'},
      {'id': 2, 'type': 'estoque', 'msg': 'Produto "Arroz 5kg" atingiu estoque mínimo', 'time': '15 min atrás'},
      {'id': 3, 'type': 'financeiro', 'msg': 'Pagamento recebido - Cliente: Supermercado Bom Preço', 'time': '1 hora atrás'},
      {'id': 4, 'type': 'entrega', 'msg': 'Entrega #1248 em rota - Motorista: Carlos Santos', 'time': '2 horas atrás'},
    ];

    final produtosVencendo = [
      {'name': 'Leite Integral 1L', 'validade': '2025-11-15', 'qtd': 24},
      {'name': 'Iogurte Natural', 'validade': '2025-11-12', 'qtd': 36},
      {'name': 'Queijo Mussarela', 'validade': '2025-11-18', 'qtd': 12},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          UserMenu(user: user),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação
            Text('Olá, ${user['name']}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Aqui está um resumo das suas operações', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            // KPIs principais
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _KpiCard(
                  icon: Icons.attach_money,
                  title: 'Hoje',
                  value: 'R\$ ${(stats['faturamentoHoje'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.green,
                  subtitle: '+12%',
                ),
                _KpiCard(
                  icon: Icons.attach_money,
                  title: 'Este mês',
                  value: 'R\$ ${(stats['faturamentoMensal'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.blue,
                  subtitle: '+8%',
                ),
                _KpiCard(
                  icon: Icons.local_shipping,
                  title: 'Entregas',
                  value: '${(stats['entregasConcluidas'] as int? ?? 0)} / ${(stats['entregasConcluidas'] as int? ?? 0) + (stats['entregasPendentes'] as int? ?? 0)}',
                  color: Colors.grey[900],
                  progress: ((stats['entregasConcluidas'] as int? ?? 0) + (stats['entregasPendentes'] as int? ?? 0)) > 0
                      ? (stats['entregasConcluidas'] as int? ?? 0) /
                        ((stats['entregasConcluidas'] as int? ?? 0) + (stats['entregasPendentes'] as int? ?? 0))
                      : 0.0,
                ),
                _KpiCard(
                  icon: Icons.inventory,
                  title: 'Lucro Mensal',
                  value: 'R\$ ${(stats['lucroMensal'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.green,
                  subtitle: 'Margem: 22%',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Alertas
            if ((stats['produtosVencendo'] as int? ?? 0) > 0 || (stats['estoqueMinimo'] as int? ?? 0) > 0 || (stats['inadimplentes'] as int? ?? 0) > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alertas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if ((stats['produtosVencendo'] as int? ?? 0) > 0)
                    _AlertCard(
                      icon: Icons.warning_amber_rounded,
                      color: Colors.orange,
                      text: '${stats['produtosVencendo']} produtos vencendo em até 15 dias',
                    ),
                  if ((stats['estoqueMinimo'] as int? ?? 0) > 0)
                    _AlertCard(
                      icon: Icons.warning_amber_rounded,
                      color: Colors.red,
                      text: '${stats['estoqueMinimo']} produtos abaixo do estoque mínimo',
                    ),
                  if ((stats['inadimplentes'] as int? ?? 0) > 0)
                    _AlertCard(
                      icon: Icons.warning_amber_rounded,
                      color: Colors.yellow[700],
                      text: '${stats['inadimplentes']} clientes com pagamentos atrasados',
                    ),
                ],
              ),
            const SizedBox(height: 24),
            // Produtos Vencendo
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Produtos Próximos do Vencimento', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...produtosVencendo.map((produto) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(produto['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Validade: ${produto['validade'] as String? ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              Text('${produto['qtd'] as int? ?? 0} un', style: const TextStyle(color: Colors.orange)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Atividades recentes
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Atividades Recentes', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...recentActivities.map((activity) => Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: activity['type'] == 'entrega'
                                    ? Colors.blue[100]
                                    : activity['type'] == 'estoque'
                                        ? Colors.orange[100]
                                        : Colors.green[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                activity['type'] == 'entrega'
                                    ? Icons.local_shipping
                                    : activity['type'] == 'estoque'
                                        ? Icons.inventory
                                        : Icons.attach_money,
                                color: activity['type'] == 'entrega'
                                    ? Colors.blue
                                    : activity['type'] == 'estoque'
                                        ? Colors.orange
                                        : Colors.green,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activity['msg'] as String? ?? '', style: const TextStyle(fontSize: 14)),
                                  Text(activity['time'] as String? ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final String? subtitle;
  final double? progress;

  const _KpiCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.subtitle,
    this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(subtitle!, style: TextStyle(fontSize: 12, color: color)),
              ),
            if (progress != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String text;

  const _AlertCard({Key? key, required this.icon, this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color?.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
