import '/data/export.dart';

class AuthRepository {
  Future<Response> authorize(
      {required String username, required String password}) async {
    if (username != "illia" || password != "12345") {
      return Response(success: false, text: "Invalid username or password");
    }
    return Response(success: true);
  }
}
