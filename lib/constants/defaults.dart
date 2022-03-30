import 'package:image_picker/image_picker.dart';

import "/data/models/helpers.dart";
import "package:flutter/material.dart";

enum TagScope { local, external }

enum FloatingButtonLocation { left, center, right }

enum RequestDataType {headers, query, body}

enum CreateType { video, stream, short }

extension CreateValue on CreateType {
  String get value {
    switch(this) {
      case CreateType.video:
        return "video";
      case CreateType.short:
        return "short";
      case CreateType.stream:
        return "stream";
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
    return this == MediaType.image 
      ? "image"
      : "video";
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
      FilterAction(type: FilterType.ordering, value: "", title: "Default", head: true),
      FilterAction(type: FilterType.ordering, value: "duration", title: "By Duration"),
      FilterAction(type: FilterType.ordering, value: "upload_date", title: "By Upload date"),

      // Relevation filters
      FilterAction(type: FilterType.relevation, value: "", title: "All", head: true),
      FilterAction(type: FilterType.relevation, value: "recommendation", title: "Recomendations"),
      FilterAction(type: FilterType.relevation, value: "subscription", title: "Subscriptions"),
    ];
  }
}