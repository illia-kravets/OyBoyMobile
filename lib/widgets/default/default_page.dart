import 'package:easy_localization/easy_localization.dart';
import 'package:oyboy/utils/utils.dart';
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
          FloatingActionButtonLocation.endDocked,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      bottomNavigationBar: FABBottomBar(
        floatingButtonLocation: FloatingButtonLocation.right,
        showSelectedLabels: true,
        // showUnselectedLabels: true,
        actions: [
          PageNavigationItem(
              icon: AppIcon.video.icon,
              selected: userManager.page == PageType.video,
              title: 'video'.tr(),
              onPress: () {
                clearPages(context); 
                userManager.goToPage(page: PageType.video);
              }),
          PageNavigationItem(
              icon: AppIcon.short.icon,
              selected: userManager.page == PageType.short,
              title: "short".tr(),
              onPress: () {
                clearPages(context); 
                userManager.goToPage(page: PageType.short);
              }),
          // PageNavigationItem(
          //     icon: AppIcon.stream.icon,
          //     selected: userManager.page == PageType.stream,
          //     title: "Stream",
          //     onPress: () => userManager.goToPage(page: PageType.stream)),
          PageNavigationItem(
              icon: AppIcon.profile.icon,
              selected: userManager.page == PageType.profile,
              title: "profile".tr(),
              onPress: () {
                clearPages(context);
                userManager.goToPage(page: PageType.profile);
              })
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
              "create".tr(),
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
        icon: AppIcon.video.icon,
        text: "addVideo".tr(),
        onTap: () {
          context.read<VideoManager>().goToPage(page: PageType.create);
          Navigator.pop(context);
        },
      ),
      ModalRow(
        icon: AppIcon.short.icon,
        text: "addShort".tr(),
        onTap: () {
          context.read<ShortManager>().goToPage(page: PageType.create);
          Navigator.pop(context);
        },
      ),
      // ModalRow(
      //   icon: AppIcon.stream.icon,
      //   text: "Start live",
      //   onTap: () {
      //     context.read<StreamManager>().goToPage(page: PageType.create);
      //     Navigator.pop(context);
      //   },
      // ),
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
