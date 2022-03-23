import "/data/models/helpers.dart";
import "package:flutter/material.dart";

enum TagScope { local, external }

enum FloatingButtonLocation { left, center, right }

enum RequestDataType {headers, query, body}

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