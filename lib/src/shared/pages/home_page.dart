import 'package:flutter/material.dart';
import '../../features/dashboard/views/dashboard_page.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Para usuários que não são estoquista, exibe o dashboard
    return DashboardPage(user: user);
  }
}
