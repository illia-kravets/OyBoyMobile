import 'dart:convert';

import 'package:oyboy/constants/defaults.dart';
import 'package:oyboy/data/models/profile.dart';

import './helpers.dart';
import 'dart:convert' show utf8;

class Video extends BaseModel {
  Video(
      {required this.id,
      required this.name,
      this.duration,
      this.createdAt,
      this.viewCount = 0,
      this.likeCount = 0,
      this.liked = false,
      this.favourite = false,
      this.banner = "",
      this.video = "",
      this.description,
      this.type,
      this.channel,
      this.channelId});

  int id;
  String name;
  String? duration;
  String? banner;
  String? video;
  String? createdAt;
  String? description;
  String? type;
  bool liked = false;
  bool favourite = false;
  num viewCount = 0;
  num likeCount = 0;
  Profile? channel;
  int? channelId;

  Video copyWith(
      {int? id,
      String? name,
      String? duration,
      String? banner,
      String? description,
      String? video,
      String? createdAt,
      bool? liked,
      bool? favourite,
      num? viewCount,
      num? likeCount,
      Profile? channel,
      int? channelId
      }) {
    return Video(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      banner: banner ?? this.banner,
      description: description ?? this.description,
      video: video ?? this.video,
      createdAt: createdAt ?? this.createdAt,
      liked: liked ?? this.liked,
      favourite: favourite ?? this.favourite,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      channel: channel ?? this.channel,
      channelId: channelId ?? this.channelId
    );
  }

  static Video fromJson(Map<dynamic, dynamic> data) {
    return Video(
        id: data["id"],
        name: data["name"],
        duration: data["duration"],
        createdAt: data['created_at'].split("T")[0],
        liked: data["liked"] ?? false,
        favourite: data["favourite"] ?? false,
        viewCount: data["views"] ?? 0,
        likeCount: data["likes"] ?? 0,
        banner: data["banner"],
        video: data["video"],
        description: data["description"],
        channel: Profile.fromJson(data["profile"]),
        channelId: data["profile_id"]);
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
      this.description,
      this.value});

  String? id;
  String name;
  String? description;
  String? value;
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
      {required this.text,
      required this.type,
      this.searched = false,
      this.id,
      this.profile});

  final int? id;
  final String text;
  final String type;
  final bool searched;
  final String? profile;

  factory Suggestion.fromJson(Map<dynamic, dynamic> data) {
    return Suggestion(
        id: data["id"],
        text: data["text"],
        type: data["video_type"],
        searched: data["searched"],
        profile: data["profile"]);
  }

  static List<Suggestion> fromJsonList(List<Map> data) {
    return data.map((e) => Suggestion.fromJson(e)).toList();
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
        id: map['id']?.toInt(),
        text: map['text'] ?? '',
        type: map['type'] ?? '',
        profile: map["profile"] ?? "");
  }

  @override
  Map<String, dynamic> toMap() {
    return {'text': text, 'video_type': type, "profile": profile};
  }

  @override
  String toJson() => json.encode(toMap());
}
