import "package:flutter/material.dart";
import '../data/export.dart';
import "link.dart";
import "/pages/export.dart";
import "/constants/export.dart";

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final UserManager userManager;
  final VideoManager videoManager;
  final StreamManager streamManager;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouter(
      {required this.userManager,
      required this.videoManager,
      required this.streamManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    userManager.addListener(notifyListeners);
    videoManager.addListener(notifyListeners);
    streamManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    userManager.removeListener(notifyListeners);
    videoManager.removeListener(notifyListeners);
    streamManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (userManager.page == PageType.splash) ...[
          SplashScreen.page(),
        ] else if (userManager.page == PageType.login) ...[
          LoginPage.page(),
        ] else if (userManager.page == PageType.video) ...[
          VideoPage.videoPage(),
          if (videoManager.page == PageType.search) SearchPage.videoSearch()
        ] else if (userManager.page == PageType.stream) ...[
          VideoPage.streamPage(),
          if (streamManager.page == PageType.search) SearchPage.streamSearch()
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => {};

  @override
  AppLink get currentConfiguration => getCurrentPath();
  AppLink getCurrentPath() {
    return AppLink();
  }
}
