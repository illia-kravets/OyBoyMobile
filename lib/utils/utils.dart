import 'package:flutter/material.dart';
import '/data/export.dart';

void showSnackbar(BuildContext context, String text, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: color,)
  );
}

void handleError(BuildContext context, AppError error) {
  ScaffoldMessengerState messanger = ScaffoldMessenger.of(context);
  messanger.clearSnackBars();
  messanger.showSnackBar(SnackBar(
    content: Text(error.msg ?? ""),
    backgroundColor: Colors.red,
  ));
}

class Loader extends StatelessWidget {
  const Loader({Key? key, this.height = 20, this.width = 20, this.strokeWidth})
      : super(key: key);

  final double? height;
  final double? width;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: strokeWidth ?? 3,
          ),
          height: height,
          width: width,
        ),
      ),
    );
  }
}
