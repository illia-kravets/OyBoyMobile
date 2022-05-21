import 'dart:convert';

import 'package:oyboy/constants/defaults.dart';

import './helpers.dart';
import 'dart:convert' show utf8;

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      "createdAt": createdAt,
      "description": descriprion
    };
  }

  @override
  String toJson() => json.encode(toMap());
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

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'desription': description};
  }

  @override
  String toJson() => json.encode(toMap());
}

class Tag extends BaseModel {
  Tag(
      {required this.name,
      this.id,
      this.scope = TagScope.external,
      this.description});

  String? id;
  String name;
  String? description;
  TagScope scope;

  static Tag fromJson(Map<dynamic, dynamic> data) {
    return Tag(
        id: data["id"], name: data["title"], description: data["description"]);
  }

  static List<Tag> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'desription': description};
  }

  @override
  String toJson() => json.encode(toMap());
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
        type: data["video_type"],
        searched: data["searched"]);
  }

  static List<Suggestion> fromJsonList(List<Map> data) {
    return data.map((e) => Suggestion.fromJson(e)).toList();
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      id: map['id']?.toInt(),
      text: map['text'] ?? '',
      type: map['type'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'video_type': type,
    };
  }

  @override
  String toJson() => json.encode(toMap());
}
