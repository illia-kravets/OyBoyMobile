import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_share/flutter_share.dart';
import 'package:oyboy/constants/defaults.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/my_icons.dart';
import 'package:provider/provider.dart';

class IconsBar extends StatelessWidget {
  const IconsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailVideoManager manager = context.read<DetailVideoManager>();
    Video video = context.select((DetailVideoManager m) => m.video);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconItem(context, CustomIcon.video_view,
              "${video.viewCount} ${'views'.tr()}"),
          iconItem(context, CustomIcon.video_heart,
              "${video.likeCount} ${'likes'.tr()}",
              onTap: () => manager.like(), selected: video.liked),
          iconItem(
            context,
            AppIcon.favourite.icon,
            video.favourite ? "inFavourite".tr() : "toFavourite".tr(),
            onTap: () => manager.favourite(),
            selected: video.favourite
          ),
          iconItem(
            context,
            CustomIcon.reply,
            "share".tr(),
            onTap: () async {
              await FlutterShare.share(
                  title: video.name ?? "",
                  text: video.name,
                  linkUrl: video.video,
                  chooserTitle: video.name);
            },
          ),
        ],
      ),
    );
  }

  Widget iconItem(BuildContext context, IconData icon, String text,
      {bool selected = false, Function()? onTap}) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: selected ? theme.primaryColor : Colors.grey),
          Text(text, style: theme.textTheme.subtitle1?.copyWith(color: selected ? theme.primaryColor : null),)
        ],
      ),
    );
  }
}
