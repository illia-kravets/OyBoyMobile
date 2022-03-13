import 'package:oyboy/constants/defaults.dart';

class Channel {
  Channel({this.id, required this.name, required this.avatar, this.createdAt});

  int? id;
  String name;
  String avatar;
  String? createdAt;

  Channel fromJson(Map<dynamic, dynamic> data) {
    return Channel(
        id: data["id"],
        name: data["name"],
        avatar: data["duration"],
        createdAt: data["created_at"]);
  }
}

class Video {
  Video(
      {this.id,
      required this.name,
      required this.duration,
      required this.createdAt,
      this.viewCount = 0,
      this.likeCount = 0,
      this.banner = "",
      this.channel});

  int? id;
  String name;
  String duration;
  String createdAt;
  String banner;
  num viewCount = 0;
  num likeCount = 0;
  Channel? channel;

  static Video fromJson(Map<dynamic, dynamic> data) {
    return Video(
      name: data["name"],
      duration: data["duration"],
      createdAt: data['created_at'],
      viewCount: data["view_count"],
      likeCount: data["like_count"],
    );
  }

  static List<Video> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }
}

class Tag {
  Tag(
      {required this.name,
      this.id,
      this.marker,
      this.scope = TagScope.external});

  int? id;
  String name;
  String? marker;
  TagScope scope;

  static Tag fromJson(Map<dynamic, dynamic> data) {
    return Tag(id: data["id"], name: data["name"], marker: data["marker"]);
  }

  static List<Tag> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }
}
