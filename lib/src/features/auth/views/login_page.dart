import 'package:flutter/material.dart';
import '../../inventory/views/inventory_page.dart';
import '../../financial/views/financial_page.dart';
import '../../driver/views/driver_page.dart';
import '../../admin/views/admin_page.dart';
import '../../../shared/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleSubmit() {
    final email = emailController.text;
    final password = passwordController.text;

  final user = {'email': email, 'password': password};

      if (email.isNotEmpty) {
        print('Validado');
        _navigateBasedOnRole(user);
        return;
      }else{
        isValid();
      }
  }

  void isValid() {

       const Align(
          alignment: Alignment.centerLeft,
          child:const Text('informe seu e-mail', style: TextStyle(color: Color.fromARGB(255, 185, 1, 1), fontWeight: FontWeight.bold),
          ),
        );
  
  }

  void _navigateBasedOnRole(Map<String, dynamic> user) {
    Widget nextPage;

    if (user['role'] == 'estoque@gmail.com') {
      nextPage = InventoryPage(user: user);
    } else if (user['role'] == 'financeiro@gmail.com') {
      nextPage = FinancialPage(user: user);
    } else if (user['role'] == 'motorista@gmail.com') {
      nextPage = DriverPage(user: user);
    } else if (user['role'] == 'adm@gmail.com') {
      nextPage = AdminPage(user: user);
    } else {
      print('Caiu nulo');
      nextPage = LoginPage();
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => nextPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 94, 146, 75),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 7, 175, 122),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Eskelbel',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gestão Inteligente',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Digite seu e-mail', 
                        hintStyle: TextStyle(color: Color.fromARGB(255, 135, 139, 138)), 
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(8)),
                         borderSide: BorderSide(color: Color.fromARGB(255, 12, 44, 34), width: 1.50),),
                        focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(8)),
                         borderSide: BorderSide(color: Color.fromARGB(255, 7, 175, 122), width: 2),
                         )
                      ),
                      keyboardType: TextInputType.emailAddress,

                    ),
                    if(emailController.text.isEmpty)
                       const Align(
                          alignment: Alignment.centerLeft,
                          child:const Text('informe seu e-mail', style: TextStyle(color: Color.fromARGB(255, 185, 1, 1), fontWeight: FontWeight.bold),
                        ),
                       ),

                    const SizedBox(height: 16),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua senha',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 135, 139, 138)),
                        prefixIcon: Icon(Icons.lock),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)), 
                          borderSide: BorderSide(color: Color.fromARGB(255, 12, 44, 34), width: 1.50),
                        ),
                      focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(8)),
                         borderSide: BorderSide(color: Color.fromARGB(255, 7, 175, 122), width: 2),)
                      ),
                      obscureText: true,
                    ),
                    const Text('informe sua senha'),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 7, 175, 122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: handleSubmit,
                        child: const Text('Entrar', style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
