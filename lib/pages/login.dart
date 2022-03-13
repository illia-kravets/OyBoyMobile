import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "/constants/export.dart";
import '/data/export.dart';
import '/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
        name: OyBoyPages.loginPath,
        key: ValueKey(OyBoyPages.loginPath),
        child: LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Image.asset("assets/gifs/logo.gif"),
            ),
            const SizedBox(height: 16),
            LoginTextField(hint: "Username", controller: _usernameController),
            const SizedBox(height: 16),
            LoginTextField(
                hint: "Password",
                isPassword: true,
                controller: _passwordController),
            const SizedBox(height: 16),
            LoginButton(
              onPressed: () => {
                context.read<UserManager>().login(
                    username: _usernameController.text,
                    password: _passwordController.text)
              },
            )
          ],
        ),
      ),
    ));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.onPressed}) : super(key: key);
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    UserManager userManager = context.watch<UserManager>();
    if (userManager.hasError) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        handleError(context, userManager.error);
      });
    }
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(color: Colors.black)),
          child: !userManager.isLoading
              ? Text(
                  "Login",
                  style: Theme.of(context).textTheme.button,
                )
              : const Loader(),
          onPressed: onPressed),
    );
  }
}

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.controller,
    this.hint = "",
    this.isPassword = false,
  }) : super(key: key);

  final bool isPassword;
  final String? hint;
  final TextEditingController controller;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: 250,
      child: TextFormField(
          controller: widget.controller,
          style: Theme.of(context).textTheme.bodyText1,
          cursorColor: primaryColor,
          obscureText: widget.isPassword ? _showPassword : false,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryColor)),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      !_showPassword ? Icons.lock_open : Icons.lock,
                      color: primaryColor,
                    ),
                    onPressed: () => {
                      setState((() => {_showPassword = !_showPassword}))
                    },
                  )
                : null,
          )),
    );
  }
}
