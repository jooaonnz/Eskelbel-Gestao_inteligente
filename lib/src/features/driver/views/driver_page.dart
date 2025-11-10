import 'package:flutter/material.dart';
import '../../../shared/widgets/user_menu.dart';
import 'driver_dashboard_view.dart';
import 'driver_deliveries_view.dart';

class DriverPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const DriverPage({Key? key, required this.user}) : super(key: key);

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motorista'),
        backgroundColor: Colors.blue,
        actions: [
          UserMenu(user: widget.user),
        ],
      ),
      body: IndexedStack(
        index: currentTabIndex,
        children: [
          DriverDashboardView(user: widget.user),
          DriverDeliveriesView(user: widget.user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) => setState(() => currentTabIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Entregas',
          ),
        ],
      ),
    );
  }
}
