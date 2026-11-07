// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/payment_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //  Initialize Flutter engine bindings first
  WidgetsFlutterBinding.ensureInitialized();

  //  Explicitly load the file name
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Pesa Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PaymentScreen(),
    );
  }
}
