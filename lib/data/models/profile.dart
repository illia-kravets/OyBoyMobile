import 'dart:convert';
import './helpers.dart';
import 'package:oyboy/settings.dart';

class Profile extends BaseModel {
  String? id;
  String? username;
  String? fullName;
  String? description;
  String? avatar;
  String? email;
  bool banned = false;
  num subscriptions = 0;
  num subscribers = 0;
  bool subscribed = false;
  Profile(
      {this.id,
      this.username,
      this.fullName,
      this.description,
      this.avatar,
      this.email,
      this.subscriptions = 0,
      this.subscribers = 0,
      this.banned = false,
      this.subscribed = false});

  Profile copyWith(
      {String? id,
      String? username,
      String? fullName,
      String? description,
      String? avatar,
      num? subscriptions,
      num? subscribers,
      bool? banned,
      String? email,
      bool? subscribed}) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      banned: banned ?? this.banned,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      subscriptions: subscriptions ?? this.subscriptions,
      subscribers: subscribers ?? this.subscribers,
      subscribed: subscribed ?? false
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    // result.addAll({'banned': id});
    // result.addAll({'subscribed': subscribed});
    // if (id != null) {
    //   result.addAll({'id': id});
    // }
    // if (email != null) {
    //   result.addAll({'email': email});
    // }
    if (username != null) {
      result.addAll({'username': username});
    }
    if (fullName != null) {
      result.addAll({'full_name': fullName});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    // if (avatar != null) {
    //   result.addAll({'photo': avatar});
    // }

    return result;
  }

  factory Profile.fromJson(Map map) {
    String avatar = map["avatar"] ?? "";
    avatar = Uri.parse(avatar).isAbsolute 
      ? avatar
      : host + avatar;
      
    return Profile(
      id: map["id"].toString(),
      email: map["email"],
      username: map['username'],
      fullName: map['full_name'],
      description: map['description'],
      banned: map['banned'],
      avatar: avatar,
      subscriptions: map['subscribtion_count'] ?? 0,
      subscribers: map['subscriber_count'] ?? 0,
      subscribed: map["subscribed"] ?? false
    );
  }

  String toJson() => json.encode(toMap());

  // factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(username: $username, fullName: $fullName, description: $description, photo: $avatar, subscriptions: $subscriptions, subscribers: $subscribers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.id == id &&
        other.banned == banned &&
        other.email == email &&
        other.username == username &&
        other.fullName == fullName &&
        other.description == description &&
        other.avatar == avatar &&
        other.subscriptions == subscriptions &&
        other.subscribers == subscribers &&
        other.subscribed == subscribed;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        fullName.hashCode ^
        description.hashCode ^
        avatar.hashCode ^
        subscriptions.hashCode ^
        subscribers.hashCode;
  }
}
