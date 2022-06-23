import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import "/data/models/helpers.dart";
import "package:flutter/material.dart";

enum TagScope { local, external }

enum FloatingButtonLocation { left, center, right }

enum RequestDataType { headers, query, body }

enum ScrollableType { list, grid }

enum VideoScrollType { back, ahead }

enum ShortTapType { pause, like }


enum ReportType {channel, video}

extension RadioTitle on ReportType {
  String get title {
    switch(this) {
      case ReportType.channel:
        return 'reportProfile'.tr();
      case ReportType.video:
        return 'reportVideo'.tr();
    }
  }
}


enum VideoType { video, stream, short, favourite }

extension CreateValue on VideoType {
  String get value {
    switch (this) {
      case VideoType.video:
        return "video";
      case VideoType.short:
        return "short";
      case VideoType.stream:
        return "stream";
      case VideoType.favourite:
        return "favourite";
    }
  }
}

enum MediaType { video, image }

extension MediaPicker on MediaType {
  Function get picker {
    return this == MediaType.image
        ? ImagePicker().pickImage
        : ImagePicker().pickVideo;
  }

  String get name {
    return this == MediaType.image ? "image" : "video";
  }
}

const double CHIPBAR_HEIGHT = 50.0;

class TagMarker {
  static const String subscriptions = "subscripions";
  static const String recomendations = "recomendations";
}

class Pallette {
  static const Color grey = Colors.grey;
  // static const Color  = Colors.grey;
}

class FilterType {
  static const String ordering = "ordering";
  static const String relevation = "display";
  static const String tag = "tag";
}

class Filters {
  static List<FilterAction> get video {
    return [
      // Ordering filters
      FilterAction(
          type: FilterType.ordering,
          value: "",
          title: "defaultOrdering".tr(),
          head: true),
      FilterAction(
          type: FilterType.ordering,
          value: "duration",
          title: "durationOrdering".tr()),
      FilterAction(
          type: FilterType.ordering,
          value: "upload_date",
          title: "uploadOrdering".tr()),

      // Relevation filters
      FilterAction(
          type: FilterType.relevation,
          value: "",
          title: "all".tr(),
          head: true),
      FilterAction(
          type: FilterType.relevation,
          value: "recommendation",
          title: "recomendation".tr()),
      FilterAction(
          type: FilterType.relevation,
          value: "subscription",
          title: "subscribtion".tr()),
    ];
  }
}

enum AppIcon { video, stream, short, favourite, profile }

extension IconValue on AppIcon {
  IconData get icon {
    switch (this) {
      case AppIcon.video:
        return Icons.play_circle_outline;
      case AppIcon.short:
        return Icons.slow_motion_video;
      case AppIcon.stream:
        return Icons.camera_outlined;
      case AppIcon.favourite:
        return Icons.stars_outlined;
      case AppIcon.profile:
        return Icons.account_circle_outlined;
    }
  }
}
