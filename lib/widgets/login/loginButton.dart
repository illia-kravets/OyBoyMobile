import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.width = 100,
      this.disabled = false})
      : super(key: key);
  final Function() onPressed;
  final String title;
  final double width;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    UserManager userManager = context.watch<UserManager>();
    if (userManager.hasError) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        handleError(context, userManager.error);
      });
    }
    return SizedBox(
      width: width,
      height: 40,
      child: ElevatedButton(
          style: disabled
              ? ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )
              : null,
          child: !userManager.isLoading
              ? Text(title,
                  style: disabled
                      ? GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)
                      : Theme.of(context).textTheme.button)
              : const Loader(),
          onPressed: onPressed),
    );
  }
}
