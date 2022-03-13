import "dart:async";
import 'package:flutter/material.dart';
import "package:get_it/get_it.dart";
import '/data/export.dart';
import "/constants/export.dart";

class BaseManager extends ChangeNotifier {
  AppError error = AppError();
  PageType? page;

  bool get hasError => error.msg == null ? false : true;

  void refresh() => notifyListeners();

  void goToPage({PageType? page}) {
    this.page = page;
    notifyListeners();
  }
}

class UserManager extends BaseManager {
  bool isLoading = false;

  UserManager() {
    page = PageType.splash;
  }

  void initializeApp() {
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
    notifyListeners();
  }

  void clearState() {
    isLoading = false;
    error = AppError();
  }
}
