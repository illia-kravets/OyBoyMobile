import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'generated/codegen_loader.g.dart';
import 'theme.dart';
import "routing/export.dart";
import "data/export.dart";
import '/utils/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  startGet();
  registerModels();
  runApp(
    EasyLocalization(
      path: "assets/translations",
      supportedLocales: const [
        Locale("en"),
        Locale("uk"),
      ],
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter _appRouter;
  final RouteParser _parser = RouteParser();

  final UserManager _userManager = UserManager();
  final VideoManager _videoManager = VideoManager();
  final StreamManager _steamManager = StreamManager();
  final ShortManager _shortManager = ShortManager();
  final ProfileManager _profileManager = ProfileManager();

  @override
  void initState() {
    _appRouter = AppRouter(
        userManager: _userManager,
        videoManager: _videoManager,
        streamManager: _steamManager,
        shortManager: _shortManager,
        profileManager: _profileManager);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = OyBoyTheme.lightTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>(create: (context) => _userManager),
        ChangeNotifierProvider<VideoManager>(
          create: (context) => _videoManager,
        ),
        ChangeNotifierProvider<StreamManager>(create: (context) => _steamManager),
        ChangeNotifierProvider<ShortManager>(create: (context) => _shortManager),
        ChangeNotifierProvider<ProfileManager>(create: (context) => _profileManager),
      ],
      child: MaterialApp.router(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        title: 'Flutter Demo',
        theme: theme,
        routerDelegate: _appRouter,
        routeInformationParser: _parser,
        backButtonDispatcher: RootBackButtonDispatcher()
      ),
    );
  }
}
