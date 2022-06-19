import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:oyboy/widgets/profile/data_page.dart';
import 'package:oyboy/widgets/profile/profile_page.dart';
import 'package:oyboy/widgets/profile/profile_settings.dart';
import "/constants/export.dart";
import "/widgets/export.dart";
import "/utils/utils.dart";
import "/data/export.dart";
import "package:provider/provider.dart";

class ProfilePageSelector {
  static MaterialPage profile() {
    return const MaterialPage(
        name: OyBoyPages.profilePath,
        key: ValueKey(OyBoyPages.profilePath),
        arguments: {"test", "new"},
        child: ProfilePage(fromMainPage: true,));
  }

  static MaterialPage profileSettings() {
    return const MaterialPage(
        name: OyBoyPages.profileSettingsPath,
        key: ValueKey(OyBoyPages.profileSettingsPath),
        child: ProfileSettingsPage());
  }

  static MaterialPage detailList<T extends FilterCRUDManager>(
      {required VideoType videoType}) {
    return MaterialPage(
        name: OyBoyPages.profileDetailPath,
        key: const ValueKey(OyBoyPages.profileDetailPath),
        child: DataPage<T>(
          videoType: videoType,
          appBarTitle: "My ${videoType.value}",
        ));
  }
}
