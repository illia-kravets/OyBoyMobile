import 'package:oyboy/constants/defaults.dart';
import './helpers.dart';

class Channel extends BaseModel {
  Channel(
      {this.id,
      required this.name,
      this.avatar,
      this.createdAt,
      this.descriprion});

  int? id;
  String name;
  String? avatar;
  String? createdAt;
  String? descriprion;

  factory Channel.fromJson(Map<dynamic, dynamic> data) {
    
    return Channel(
        id: data["id"],
        name: data["title"],
        descriprion: data["descriprion"],
        avatar: data["avatar"],
        createdAt: data["created_at"].split("T")[0]);
  }
}

class Video extends BaseModel {
  Video(
      {this.id,
      required this.name,
      this.duration,
      this.createdAt,
      this.viewCount = 0,
      this.likeCount = 0,
      this.banner = "",
      this.description,
      this.type,
      this.channel});

  int? id;
  String name;
  String? duration;
  String? banner;
  String? createdAt;
  String? description;
  String? type;
  num viewCount = 0;
  num likeCount = 0;
  Channel? channel;

  static Video fromJson(Map<dynamic, dynamic> data) {
    
    return Video(
        name: data["name"],
        duration: data["duration"],
        createdAt: data['created_at'].split("T")[0],
        viewCount: data["views"] ?? 0,
        likeCount: data["likes"] ?? 0,
        banner: data["banner"],
        channel: Channel.fromJson(data["channel"]));
  }

  static List<Video> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }
}

class Tag extends BaseModel {
  Tag({required this.name, this.id, this.scope = TagScope.external});

  String? id;
  String name;
  String? description;
  TagScope scope;

  static Tag fromJson(Map<dynamic, dynamic> data) {
    return Tag(id: data["id"], name: data["title"]);
  }

  static List<Tag> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }
}

class Suggestion extends BaseModel {
  Suggestion(
      {required this.text, required this.type, this.searched = false, this.id});

  final int? id;
  final String text;
  final String type;
  final bool searched;

  factory Suggestion.fromJson(Map<dynamic, dynamic> data) {
    return Suggestion(
        id: data["id"],
        text: data["text"],
        type: data["type"],
        searched: data["searched"]);
  }

  static List<Suggestion> fromJsonList(List<Map> data) {
    return data.map((e) => Suggestion.fromJson(e)).toList();
  }
}
