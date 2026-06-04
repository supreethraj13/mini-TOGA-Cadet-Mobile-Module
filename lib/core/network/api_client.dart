import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/local_storage.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ??
            const String.fromEnvironment(
              'TOGA_API_BASE_URL',
              defaultValue: 'http://127.0.0.1:8000',
            );

  final http.Client _client;
  final String baseUrl;

  Future<Map<String, dynamic>> getMap(String path, {bool auth = true}) async {
    final response = await _send('GET', path, auth: auth);
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  Future<List<Map<String, dynamic>>> getList(String path, {bool auth = true}) async {
    final response = await _send('GET', path, auth: auth);
    return (jsonDecode(response.body) as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<Map<String, dynamic>> postMap(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await _send('POST', path, body: body, auth: auth);
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  Future<Map<String, dynamic>> patchMap(String path, {bool auth = true}) async {
    final response = await _send('PATCH', path, auth: auth);
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = LocalStorage.box(LocalStorage.sessionBox).get('token') as String?;
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final request = switch (method) {
      'POST' => _client.post(uri, headers: headers, body: jsonEncode(body ?? {})),
      'PATCH' => _client.patch(uri, headers: headers),
      _ => _client.get(uri, headers: headers),
    };
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TimeoutException('API $method $path failed: ${response.statusCode}');
    }
    return response;
  }
}
