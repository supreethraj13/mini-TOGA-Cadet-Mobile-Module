import '../../../core/network/api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> loginAsCadet() async {
    final response = await _apiClient.postMap(
      '/auth/login',
      auth: false,
      body: {'username': 'arjun.menon', 'password': 'mock-password'},
    );
    return {
      'success': true,
      'data': {
        'token': response['access_token'],
        'profile': response['profile'],
      },
    };
  }
}
