import '../../../core/errors/app_error.dart';
import '../../../core/storage/local_storage.dart';
import '../models/cadet_profile.dart';
import 'auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<({String token, CadetProfile profile})> login() async {
    final response = await _service.loginAsCadet();
    if (response['success'] != true) {
      throw AppError('Unable to authenticate mock cadet.', code: 'auth_failed');
    }
    final data = Map<String, dynamic>.from(response['data'] as Map);
    final token = data['token'] as String;
    final profile = CadetProfile.fromJson(
      Map<String, dynamic>.from(data['profile'] as Map),
    );
    final box = LocalStorage.box(LocalStorage.sessionBox);
    await box.put('token', token);
    await box.put('profile', profile.toJson());
    return (token: token, profile: profile);
  }

  Future<({String token, CadetProfile profile})?> restore() async {
    final box = LocalStorage.box(LocalStorage.sessionBox);
    final token = box.get('token') as String?;
    final rawProfile = box.get('profile');
    if (token == null || rawProfile == null) return null;
    return (
      token: token,
      profile: CadetProfile.fromJson(Map<String, dynamic>.from(rawProfile as Map)),
    );
  }

  Future<void> logout() async {
    await LocalStorage.box(LocalStorage.sessionBox).clear();
  }
}
