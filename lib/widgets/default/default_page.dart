import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import '../export.dart';
import "/data/export.dart";
import "/constants/export.dart";

class DefaultPage extends StatelessWidget {
  const DefaultPage(
      {Key? key,
      this.appBar,
      this.body,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.drawer,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.endDrawer})
      : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context) {
    UserManager userManager = context.read<UserManager>();
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton ??
          FloatingActionButton(
            onPressed: () => showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                context: context,
                builder: (context) => const CreateModal()),
            elevation: 0,
            child: Container(
              width: 60,
              height: 60,
              child: const Icon(
                Icons.add,
                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Theme.of(context).primaryColor, Colors.yellow])),
            ),
          ),
      floatingActionButtonLocation: floatingActionButtonLocation ??
          FloatingActionButtonLocation.centerDocked,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      bottomNavigationBar: FABBottomBar(
        floatingButtonLocation: FloatingButtonLocation.center,
        showSelectedLabels: true,
        // showUnselectedLabels: true,
        actions: [
          PageNavigationItem(
              icon: Icons.play_circle_outline,
              selected: userManager.page == PageType.video,
              title: 'Video',
              onPress: () => userManager.goToPage(page: PageType.video)),
          PageNavigationItem(
              icon: Icons.slow_motion_video,
              selected: userManager.page == PageType.short,
              title: "Shorts",
              onPress: () => userManager.goToPage(page: PageType.short)),
          PageNavigationItem(
              icon: Icons.live_tv,
              selected: userManager.page == PageType.stream,
              title: "Stream",
              onPress: () => userManager.goToPage(page: PageType.stream)),
          PageNavigationItem(
              icon: Icons.account_circle,
              selected: userManager.page == PageType.profile,
              title: "Profile",
              onPress: () => userManager.goToPage(page: PageType.profile))
        ],
      ),
    );
  }
}

class CreateModal extends StatelessWidget {
  const CreateModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Text(
              "Create",
              style: theme.textTheme.headline4,
            ),
            GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 30.0,
                ),
                onTap: () => Navigator.of(context).pop())
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      ModalRow(
        icon: Icons.play_circle_outline,
        text: "Upload video",
        onTap: () {
          context.read<VideoManager>().goToPage(page: PageType.create);
          Navigator.pop(context);
        },
      ),
      ModalRow(
        icon: Icons.slow_motion_video,
        text: "Upload short",
        onTap: () {
          context.read<ShortManager>().goToPage(page: PageType.create);
          Navigator.pop(context);
        },
      ),
      ModalRow(
        icon: Icons.live_tv,
        text: "Start live",
        onTap: () {
          context.read<StreamManager>().goToPage(page: PageType.create);
          Navigator.pop(context);
        },
      ),
      const SizedBox(
        height: 10,
      )
    ]);
  }
}

class ModalRow extends StatelessWidget {
  const ModalRow({Key? key, required this.icon, required this.text, this.onTap})
      : super(key: key);

  final IconData icon;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 155, 238)),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(text, style: theme.textTheme.bodyText1)))
        ]),
      ),
    );
  }
}
