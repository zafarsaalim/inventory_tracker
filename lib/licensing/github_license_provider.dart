import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubLicenseProvider {
  static const url = 'https://raw.githubusercontent.com/zafarsaalim/app-licenses/b1614cf9af8a9c0beb617db32f913951931916dc/inventory_tracker.json';

  Future<Map<String, dynamic>> fetchLicenses() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load licenses');
    }

    return jsonDecode(response.body);
  }
}
