import "dart:async";
import "package:get_it/get_it.dart";
import '/data/export.dart';
import "/constants/export.dart";
import "bases.dart";

class UserManager extends BaseManager {
  bool isLoading = false;

  UserManager() {
    page = PageType.splash;
  }

  void initialize() {
    Timer(
      const Duration(milliseconds: 500),
      () {
        page = PageType.login;
        refresh();
      },
    );
  }

  void login({required String username, required String password}) async {
    isLoading = true;
    refresh();

    Response data = await GetIt.I
        .get<AuthRepository>()
        .authorize(username: username, password: password);

    Timer(
      const Duration(milliseconds: 500),
      () {
        clearState();
        if (!data.success) {
          error = AppError(msg: data.text);
          return refresh();
        }
        page = PageType.video;
        refresh();
      },
    );
  }

  void logout() {
    page = PageType.login;
    refresh();
  }

  void clearState() {
    isLoading = false;
    error = AppError();
  }
}
