import '../../../core/network/api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> fetchMockProfiles() {
    return _apiClient.getList('/auth/mock-profiles', auth: false);
  }

  Future<Map<String, dynamic>> loginAsCadet({
    required String profileId,
    required String mode,
    required String username,
    required String password,
    Map<String, dynamic>? profileDetails,
  }) async {
    final response = await _apiClient.postMap(
      '/auth/login',
      auth: false,
      body: {
        'username': username,
        'password': password,
        'profile_id': profileId,
        'mode': mode,
        ...?profileDetails,
      },
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
