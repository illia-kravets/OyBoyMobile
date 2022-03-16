import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import "routing/export.dart";
import "data/export.dart";
import '/utils/get_it.dart';

void main() {
  startGet();
  registerModels();
  runApp(const MyApp());
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

  @override
  void initState() {

    _appRouter = AppRouter(
        userManager: _userManager,
        videoManager: _videoManager,
        streamManager: _steamManager);
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
        ChangeNotifierProvider<StreamManager>(create: (context) => _steamManager)
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: theme,
        routerDelegate: _appRouter,
        routeInformationParser: _parser,
      ),
    );
  }
}
