import 'package:flutter/material.dart';
import '../../features/auth/views/login_page.dart';

class UserMenu extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserMenu({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'logout') {
          _handleLogout(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'perfil',
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Text(
                      user['name'].toString().substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user['role'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text('Sair', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue,
          child: Text(
            user['name'].toString().substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar Saída'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
