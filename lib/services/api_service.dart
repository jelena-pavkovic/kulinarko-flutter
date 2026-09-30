import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //static const String baseUrl = 'http://10.0.2.2:8000/api';
  //static const String baseUrl = 'http://192.168.1.100:8000/api';
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('GET $endpoint — greška ${response.statusCode}');
    }
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('POST $endpoint — greška ${response.statusCode}');
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('PUT $endpoint — greška ${response.statusCode}');
    }
  }

  static Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('DELETE $endpoint — greška ${response.statusCode}');
    }
  }
}
