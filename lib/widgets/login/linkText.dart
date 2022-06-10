import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkText extends StatelessWidget {
  const LinkText(
      {Key? key, required this.linkText, this.text, required this.onTap})
      : super(key: key);

  final String linkText;
  final String? text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (text != null) Text(text ?? "", style: theme.textTheme.bodyText2),
        GestureDetector(
          onTap: onTap,
          child: Text(linkText,
              style: GoogleFonts.poppins(
                  color: theme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        )
      ],
    );
  }
}
