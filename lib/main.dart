import 'package:flutter/material.dart';
import 'src/features/auth/views/login_page.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Eskelbel',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: const LoginPage(),
			debugShowCheckedModeBanner: false,
		);
	}
}
