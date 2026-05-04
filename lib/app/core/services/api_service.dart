import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000";
  final storage = GetStorage();

  Map<String, String> _getHeaders() {
    final token = storage.read('access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (body['access'] != null) {
        await storage.write('access_token', body['access']);
      }

      if (body['refresh'] != null) {
        await storage.write('refresh_token', body['refresh']);
      }

      return {"success": true, "data": body};
    }

    return {"success": false, "message": body.toString()};
  }

  Future<void> logout() async {
    await storage.remove('access_token');
    await storage.remove('refresh_token');
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String phone,
    required String gender,
    required String crNumber,
    required String birthDate,
    required String firstName,
    required String lastName,
    required String password,
    required String username,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-up/'),
      headers: _getHeaders(),
      body: jsonEncode({
        "email": email,
        "phone": phone,
        "gender": gender,
        "cr_number": crNumber,
        "birth_date": birthDate,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "username": username,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "data": body};
    }

    return {"success": false, "message": body.toString()};
  }

  Future<List<dynamic>> getTenders({String? query, String? category}) async {
    Map<String, String> queryParams = {};

    if (query != null && query.isNotEmpty) {
      queryParams['search'] = query;
    }

    if (category != null && category != "All" && category.isNotEmpty) {
      queryParams['fields__name'] = category;
    }

    final url = Uri.parse(
      '$baseUrl/tenders/',
    ).replace(queryParameters: queryParams);

    print("Requesting URL: $url");

    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load tenders: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getFields() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fields/'),
      headers: _getHeaders(),
    );
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  Future<bool> toggleSaveTender(int tenderId, bool isSaved) async {
    if (isSaved) {
      final res = await http.post(
        Uri.parse('$baseUrl/saved-tenders/'),
        headers: _getHeaders(),
        body: json.encode({'tender_id': tenderId}),
      );
      return res.statusCode == 201;
    } else {
      final res = await http.delete(
        Uri.parse('$baseUrl/saved-tenders/$tenderId/'),
        headers: _getHeaders(),
      );
      return res.statusCode == 204;
    }
  }
}
