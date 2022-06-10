import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/login/loginPage.dart';
import '../widgets/login/registerPage.dart';
import "/constants/export.dart";
import '/data/export.dart';
import '/utils/utils.dart';

class AuthPage {
  static MaterialPage loginPage() {
    return const MaterialPage(
        name: OyBoyPages.loginPath,
        key: ValueKey(OyBoyPages.loginPath),
        child: LoginPage());
  }

  static MaterialPage registerPage() {
    return const MaterialPage(
        name: OyBoyPages.registerPath,
        key: ValueKey(OyBoyPages.registerPath),
        child: RegisterPage());
  }
}
