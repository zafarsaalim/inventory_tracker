import 'package:flutter/material.dart';

import 'license_screen.dart';
import 'license_service.dart';

class LicenseGate extends StatelessWidget {
  final Widget child;

  const LicenseGate({super.key, required this.child});

  Future<bool> _check() async {
    return LicenseService().hasValidLicense();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _check(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child;
        }

        return const LicenseScreen();
      },
    );
  }
}
