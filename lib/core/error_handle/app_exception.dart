class ApiException implements Exception {
  ApiException({this.code, this.message});

  final String? code;
  final String? message;

  ApiException copyWith({
    String? code,
    String? message,
  }) {
    return ApiException(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}
