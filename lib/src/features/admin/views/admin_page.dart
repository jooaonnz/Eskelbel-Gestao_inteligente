import 'package:flutter/material.dart';
import '../../../shared/widgets/user_menu.dart';
import '../../dashboard/views/dashboard_page.dart';
import '../../inventory/views/inventory_page.dart';
import '../../financial/views/financial_page.dart';
import '../../driver/views/driver_page.dart';
import 'admin_reports_view.dart';

class AdminPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  final List<({String label, IconData icon})> tabs = [
    (label: 'Dashboard', icon: Icons.dashboard),
    (label: 'Estoque', icon: Icons.inventory),
    (label: 'Financeiro', icon: Icons.attach_money),
    (label: 'Entregas', icon: Icons.local_shipping),
    (label: 'Relatórios', icon: Icons.bar_chart),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        backgroundColor: Colors.blue,
        actions: [
          UserMenu(user: widget.user),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardPage(user: widget.user, showAppBar: false),
          InventoryPage(user: widget.user, showAppBar: false),
          FinancialPage(user: widget.user, showAppBar: false),
          DriverPage(user: widget.user, showAppBar: false, showNavigationBar: false,),
          AdminReportsView(user: widget.user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Estoque',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Financeiro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Entregas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}
