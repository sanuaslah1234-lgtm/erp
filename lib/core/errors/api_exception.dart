class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, {this.statusCode = 400});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
