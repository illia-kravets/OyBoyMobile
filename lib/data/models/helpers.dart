class Response {
  Response({required this.success, this.data, this.text});
  bool success;
  Map? data = {};
  String? text = "";
}

class Request {}

class AppError implements Exception {
  AppError({this.msg});
  String? msg;
}
