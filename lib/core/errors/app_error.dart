class AppError implements Exception {
  AppError(this.message, {this.code = 'app_error'});

  final String message;
  final String code;

  @override
  String toString() => message;
}
