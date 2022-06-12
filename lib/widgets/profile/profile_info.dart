import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/data/export.dart';
import 'package:provider/provider.dart';

import '../../constants/export.dart';
import 'profile_avatar.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileManager manager = context.read<ProfileManager>();
    Profile profile = context.select((ProfileManager m) => m.profile);
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ProfileAvatar(
                  url: profile.avatar,
                  width: 120,
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: (profile.username != null &&
                        profile.username!.isNotEmpty),
                    child: Column(
                      children: [
                        Text(profile.username ?? "",
                            style: theme.textTheme.headline4),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )),
                Visibility(
                  visible: (profile.fullName != null &&
                      profile.fullName!.isNotEmpty),
                  child: Column(
                    children: [
                      Text(profile.fullName ?? "",
                          style: theme.textTheme.headline4),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                if (profile.description != null &&
                    profile.description!.isNotEmpty) ...[
                  Tooltip(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(15),
                    message: profile.description,
                    triggerMode: TooltipTriggerMode.tap,
                    child: Text(profile.description ?? "",
                        style: theme.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 4),
                        child: Column(children: [
                          Text(
                            profile.subscriptions.toString(),
                            style: theme.textTheme.bodyText1,
                          ),
                          Text("subscriptions".tr(),
                              style: theme.textTheme.headline6),
                        ]),
                      ),
                      const VerticalDivider(width: 1, color: Colors.grey),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 4),
                        child: Column(children: [
                          Text(
                            profile.subscribers.toString(),
                            style: theme.textTheme.bodyText1,
                          ),
                          Text("subscribers".tr(),
                              style: theme.textTheme.headline6),
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: -5,
              child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: theme.primaryColor,
                  ),
                  onPressed: () => manager.goToPage(page: PageType.settings)))
        ],
      ),
    );
  }
}
