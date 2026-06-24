import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/modules/submit_bid/submit_bid_model.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final String baseUrl = kIsWeb
      ? "http://127.0.0.1:8000"
      : "http://10.0.2.2:8000";

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
      await storage.write('access_token', body['access']);
      await storage.write('refresh_token', body['refresh']);
      await storage.write('user_id', body['user_id']);

      return {
        "success": true,
        "is_verified": body['is_verified'],
        "data": body,
      };
    }
    return {"success": false, "message": body['detail'] ?? "Login failed"};
  }

  Future<Map<String, dynamic>> sendOtp({required String email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {"success": true, "data": body['message']};
    }
    return {"success": false, "message": body['error'] ?? "Service failed"};
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "code": otp}),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {"success": true, "data": body['message']};
    }
    return {
      "success": false,
      "message": body['error'] ?? "Verification failed",
    };
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/change-password/');

    var response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        "old_password": oldPassword,
        "new_password": newPassword,
      }),
    );

    if (response.statusCode == 401) {
      if (await refreshToken()) {
        response = await http.post(
          url,
          headers: _getHeaders(),
          body: jsonEncode({
            "old_password": oldPassword,
            "new_password": newPassword,
          }),
        );
      }
    }

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "message": body['message'] ?? "Password updated successfully",
      };
    } else {
      return {
        "success": false,
        "message": body['error'] ?? "Failed to change password",
      };
    }
  }

  Future<bool> checkUserApproval() async {
    final userId = storage.read('user_id');
    if (userId == null) return false;

    final url = Uri.parse('$baseUrl/users/$userId/');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['is_verified'] ?? false;
    }
    return false;
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
    String? companyName,
    String? categoryName,
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
        "company_name": companyName,
        "category_name": categoryName,
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
    if (category != null && category != "All" && category.trim().isNotEmpty) {
      queryParams['category__name'] = category;
    }

    final url = Uri.parse(
      '$baseUrl/tenders/',
    ).replace(queryParameters: queryParams);
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      }

      return data as List<dynamic>;
    } else {
      print("API Error: ${response.statusCode} ${response.body}");
      return [];
    }
  }

  Future<bool> acceptBid(int bidId) async {
    final url = Uri.parse('$baseUrl/bids/$bidId/accept/');
    final response = await http.post(url, headers: _getHeaders());
    if (response.statusCode == 401) {
      if (await refreshToken()) {
        return acceptBid(bidId);
      }
    }
    return response.statusCode == 200;
  }

  Future<bool> rejectBid(int bidId) async {
    final url = Uri.parse('$baseUrl/bids/$bidId/reject/');
    final response = await http.post(url, headers: _getHeaders());
    if (response.statusCode == 401) {
      if (await refreshToken()) {
        return rejectBid(bidId);
      }
    }
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getTenderResults() async {
    final url = Uri.parse('$baseUrl/tenders/?results=true');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      }
      return data as List<dynamic>;
    } else {
      print(
        "API Error fetching tender results: ${response.statusCode} ${response.body}",
      );
      return [];
    }
  }

  Future<List<dynamic>> getMyBids() async {
    final url = Uri.parse('$baseUrl/bids/');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      }
      return data as List<dynamic>;
    } else {
      print(
        "API Error fetching my bids: ${response.statusCode} ${response.body}",
      );
      return [];
    }
  }

  Future<List<dynamic>> getReceivedBids() async {
    final url = Uri.parse('$baseUrl/bids/?received=true');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      }
      return data as List<dynamic>;
    } else {
      print("API Error: ${response.statusCode} ${response.body}");
      return [];
    }
  }

  Future<dynamic> getFields() async {
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
            body: json.encode({'tender': tenderId}),
          )
        : await http.delete(url, headers: _getHeaders());
    if (res.statusCode == 400) {
      print("VALIDATION ERROR FROM DJANGO: ${res.body}");
    }
    if (res.statusCode == 401) {
      if (await refreshToken()) {
        return toggleSaveTender(tenderId, isSaved);
      }
    }
    return isSaved ? res.statusCode == 201 : res.statusCode == 204;
  }

  Future<bool> uploadTenderAttachment({
    required int tenderId,
    File? mobileFile,
    Uint8List? webFileBytes,
    required String fileName,
  }) async {
    final url = Uri.parse('$baseUrl/tender-attachments/');
    final request = http.MultipartRequest('POST', url);

    final token = storage.read('access_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['tender'] = tenderId.toString();
    request.fields['description'] = 'Supporting document';

    int size = 0;
    if (kIsWeb && webFileBytes != null) {
      size = webFileBytes.length;
    } else if (mobileFile != null) {
      size = await mobileFile.length();
    }
    request.fields['size'] = size.toString();

    request.fields['content_type'] = fileName.toLowerCase().endsWith('.pdf')
        ? 'application/pdf'
        : 'application/msword';

    if (kIsWeb && webFileBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('file', webFileBytes, filename: fileName),
      );
    } else if (mobileFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', mobileFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 201;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final userId = storage.read('user_id');
    final token = storage.read('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print("API Error: ${response.statusCode} ${response.body}");
      return {};
    }
  }

  Future<Map<String, dynamic>> createTender({
    required String title,
    required String description,
    required double budgetMin,
    required double budgetMax,
    required String startDate,
    required String deadline,
    required String completionDeadline,
    required int categoryId,
    required int currencyId,
    required int locationId,
    required int statusId,
  }) async {
    final url = Uri.parse('$baseUrl/tenders/');

    final payload = {
      "title": title,
      "description": description,
      "budget_min": budgetMin.toStringAsFixed(2),
      "budget_max": budgetMax.toStringAsFixed(2),
      "start_date": startDate,
      "deadline": deadline,
      "completion_deadline": completionDeadline,
      "category": categoryId,
      "currency": currencyId,
      "location": locationId,
      "status": statusId,
    };

    var response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(payload),
    );

    if (response.statusCode == 401) {
      if (await refreshToken()) {
        response = await http.post(
          url,
          headers: _getHeaders(),
          body: jsonEncode(payload),
        );
      }
    }

    final body = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {"success": true, "data": body};
    } else {
      return {"success": false, "message": body.toString()};
    }
  }

  Future<Map<String, dynamic>> submitBid(SubmitBidModel bidModel) async {
    final url = Uri.parse('$baseUrl/bids/');

    var response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(bidModel.toJson()),
    );

    if (response.statusCode == 401) {
      if (await refreshToken()) {
        response = await http.post(
          url,
          headers: _getHeaders(),
          body: jsonEncode(bidModel.toJson()),
        );
      }
    }

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {"success": true, "data": body};
    }
    return {"success": false, "message": body.toString()};
  }

  Future<bool> uploadBidDocument({
    required int bidId,
    File? mobileFile,
    Uint8List? webFileBytes,
    required String fileName,
  }) async {
    final url = Uri.parse('$baseUrl/bid-documents/');
    final request = http.MultipartRequest('POST', url);

    final token = storage.read('access_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['bid'] = bidId.toString();
    request.fields['description'] = 'Proposal document';

    int size = 0;
    if (kIsWeb && webFileBytes != null) {
      size = webFileBytes.length;
    } else if (mobileFile != null) {
      size = await mobileFile.length();
    }
    request.fields['size'] = size.toString();

    request.fields['content_type'] = fileName.toLowerCase().endsWith('.pdf')
        ? 'application/pdf'
        : 'application/msword';

    if (kIsWeb && webFileBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('file', webFileBytes, filename: fileName),
      );
    } else if (mobileFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', mobileFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 201;
  }

  Future<bool> checkPassword(String password) async {
    final url = Uri.parse('$baseUrl/check-password/');

    var response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({"password": password}),
    );

    if (response.statusCode == 401) {
      if (await refreshToken()) {
        response = await http.post(
          url,
          headers: _getHeaders(),
          body: jsonEncode({"password": password}),
        );
      }
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['valid'] ?? false;
    }
    return false;
  }

  Future<bool> editProfile({
    required String email,
    required String phone,
    required String gender,
    required String birthDate,
    required String firstName,
    required String lastName,
  }) async {
    final userId = storage.read('user_id');
    final token = storage.read('access_token');

    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "phone": phone,
        "gender": gender.toLowerCase(),
        "birth_date": birthDate,
        "first_name": firstName,
        "last_name": lastName,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("API Error: ${response.statusCode} ${response.body}");
      return false;
    }
  }

  Future<List<dynamic>> getNotifications() async {
    final url = Uri.parse('$baseUrl/notifications/');
    final response = await _handleGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data as List<dynamic>;
    } else {
      print("API Error: ${response.statusCode} ${response.body}");
      return [];
    }
  }
}
