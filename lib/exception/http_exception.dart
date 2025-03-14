class HttpExceptionn implements Exception {
  final String msg;
  final int statusCode;

  HttpExceptionn({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
