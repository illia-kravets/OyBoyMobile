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
  final ShortManager shortManager;
  final ProfileManager profileManager;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouter(
      {required this.userManager,
      required this.videoManager,
      required this.streamManager,
      required this.shortManager,
      required this.profileManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    userManager.addListener(notifyListeners);
    videoManager.addListener(notifyListeners);
    streamManager.addListener(notifyListeners);
    shortManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    userManager.removeListener(notifyListeners);
    videoManager.removeListener(notifyListeners);
    streamManager.removeListener(notifyListeners);
    shortManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (userManager.page == PageType.splash) ...[SplashScreen.page()],
        if (userManager.page == PageType.login) ...[LoginPage.page()],
        if (userManager.page == PageType.video) ...[
          VideoPage.videoPage(),
          if (videoManager.page == PageType.search) SearchPage.videoSearch(),
        ], 
        if (userManager.page == PageType.stream) ...[
          VideoPage.streamPage(),
          if (streamManager.page == PageType.search) SearchPage.streamSearch(),
        ],
        if (userManager.page == PageType.profile) ...[
          ProfilePageSelector.profile(),
          if (profileManager.page == PageType.settings) ProfilePageSelector.profileSettings()
        ],
        if (videoManager.page == PageType.create) CreatePage.videoCreate(),
        if (streamManager.page == PageType.create) CreatePage.streamCreate(),
        if (shortManager.page == PageType.create) CreatePage.shortCreate(),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == OyBoyPages.videoSearchPath) videoManager.goToPage();
    if (route.settings.name == OyBoyPages.streamSearchPath) streamManager.goToPage();
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
