import 'package:flutter/material.dart';

import 'license_service.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final controller = TextEditingController();

  bool loading = false;
  String error = '';

  Future<void> activate() async {
    setState(() {
      loading = true;
      error = '';
    });

    final ok = await LicenseService().activate(controller.text.trim());

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        error = 'Invalid License';
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Inventory Tracker', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'License Key'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : activate,
                child: const Text('Activate'),
              ),
              const SizedBox(height: 10),
              Text(error),
            ],
          ),
        ),
      ),
    );
  }
}
