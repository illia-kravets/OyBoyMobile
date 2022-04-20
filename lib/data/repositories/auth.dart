import '/data/export.dart';

class AuthRepository extends BaseRepository{
  Future<Response> authorize(
      {required String username, required String password}) async {
    await Future.delayed(Duration(seconds: 1));
    if (username != "illia" || password != "12345") {
      return Response(code: 401, text: "Invalid username or password");
    }
    return Response(code: 200);
  }
}
