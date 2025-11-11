import 'package:flutter/material.dart';

class DriverDashboardView extends StatelessWidget {
  final Map<String, dynamic> user;
  const DriverDashboardView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Olá, ${user['name']}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(
           child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text('Entrar'),
                      ),
          ),
          const SizedBox(height: 4),
          const Text('Bem-vindo ao painel de motorista', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          // KPIs do Motorista
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _KpiCard(
                icon: Icons.local_shipping,
                title: 'Hoje',
                value: '5 entregas',
                color: Colors.blue,
                subtitle: 'Programadas',
              ),
              _KpiCard(
                icon: Icons.check_circle,
                title: 'Concluídas',
                value: '3',
                color: Colors.green,
                subtitle: 'Este mês: 45',
              ),
              _KpiCard(
                icon: Icons.schedule,
                title: 'Em Rota',
                value: '2',
                color: Colors.orange,
                subtitle: '+1 atrasada',
              ),
              _KpiCard(
                icon: Icons.attach_money,
                title: 'Faturamento',
                value: 'R\$ 1.850',
                color: Colors.green,
                subtitle: 'Hoje',
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Atividades Recentes
          const Text('Atividades Recentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ActivityItem(
                    icon: Icons.check_circle,
                    title: 'Entrega #1245 concluída',
                    subtitle: 'Mercado Central - 10:30',
                    color: Colors.green,
                  ),
                  _ActivityItem(
                    icon: Icons.local_shipping,
                    title: 'Iniciada entrega #1246',
                    subtitle: 'Supermercado Bom Preço - 10:15',
                    color: Colors.blue,
                  ),
                  _ActivityItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Entrega #1244 atrasada',
                    subtitle: 'Vencimento: 09:45 - 12 min atrás',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
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

  const _KpiCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.subtitle,
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
                child: Text(subtitle!, style: TextStyle(fontSize: 12, color: color?.withOpacity(0.7))),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
