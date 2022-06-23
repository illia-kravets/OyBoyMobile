import '/data/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository extends BaseRepository {
  String? token;
  late Profile profile;

  Future<bool> fetchProfile() async {
    await get(url: "initial", headers: {"Authorization": "Bearer $token"});
    if (response.code != 200) return false;
    profile = Profile.fromJson(response.data);
    return true;
  }

  Future<bool> authorize(
      {required String username, required String password}) async {
    if (username.isEmpty || password.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    await post(
        url: "token/", body: {"username": username, "password": password});
    if (response.code != 200) return false;
    token = response.data["access"];
    
    await prefs.setString("accessToken", token ?? "");
    await prefs.setString("refreshToken", response.data["refresh"]);
    await prefs.setString("username", username);
    await prefs.setString("password", password);

    return await fetchProfile();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? rToken = prefs.getString("refreshToken") ?? "";

    if (rToken.isEmpty) return false;
    await post(url: "token/refresh/", body: {"refresh": rToken});
    if (response.code != 200) return false;

    token = response.data["access"];
    await prefs.setString("accessToken", token ?? "");
    await prefs.setString("refreshToken", response.data["refresh"]);
    return await fetchProfile();
  }

  Future<bool> verifyToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("accessToken") ?? "";

    if (token!.isEmpty) return false;
    await post(url: "token/verify/", body: {"token": token});
    return response.code == 200 && await fetchProfile();
  }

  Future checkAuth() async {
    final prefs = await SharedPreferences.getInstance();

    request.flush();
    if (await verifyToken()) return true;

    request.flush();
    if (await refreshToken()) return true;

    request.flush();
    String? username = prefs.getString("username") ?? "";
    String? pass = prefs.getString("password") ?? "";
    return await authorize(username: username, password: pass);
  }

  Map get authHeaders => {"Authorization": "JWT $token"};
}
