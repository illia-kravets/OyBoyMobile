import "package:flutter/material.dart";

import "/constants/export.dart";

class PageNavigationItem {
  PageNavigationItem({
    required this.icon,
    required this.selected,
    required this.onPress,
    this.title,
  });

  final String? title;
  final IconData icon;
  final bool selected;
  final Function() onPress;
}

class FABBottomBar extends StatelessWidget {
  FABBottomBar({
    Key? key,
    required this.floatingButtonLocation,
    required this.actions,
    this.theme,
    this.backgroundColor,
    this.iconSize = 30.0,
    this.fixedColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
  })  : assert(actions.length >= 2, "2 or more actions must be provided"),
        assert(selectedItemColor == null || fixedColor == null,
            "selectedItemColor or fixedColor must be provided"),
        super(key: key) {
    if (floatingButtonLocation == FloatingButtonLocation.center) {
      assert(actions.length % 2 == 0, "Actions count must be even");
    }
  }

  final FloatingButtonLocation floatingButtonLocation;
  final List<PageNavigationItem> actions;
  final BottomNavigationBarThemeData? theme;
  final double iconSize;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final Color? backgroundColor;
  final Color? fixedColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  Widget getBottomBarItem(
      PageNavigationItem item, BottomNavigationBarThemeData topTheme) {
    return FABBottomBarItem(
      icon: item.icon,
      title: item.title ?? "",
      iconSize: iconSize,
      onPress: item.onPress,
      showLabel: item.selected
          ? showSelectedLabels ??
              theme?.showSelectedLabels ??
              topTheme.showSelectedLabels
          : showUnselectedLabels ??
              theme?.showUnselectedLabels ??
              topTheme.showUnselectedLabels,
      itemColor: item.selected
          ? selectedItemColor ??
              fixedColor ??
              theme?.selectedItemColor ??
              topTheme.selectedItemColor
          : unselectedItemColor ??
              fixedColor ??
              theme?.unselectedItemColor ??
              topTheme.unselectedItemColor,
      iconTheme: item.selected
          ? selectedIconTheme ??
              theme?.selectedIconTheme ??
              topTheme.selectedIconTheme
          : unselectedIconTheme ??
              theme?.unselectedIconTheme ??
              topTheme.unselectedIconTheme,
      labelStyle: item.selected
          ? selectedLabelStyle ??
              theme?.selectedLabelStyle ??
              topTheme.selectedLabelStyle
          : unselectedLabelStyle ??
              theme?.unselectedLabelStyle ??
              topTheme.unselectedLabelStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarThemeData topTheme =
        Theme.of(context).bottomNavigationBarTheme;

    List<Widget> children = List.generate(
        actions.length, (index) => getBottomBarItem(actions[index], topTheme));

    Widget spaceBox = const Expanded(flex: 1, child: SizedBox());

    switch (floatingButtonLocation) {
      case FloatingButtonLocation.center:
        children.insert(children.length ~/ 2, spaceBox);
        break;
      case FloatingButtonLocation.left:
        children.insert(0, spaceBox);
        break;
      case FloatingButtonLocation.right:
        children.add(spaceBox);
        break;
    }

    return BottomAppBar(
      notchMargin: 10,
      color:
          backgroundColor ?? theme?.backgroundColor ?? topTheme.backgroundColor,
      shape: const CircularNotchedRectangle(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        height: 60,
        child: Row(children: children),
      ),
    );
  }
}

class FABBottomBarItem extends StatelessWidget {
  const FABBottomBarItem(
      {Key? key,
      required this.icon,
      required this.iconSize,
      required this.onPress,
      required this.title,
      this.showLabel,
      this.itemColor,
      this.iconTheme,
      this.labelStyle})
      : super(key: key);

  final IconData icon;
  final double iconSize;
  final Function() onPress;
  final String title;
  final bool? showLabel;
  final Color? itemColor;
  final IconThemeData? iconTheme;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onPress,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            icon,
            size: iconTheme?.size ?? iconSize,
            color: itemColor ?? iconTheme?.color,
          ),
          if (showLabel != null && showLabel != false && title.isNotEmpty)
            Text(
              title,
              style: labelStyle?.copyWith(color: itemColor) ??
                  TextStyle(color: itemColor),
            )
        ]),
      ),
    );
  }
}
