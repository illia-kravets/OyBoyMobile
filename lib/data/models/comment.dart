import 'dart:convert';

import 'package:oyboy/data/export.dart';

class Comment extends BaseModel {
  Comment(
      {this.id,
      this.name,
      this.description,
      this.createdAt,
      this.likes = 0,
      this.dislikes = 0,
      this.profile,
      this.profileId,
      this.videoId
  });

  int? id;
  String? name;
  String? description;
  int? likes;
  int? dislikes;
  String? createdAt;
  Profile? profile;
  String? profileId;
  String? videoId;

  static Comment fromJson(Map<dynamic, dynamic> data) {

    return Comment(
        id: data["id"],
        name: data["name"],
        description: data["description"],
        createdAt: data['created_at'].split("T")[0],
        likes: data["likes"] ?? 0,
        dislikes: data["dislikes"] ?? 0,
        profile: Profile.fromJson(data["profile"] ?? {}),
        videoId: data["videoId"],
        profileId: data["profileId"],
    );
  }

  static List<Comment> fromJsonList(List<Map> data) {
    return data.map((e) => fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description ?? "", "profile_id": profileId, "video_id": videoId};
  }

  @override
  String toJson() => json.encode(toMap());
}