import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField(
      {Key? key,
      required this.controller,
      this.hint = "",
      this.isPassword = false,
      this.validator,
      this.keyboardType,
      this.maxLines = 1,
      this.width = 250,
      this.minLines})
      : super(key: key);

  final double width;
  final bool isPassword;
  final String? hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: widget.width,
      child: TextFormField(
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          validator: widget.validator,
          controller: widget.controller,
          style: Theme.of(context).textTheme.bodyText1,
          cursorColor: primaryColor,
          obscureText: widget.isPassword ? _showPassword : false,
          decoration: InputDecoration(
            hintText: widget.hint,
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
