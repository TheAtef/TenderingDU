import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

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

  Future<bool> refreshToken() async {
    final refresh = storage.read('refresh_token');
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refresh": refresh}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        await storage.write('access_token', body['access']);
        return true;
      }
    } catch (e) {
      print(e);
    }

    await logout();
    Get.offAllNamed(Routes.LOGIN);
    return false;
  }

  Future<http.Response> _handleGet(Uri url) async {
    var response = await http.get(url, headers: _getHeaders());
    if (response.statusCode == 401) {
      if (await refreshToken()) {
        response = await http.get(url, headers: _getHeaders());
      }
    }
    return response;
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

  Future<Map<String, dynamic>> getTenderDetails(int id) async {
    final url = Uri.parse('$baseUrl/tenders/$id/');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tender details');
    }
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
      queryParams['category__name'] = category;
    }

    final url = Uri.parse(
      '$baseUrl/tenders/',
    ).replace(queryParameters: queryParams);
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load tenders: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getFields() async {
    final url = Uri.parse('$baseUrl/categories/');
    final response = await _handleGet(url);
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  Future<bool> toggleSaveTender(int tenderId, bool isSaved) async {
    final url = isSaved
        ? Uri.parse('$baseUrl/saved-tenders/')
        : Uri.parse('$baseUrl/saved-tenders/$tenderId/');

    var res = isSaved
        ? await http.post(
            url,
            headers: _getHeaders(),
            body: json.encode({'tender_id': tenderId}),
          )
        : await http.delete(url, headers: _getHeaders());

    if (res.statusCode == 401) {
      if (await refreshToken()) {
        return toggleSaveTender(tenderId, isSaved);
      }
    }
    return isSaved ? res.statusCode == 201 : res.statusCode == 204;
  }
}
