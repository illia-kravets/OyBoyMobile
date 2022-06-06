import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "/constants/pages.dart";
import "/data/export.dart";


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
      
        name: OyBoyPages.splashPath,
        key: ValueKey(OyBoyPages.splashPath),
        child: SplashScreen());
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    context.setLocale(const Locale('uk'));
    context.read<UserManager>().initialize();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/gifs/logo-big.gif"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    ));
  }
}
