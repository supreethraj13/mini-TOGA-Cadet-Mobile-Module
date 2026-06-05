class ApiResponse<T> {
  const ApiResponse({required this.success, required this.data, this.message});

  final bool success;
  final T? data;
  final String? message;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? value) parser,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: json['data'] == null ? null : parser(json['data']),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) serializer) => {
    'success': success,
    'data': data == null ? null : serializer(data as T),
    'message': message,
  };
}
