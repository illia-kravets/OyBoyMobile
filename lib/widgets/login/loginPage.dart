import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/constants/appstate.dart';
import 'package:oyboy/data/managers/auth.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:provider/provider.dart';

import 'linkText.dart';
import 'loginButton.dart';
import 'loginTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.read<UserManager>();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 110,
              child: Image.asset("assets/images/logo_title.png"),
            ),
            const SizedBox(height: 16),
            LoginTextField(
                hint: "username".tr(), controller: _usernameController),
            const SizedBox(height: 16),
            LoginTextField(
                hint: "password".tr(),
                isPassword: true,
                controller: _passwordController),
            const SizedBox(height: 16),
            LoginButton(
              title: "login".tr(),
              onPressed: () async {
                bool authorized = await manager.login(
                    username: _usernameController.text,
                    password: _passwordController.text);
                if (authorized) return manager.goToPage(page: PageType.video);
                showSnackbar(context, "authorizeError".tr(), color: Colors.red);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            LinkText(
              text: "isRegistered".tr(),
              linkText: "registration".tr(),
              onTap: () => manager.goToPage(page: PageType.register),
            )
          ],
        ),
      ),
    ));
  }
}
