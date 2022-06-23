import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/export.dart';

void showSnackbar(BuildContext context, String text, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: color,)
  );
}

void clearPages(BuildContext context) {
  context.read<VideoManager>().clearRoute();
  context.read<ProfileManager>().clearRoute();
  context.read<ShortManager>().clearRoute();
}

void handleError(BuildContext context, AppError error) {
  ScaffoldMessengerState messanger = ScaffoldMessenger.of(context);
  messanger.clearSnackBars();
  messanger.showSnackBar(SnackBar(
    content: Text(error.msg ?? ""),
    backgroundColor: Colors.red,
  ));
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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

class AbsorbLoading extends StatelessWidget {
  const AbsorbLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Center(
        child: WillPopScope(
          child: const Loader(width: 30, height: 30,),
          onWillPop: () async {
            return true;
          },
        ),
      ),
    );
  }
}