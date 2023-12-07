class ResponseModel {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? body;

  ResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.body,
  });
}
