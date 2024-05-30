import 'package:flutter/material.dart';
import 'Login.dart';

void main() {
  runApp(MyApp()); // Memanggil widget MyApp sebagai root widget
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Memperbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(), // Mengatur halaman awal sebagai Login
    );
  }
}
