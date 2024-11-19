import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.example.com';

  Future<http.Response> fetchData(String endpoint) {
    return http.get(Uri.parse('$baseUrl/$endpoint'));
  }
}
