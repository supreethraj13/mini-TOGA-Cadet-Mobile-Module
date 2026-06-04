import '../../../core/data/mock_data.dart';

class AuthService {
  Future<Map<String, dynamic>> loginAsCadet() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'data': {
        'token': 'mock.jwt.cadet-arjun-menon',
        'profile': mockProfileJson,
      },
    };
  }
}
