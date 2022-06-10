import "dart:async";
import "package:get_it/get_it.dart";
import '/data/export.dart';
import "/constants/export.dart";
import "bases.dart";

class UserManager extends BaseManager {
  late AuthRepository repository;

  UserManager() {
    page = PageType.splash;
  }

  @override
  void initialize() async {
    repository = GetIt.I.get<AuthRepository>();
    page = PageType.login;
    if (await repository.checkAuth()) page = PageType.video;
    refresh();
  }

  void login({required String username, required String password}) async {
    isLoading = true;
    refresh();

    bool isAuthorized =
        await repository.authorize(username: username, password: password);

    if (isAuthorized) {
      page = PageType.video;
      return refresh();
    }

    clearState();
    error = AppError(msg: repository.response.text);
    return refresh();
  }

  void register() {}

  void logout() {
    page = PageType.login;
    refresh();
  }

  void clearState() {
    isLoading = false;
    error = AppError();
  }
}
