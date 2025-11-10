import 'package:flutter/material.dart';
import '../models/delivery.dart';

class DriverDeliveriesView extends StatefulWidget {
  final Map<String, dynamic> user;
  const DriverDeliveriesView({Key? key, required this.user}) : super(key: key);

  @override
  State<DriverDeliveriesView> createState() => _DriverDeliveriesViewState();
}

class _DriverDeliveriesViewState extends State<DriverDeliveriesView> {
  late List<Delivery> deliveries;
  String selectedFilter = 'todas';

  @override
  void initState() {
    super.initState();
    _initializeDeliveries();
  }

  void _initializeDeliveries() {
    deliveries = [
      Delivery(
        id: '1',
        numero: '1245',
        cliente: 'Mercado Central',
        endereco: 'Rua das Flores, 123',
        cidade: 'São Paulo',
        valor: 450.00,
        dataPrevista: DateTime.now().subtract(const Duration(hours: 2)),
        status: DeliveryStatus.concluida,
        contato: '(11) 98765-4321',
      ),
      Delivery(
        id: '2',
        numero: '1246',
        cliente: 'Supermercado Bom Preço',
        endereco: 'Av. Paulista, 456',
        cidade: 'São Paulo',
        valor: 380.50,
        dataPrevista: DateTime.now().add(const Duration(hours: 1)),
        status: DeliveryStatus.emrota,
        contato: '(11) 98888-5555',
      ),
      Delivery(
        id: '3',
        numero: '1244',
        cliente: 'Padaria Doce Pão',
        endereco: 'Rua do Comércio, 789',
        cidade: 'São Paulo',
        valor: 220.00,
        dataPrevista: DateTime.now().subtract(const Duration(minutes: 45)),
        status: DeliveryStatus.atrasada,
        contato: '(11) 97777-6666',
        observacoes: 'Cliente não estava no local',
      ),
      Delivery(
        id: '4',
        numero: '1247',
        cliente: 'Distribuidora ABC',
        endereco: 'Rua Industrial, 1000',
        cidade: 'Guarulhos',
        valor: 650.00,
        dataPrevista: DateTime.now().add(const Duration(hours: 3)),
        status: DeliveryStatus.pendente,
        contato: '(11) 96666-7777',
      ),
      Delivery(
        id: '5',
        numero: '1248',
        cliente: 'Loja Magazine',
        endereco: 'Av. Brasil, 2000',
        cidade: 'São Paulo',
        valor: 520.00,
        dataPrevista: DateTime.now().add(const Duration(hours: 5)),
        status: DeliveryStatus.pendente,
        contato: '(11) 95555-8888',
      ),
    ];
  }

  List<Delivery> get filteredDeliveries {
    switch (selectedFilter) {
      case 'pendente':
        return deliveries.where((d) => d.status == DeliveryStatus.pendente).toList();
      case 'emrota':
        return deliveries.where((d) => d.status == DeliveryStatus.emrota).toList();
      case 'concluida':
        return deliveries.where((d) => d.status == DeliveryStatus.concluida).toList();
      case 'atrasada':
        return deliveries.where((d) => d.status == DeliveryStatus.atrasada).toList();
      default:
        return deliveries;
    }
  }

  void _updateDeliveryStatus(String id, DeliveryStatus status) {
    setState(() {
      final index = deliveries.indexWhere((d) => d.id == id);
      if (index != -1) {
        deliveries[index].status = status;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Entrega #${deliveries.firstWhere((d) => d.id == id).numero} atualizada!')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final pendentes = deliveries.where((d) => d.status == DeliveryStatus.pendente).length;
    final emrota = deliveries.where((d) => d.status == DeliveryStatus.emrota).length;
    final concluidas = deliveries.where((d) => d.status == DeliveryStatus.concluida).length;
    final atrasadas = deliveries.where((d) => d.status == DeliveryStatus.atrasada).length;

    return Column(
      children: [
        // Filtros como chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _FilterChip(
                label: 'Todas (${deliveries.length})',
                isSelected: selectedFilter == 'todas',
                onTap: () => setState(() => selectedFilter = 'todas'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Pendentes ($pendentes)',
                isSelected: selectedFilter == 'pendente',
                onTap: () => setState(() => selectedFilter = 'pendente'),
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Em Rota ($emrota)',
                isSelected: selectedFilter == 'emrota',
                onTap: () => setState(() => selectedFilter = 'emrota'),
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Concluídas ($concluidas)',
                isSelected: selectedFilter == 'concluida',
                onTap: () => setState(() => selectedFilter = 'concluida'),
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Atrasadas ($atrasadas)',
                isSelected: selectedFilter == 'atrasada',
                onTap: () => setState(() => selectedFilter = 'atrasada'),
                color: Colors.red,
              ),
            ],
          ),
        ),
        // Lista de entregas
        Expanded(
          child: filteredDeliveries.isEmpty
              ? Center(
                  child: Text('Nenhuma entrega encontrada', style: Theme.of(context).textTheme.bodyLarge),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDeliveries.length,
                  itemBuilder: (context, index) => _DeliveryCard(
                    delivery: filteredDeliveries[index],
                    onUpdateStatus: _updateDeliveryStatus,
                    formatDate: _formatDate,
                    formatCurrency: _formatCurrency,
                  ),
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : null)),
      onSelected: (_) => onTap(),
      selected: isSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: color ?? Colors.blue,
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final Function(String, DeliveryStatus) onUpdateStatus;
  final String Function(DateTime) formatDate;
  final String Function(double) formatCurrency;

  const _DeliveryCard({
    Key? key,
    required this.delivery,
    required this.onUpdateStatus,
    required this.formatDate,
    required this.formatCurrency,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (delivery.status) {
      case DeliveryStatus.pendente:
        return Colors.orange;
      case DeliveryStatus.emrota:
        return Colors.blue;
      case DeliveryStatus.concluida:
        return Colors.green;
      case DeliveryStatus.atrasada:
        return Colors.red;
    }
  }

  String _getStatusLabel() {
    switch (delivery.status) {
      case DeliveryStatus.pendente:
        return 'Pendente';
      case DeliveryStatus.emrota:
        return 'Em Rota';
      case DeliveryStatus.concluida:
        return 'Concluída';
      case DeliveryStatus.atrasada:
        return 'Atrasada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entrega #${delivery.numero}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(delivery.cliente, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                Chip(
                  label: Text(_getStatusLabel(), style: const TextStyle(color: Colors.white)),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(delivery.endereco, style: const TextStyle(fontSize: 13)),
                      Text(delivery.cidade, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Text(formatDate(delivery.dataPrevista), style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Text(formatCurrency(delivery.valor), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            if (delivery.contato != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(delivery.contato!, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            if (delivery.observacoes != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(delivery.observacoes!, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (delivery.status != DeliveryStatus.concluida)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showStatusMenu(context),
                  style: ElevatedButton.styleFrom(backgroundColor: statusColor),
                  child: const Text('Atualizar Status'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showStatusMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Atualizar Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.orange),
              title: const Text('Pendente'),
              onTap: () {
                onUpdateStatus(delivery.id, DeliveryStatus.pendente);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.blue),
              title: const Text('Em Rota'),
              onTap: () {
                onUpdateStatus(delivery.id, DeliveryStatus.emrota);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Concluída'),
              onTap: () {
                onUpdateStatus(delivery.id, DeliveryStatus.concluida);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              title: const Text('Atrasada'),
              onTap: () {
                onUpdateStatus(delivery.id, DeliveryStatus.atrasada);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
