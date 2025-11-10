import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../../../shared/widgets/user_menu.dart';

class FinancialPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const FinancialPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  late List<Transaction> transactions;
  int currentTabIndex = 0;

  final List<String> categories = ['Vendas', 'Fornecedores', 'Operacional', 'Manutenção'];

  @override
  void initState() {
    super.initState();
    _initializeTransactions();
  }

  void _initializeTransactions() {
    transactions = [
      Transaction(
        id: '1',
        tipo: TransactionType.receber,
        descricao: 'Venda Mercado Central',
        cliente: 'Mercado Central',
        valor: 850.00,
        vencimento: DateTime(2025, 11, 10),
        status: TransactionStatus.pago,
        categoria: 'Vendas',
      ),
      Transaction(
        id: '2',
        tipo: TransactionType.receber,
        descricao: 'Venda Supermercado Bom Preço',
        cliente: 'Supermercado Bom Preço',
        valor: 450.00,
        vencimento: DateTime(2025, 11, 12),
        status: TransactionStatus.pendente,
        categoria: 'Vendas',
      ),
      Transaction(
        id: '3',
        tipo: TransactionType.receber,
        descricao: 'Venda Padaria Doce Pão',
        cliente: 'Padaria Doce Pão',
        valor: 320.00,
        vencimento: DateTime(2025, 11, 5),
        status: TransactionStatus.atrasado,
        categoria: 'Vendas',
      ),
      Transaction(
        id: '4',
        tipo: TransactionType.pagar,
        descricao: 'Fornecedor - Distribuidora ABC',
        valor: 5400.00,
        vencimento: DateTime(2025, 11, 15),
        status: TransactionStatus.pendente,
        categoria: 'Fornecedores',
      ),
      Transaction(
        id: '5',
        tipo: TransactionType.pagar,
        descricao: 'Combustível - Novembro',
        valor: 1200.00,
        vencimento: DateTime(2025, 11, 10),
        status: TransactionStatus.pago,
        categoria: 'Operacional',
      ),
      Transaction(
        id: '6',
        tipo: TransactionType.pagar,
        descricao: 'Manutenção Veículos',
        valor: 380.00,
        vencimento: DateTime(2025, 11, 8),
        status: TransactionStatus.pago,
        categoria: 'Manutenção',
      ),
    ];
  }

  List<Transaction> get todasTransactions => transactions;
  List<Transaction> get aReceber => transactions.where((t) => t.tipo == TransactionType.receber).toList();
  List<Transaction> get aPagar => transactions.where((t) => t.tipo == TransactionType.pagar).toList();

  double get totalReceber => aReceber.where((t) => t.status != TransactionStatus.pago).fold(0, (sum, t) => sum + t.valor);
  double get totalPagar => aPagar.where((t) => t.status != TransactionStatus.pago).fold(0, (sum, t) => sum + t.valor);
  double get totalRecebido => aReceber.where((t) => t.status == TransactionStatus.pago).fold(0, (sum, t) => sum + t.valor);
  double get totalPago => aPagar.where((t) => t.status == TransactionStatus.pago).fold(0, (sum, t) => sum + t.valor);
  double get saldo => totalRecebido - totalPago;

  void _updateStatus(String id, TransactionStatus status) {
    setState(() {
      final index = transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        transactions[index].status = status;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(status == TransactionStatus.pago ? 'Pagamento registrado!' : 'Status atualizado')),
    );
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction.copyWith(id: (transactions.length + 1).toString()));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação adicionada com sucesso!')),
    );
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão Financeira'),
        backgroundColor: Colors.blue,
        actions: [
          UserMenu(user: widget.user),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.attach_money, color: Colors.blue, size: 28),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gestão Financeira', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Controle de receitas e despesas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Resumo KPIs
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: [
                      _SummaryCard(
                        icon: Icons.trending_up,
                        title: 'A Receber',
                        value: _formatCurrency(totalReceber),
                        subtitle: 'Recebido: ${_formatCurrency(totalRecebido)}',
                        backgroundColor: Colors.green,
                      ),
                      _SummaryCard(
                        icon: Icons.trending_down,
                        title: 'A Pagar',
                        value: _formatCurrency(totalPagar),
                        subtitle: 'Pago: ${_formatCurrency(totalPago)}',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Card de Saldo
                  _BalanceCard(
                    saldo: saldo,
                    formatCurrency: _formatCurrency,
                  ),
                  const SizedBox(height: 16),
                  // Botão adicionar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddTransactionDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Nova Transação'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            // Tabs
            DefaultTabController(
              length: 3,
              initialIndex: currentTabIndex,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) => setState(() => currentTabIndex = index),
                    tabs: [
                      Tab(text: 'Todas (${todasTransactions.length})'),
                      Tab(text: 'A Receber (${aReceber.length})'),
                      Tab(text: 'A Pagar (${aPagar.length})'),
                    ],
                  ),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      children: [
                        _buildTransactionsList(todasTransactions),
                        _buildTransactionsList(aReceber),
                        _buildTransactionsList(aPagar),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<Transaction> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Nenhuma transação encontrada', style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _TransactionCard(
        transaction: items[index],
        onUpdateStatus: _updateStatus,
        formatCurrency: _formatCurrency,
        formatDate: _formatDate,
      ),
    );
  }

  void _showAddTransactionDialog() {
    String tipoSelecionado = 'receber';
    String descricao = '';
    String cliente = '';
    double valor = 0;
    DateTime vencimento = DateTime.now().add(const Duration(days: 7));
    String categoriaSelecionada = 'Vendas';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Nova Transação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: tipoSelecionado,
                  items: const [
                    DropdownMenuItem(value: 'receber', child: Text('A Receber')),
                    DropdownMenuItem(value: 'pagar', child: Text('A Pagar')),
                  ],
                  onChanged: (value) => setStateDialog(() => tipoSelecionado = value ?? 'receber'),
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => descricao = value,
                  decoration: const InputDecoration(labelText: 'Descrição', hintText: 'Ex: Venda para Cliente X'),
                ),
                const SizedBox(height: 12),
                if (tipoSelecionado == 'receber')
                  Column(
                    children: [
                      TextField(
                        onChanged: (value) => cliente = value,
                        decoration: const InputDecoration(labelText: 'Cliente'),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                TextField(
                  onChanged: (value) => valor = double.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Vencimento'),
                  subtitle: Text(_formatDate(vencimento)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: vencimento,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                    );
                    if (picked != null) {
                      setStateDialog(() => vencimento = picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: categoriaSelecionada,
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => setStateDialog(() => categoriaSelecionada = value ?? 'Vendas'),
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (descricao.isEmpty || valor <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos corretamente')),
                  );
                  return;
                }
                _addTransaction(
                  Transaction(
                    id: '',
                    tipo: tipoSelecionado == 'receber' ? TransactionType.receber : TransactionType.pagar,
                    descricao: descricao,
                    cliente: tipoSelecionado == 'receber' ? cliente : null,
                    valor: valor,
                    vencimento: vencimento,
                    status: TransactionStatus.pendente,
                    categoria: categoriaSelecionada,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color backgroundColor;

  const _SummaryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: backgroundColor.withOpacity(0.3), width: 1),
      ),
      color: backgroundColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: backgroundColor, size: 18),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: backgroundColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 11, color: backgroundColor.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double saldo;
  final String Function(double) formatCurrency;

  const _BalanceCard({
    Key? key,
    required this.saldo,
    required this.formatCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = saldo >= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: (isPositive ? Colors.blue : Colors.orange).withOpacity(0.3), width: 1),
      ),
      color: (isPositive ? Colors.blue : Colors.orange).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: isPositive ? Colors.blue : Colors.orange, size: 24),
                const SizedBox(width: 12),
                const Text('Saldo do Período', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              formatCurrency(saldo),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isPositive ? Colors.blue : Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Function(String, TransactionStatus) onUpdateStatus;
  final String Function(double) formatCurrency;
  final String Function(DateTime) formatDate;

  const _TransactionCard({
    Key? key,
    required this.transaction,
    required this.onUpdateStatus,
    required this.formatCurrency,
    required this.formatDate,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.pendente:
        return Colors.orange;
      case TransactionStatus.pago:
        return Colors.green;
      case TransactionStatus.atrasado:
        return Colors.red;
    }
  }

  String _getStatusLabel() {
    switch (transaction.status) {
      case TransactionStatus.pendente:
        return 'Pendente';
      case TransactionStatus.pago:
        return 'Pago';
      case TransactionStatus.atrasado:
        return 'Atrasado';
    }
  }

  IconData _getStatusIcon() {
    switch (transaction.status) {
      case TransactionStatus.pendente:
        return Icons.schedule;
      case TransactionStatus.pago:
        return Icons.check_circle;
      case TransactionStatus.atrasado:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReceita = transaction.tipo == TransactionType.receber;
    final statusColor = _getStatusColor();
    final borderColor = transaction.status == TransactionStatus.atrasado ? Colors.red[200] : Colors.grey[200];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.descricao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      if (transaction.cliente != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(transaction.cliente!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(_getStatusLabel(), style: const TextStyle(fontSize: 12, color: Colors.white)),
                            backgroundColor: statusColor,
                            avatar: Icon(_getStatusIcon(), size: 16, color: Colors.white),
                          ),
                          Chip(
                            label: Text(transaction.categoria, style: const TextStyle(fontSize: 12)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isReceita ? '+' : '-'} ${formatCurrency(transaction.valor)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isReceita ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vencimento:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      formatDate(transaction.vencimento),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: transaction.status == TransactionStatus.atrasado ? Colors.red : Colors.grey[900],
                      ),
                    ),
                  ],
                ),
                if (transaction.status != TransactionStatus.pago)
                  ElevatedButton.icon(
                    onPressed: () => onUpdateStatus(transaction.id, TransactionStatus.pago),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Marcar Pago'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
