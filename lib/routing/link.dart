import "../constants/pages.dart";

class AppLink {
  static const String idParam = "id";

  AppLink({this.location, this.itemId});

  final String? location;
  final String? itemId;

  static AppLink fromLocation(String? location) {
    Uri parsed = Uri.parse(location ?? '');
    return AppLink(
        location: parsed.path, itemId: parsed.queryParameters[AppLink.idParam]);
  }

  String toLocation() {
    String detailed = (itemId != null) ? "?$idParam=$itemId" : "";
    switch (location) {
      case OyBoyPages.videoPath:
        return OyBoyPages.videoPath + detailed;
      case OyBoyPages.shortPath:
        return OyBoyPages.shortPath + detailed;
      case OyBoyPages.streamPath:
        return OyBoyPages.streamPath + detailed;
      case OyBoyPages.profilePath:
        return OyBoyPages.profilePath;
      default:
        return "";
    }
  }
}
