import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/managers/auth.dart';
import 'package:oyboy/widgets/login/loginButton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'linkText.dart';
import 'loginTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // late UserManager manager;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPassController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool aggried = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    _repeatPassController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.read<UserManager>();
    ThemeData theme = Theme.of(context);
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 110,
              child: Image.asset("assets/images/logo_title.png"),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginTextField(
                      hint: "username".tr(),
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || _usernameController.text.isEmpty)
                          return 'notEmptyField'.tr();
                        return null;
                      },
                      width: 300,
                    ),
                    const SizedBox(height: 16),
                    LoginTextField(
                      hint: "password".tr(),
                      isPassword: true,
                      controller: _passwordController,
                      width: 300,
                      validator: (value) {
                        if (value == null || _passwordController.text.isEmpty)
                          return 'notEmptyField'.tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    LoginTextField(
                      hint: "repeatPassword".tr(),
                      isPassword: true,
                      controller: _repeatPassController,
                      validator: (value) {
                        if (value != _passwordController.text)
                          return 'matchPassword'.tr();
                        return null;
                      },
                      width: 300,
                    ),
                    const SizedBox(height: 16),
                    LoginTextField(
                      hint: "name".tr(),
                      controller: _fullNameController,
                      width: 300,
                    ),
                    const SizedBox(height: 16),
                    LoginTextField(
                      hint: "description".tr(),
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 7,
                      maxLines: 7,
                      width: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 34),
                      child: Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey,
                            ),
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: theme.primaryColor,
                              value: aggried,
                              onChanged: (value) {
                                setState(() {
                                  aggried = !aggried;
                                });
                              },
                            ),
                          ),
                          LinkText(
                            text: "iRadTerms".tr(),
                            linkText: "terms".tr(),
                            onTap: () async {
                              const url =
                                  'https://docs.google.com/document/d/1RxzXCdEe0cvALewBqdmI4F3hA-PtxvvVoapu1ESlVwo/edit?usp=sharing';
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    LoginButton(
                        width: 200,
                        title: "register".tr(),
                        onPressed: () {
                          if (!aggried) return;
                          if (_formKey.currentState!.validate()) {
                            manager.register();
                            manager.goToPage(page: PageType.login);
                          }
                        },
                        disabled: !aggried),
                    const SizedBox(height: 10),
                    LinkText(
                      text: "haveAccount".tr(),
                      linkText: "login".tr(),
                      onTap: () => manager.goToPage(page: PageType.login),
                    ),
                    const SizedBox(height: 16),
                  ]),
            )
          ],
        ),
      ),
    ));
  }
}
