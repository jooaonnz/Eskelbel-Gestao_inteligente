import 'package:flutter/material.dart';
import '../models/product.dart';
import '../../../shared/widgets/user_menu.dart';

class InventoryPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const InventoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late List<Product> products;
  String searchTerm = '';
  String selectedCategory = 'Todas';
  int currentTabIndex = 0;

  final List<String> categories = ['Todas', 'Alimentos', 'Bebidas', 'Limpeza', 'Higiene'];

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  void _initializeProducts() {
    products = [
      Product(
        id: '1',
        nome: 'Arroz Branco 5kg',
        codigo: '7891234567890',
        categoria: 'Alimentos',
        estoque: 45,
        estoqueMinimo: 20,
        preco: 28.90,
        validade: '2026-03-15',
        fornecedor: 'Distribuidora ABC',
      ),
      Product(
        id: '2',
        nome: 'Feijão Preto 1kg',
        codigo: '7891234567891',
        categoria: 'Alimentos',
        estoque: 12,
        estoqueMinimo: 15,
        preco: 9.50,
        validade: '2026-01-20',
        fornecedor: 'Distribuidora ABC',
      ),
      Product(
        id: '3',
        nome: 'Detergente Líquido 500ml',
        codigo: '7891234567892',
        categoria: 'Limpeza',
        estoque: 89,
        estoqueMinimo: 30,
        preco: 3.20,
        fornecedor: 'Química Total',
      ),
      Product(
        id: '4',
        nome: 'Leite Integral 1L',
        codigo: '7891234567893',
        categoria: 'Alimentos',
        estoque: 24,
        estoqueMinimo: 40,
        preco: 5.80,
        validade: '2025-11-15',
        fornecedor: 'Laticínios Silva',
      ),
      Product(
        id: '5',
        nome: 'Água Sanitária 1L',
        codigo: '7891234567894',
        categoria: 'Limpeza',
        estoque: 56,
        estoqueMinimo: 25,
        preco: 4.50,
        fornecedor: 'Química Total',
      ),
    ];
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.nome.toLowerCase().contains(searchTerm.toLowerCase()) ||
          product.codigo.contains(searchTerm);
      final matchesCategory = selectedCategory == 'Todas' || product.categoria == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Product> get lowStockProducts => products.where((p) => p.isLowStock).toList();
  List<Product> get expiringProducts => products.where((p) => p.isExpiring).toList();

  void _addProduct(Product product) {
    setState(() {
      products.add(product.copyWith(id: (products.length + 1).toString()));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto adicionado com sucesso!')),
    );
  }

  void _deleteProduct(String id) {
    setState(() {
      products.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto removido com sucesso!')),
    );
  }

  void _adjustStock(String id, int amount) {
    setState(() {
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index].estoque = (products[index].estoque + amount).clamp(0, 999999);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(amount > 0 ? 'Entrada registrada!' : 'Saída registrada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lowStockCount = lowStockProducts.length;
    final expiringCount = expiringProducts.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Estoque'),
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
                      Icon(Icons.inventory_2, color: Colors.blue),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gestão de Estoque', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Controle de produtos e inventário', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Alertas
                  if (lowStockCount > 0 || expiringCount > 0)
                    Column(
                      children: [
                        if (lowStockCount > 0)
                          _AlertCard(
                            icon: Icons.warning_amber_rounded,
                            color: Colors.red,
                            text: '$lowStockCount produtos abaixo do estoque mínimo',
                          ),
                        if (expiringCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _AlertCard(
                              icon: Icons.warning_amber_rounded,
                              color: Colors.orange,
                              text: '$expiringCount produtos vencendo em até 15 dias',
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  // Search e Filter
                  TextField(
                    onChanged: (value) => setState(() => searchTerm = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome ou código...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) => setState(() => selectedCategory = value ?? 'Todas'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão adicionar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddProductDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Produto'),
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
                      Tab(text: 'Todos (${products.length})'),
                      Tab(text: 'Baixo ($lowStockCount)'),
                      Tab(text: 'Vencendo ($expiringCount)'),
                    ],
                  ),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      children: [
                        _buildProductsList(filteredProducts),
                        _buildProductsList(lowStockProducts),
                        _buildProductsList(expiringProducts),
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

  Widget _buildProductsList(List<Product> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Nenhum produto encontrado', style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildProductCard(items[index], currentTabIndex),
    );
  }

  Widget _buildProductCard(Product product, int tabIndex) {
    final isLowStock = product.isLowStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: tabIndex == 1 && isLowStock
              ? Colors.red[200]!
              : tabIndex == 2 && product.isExpiring
                  ? Colors.orange[200]!
                  : Colors.grey[200]!,
          width: 1,
        ),
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
                      Text(product.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Código: ${product.codigo}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(product.categoria, style: const TextStyle(fontSize: 12)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          if (isLowStock)
                            Chip(
                              label: const Text('Baixo', style: TextStyle(fontSize: 12, color: Colors.white)),
                              backgroundColor: Colors.red,
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
                    Text('R\$ ${product.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
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
                    const Text('Estoque:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${product.estoque} / ${product.estoqueMinimo} un', style: TextStyle(fontSize: 14, color: isLowStock ? Colors.red : Colors.grey[900], fontWeight: FontWeight.bold)),
                  ],
                ),
                if (product.validade != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Validade:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        _formatDate(product.validade!),
                        style: TextStyle(fontSize: 14, color: product.isExpiring ? Colors.orange : Colors.grey[900], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _adjustStock(product.id, -1),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text('- Saída', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _adjustStock(product.id, 1),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('+ Entrada'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteProduct(product.id),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  void _showAddProductDialog() {
    final nomeController = TextEditingController();
    final codigoController = TextEditingController();
    final estoqueController = TextEditingController();
    final estoqueMinController = TextEditingController();
    final precoController = TextEditingController();
    final validadeController = TextEditingController();
    final fornecedorController = TextEditingController();
    String selectedCat = 'Alimentos';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Produto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Produto')),
              const SizedBox(height: 8),
              TextField(controller: codigoController, decoration: const InputDecoration(labelText: 'Código de Barras')),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: selectedCat,
                items: const [
                  DropdownMenuItem(value: 'Alimentos', child: Text('Alimentos')),
                  DropdownMenuItem(value: 'Bebidas', child: Text('Bebidas')),
                  DropdownMenuItem(value: 'Limpeza', child: Text('Limpeza')),
                  DropdownMenuItem(value: 'Higiene', child: Text('Higiene')),
                ],
                onChanged: (value) => selectedCat = value ?? 'Alimentos',
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 8),
              TextField(controller: fornecedorController, decoration: const InputDecoration(labelText: 'Fornecedor')),
              const SizedBox(height: 8),
              TextField(controller: estoqueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade Inicial')),
              const SizedBox(height: 8),
              TextField(controller: estoqueMinController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Estoque Mínimo')),
              const SizedBox(height: 8),
              TextField(controller: precoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Preço (R\$)')),
              const SizedBox(height: 8),
              TextField(controller: validadeController, decoration: const InputDecoration(labelText: 'Validade (YYYY-MM-DD)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nomeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome do produto é obrigatório')));
                return;
              }
              _addProduct(
                Product(
                  id: '',
                  nome: nomeController.text,
                  codigo: codigoController.text,
                  categoria: selectedCat,
                  estoque: int.tryParse(estoqueController.text) ?? 0,
                  estoqueMinimo: int.tryParse(estoqueMinController.text) ?? 0,
                  preco: double.tryParse(precoController.text) ?? 0,
                  validade: validadeController.text.isNotEmpty ? validadeController.text : null,
                  fornecedor: fornecedorController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _AlertCard({Key? key, required this.icon, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: color))),
          ],
        ),
      ),
    );
  }
}
