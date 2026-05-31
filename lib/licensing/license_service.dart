import 'package:shared_preferences/shared_preferences.dart';

import 'github_license_provider.dart';
import 'license_model.dart';

class LicenseService {
  static const keyStorage = 'license_key';
  static const expiryStorage = 'license_expiry';

  Future<void> saveLicense(String key, String expiry) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(keyStorage, key);
    await prefs.setString(expiryStorage, expiry);
  }

  Future<String?> getKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyStorage);
  }

  Future<bool> hasValidLicense() async {
    final prefs = await SharedPreferences.getInstance();

    final expiry = prefs.getString(expiryStorage);

    if (expiry == null) {
      return false;
    }

    return DateTime.parse(expiry).isAfter(DateTime.now());
  }

  Future<bool> activate(String key) async {
    final data = await GithubLicenseProvider().fetchLicenses();

    final licenses = (data['licenses'] as List<dynamic>)
        .map((e) => LicenseModel.fromJson(e))
        .toList();

    try {
      final license = licenses.firstWhere(
        (e) => e.key.trim() == key.trim() && e.status == 'active',
      );

      if (DateTime.parse(license.expires).isBefore(DateTime.now())) {
        return false;
      }

      await saveLicense(license.key, license.expires);

      return true;
    } catch (_) {
      return false;
    }
  }
}
