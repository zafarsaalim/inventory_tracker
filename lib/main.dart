import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/main_navigation.dart';
import 'licensing/license_gate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LicenseGate(child: MainNavigation()),
    );
  }
}
