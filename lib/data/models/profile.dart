import 'dart:convert';
import './helpers.dart';

class Profile extends BaseModel {
  String? id;
  String? username;
  String? fullName;
  String? description;
  String? avatar;
  String? email;
  num subscriptions = 0;
  num subscribers = 0;
  Profile({
    this.id,
    this.username,
    this.fullName,
    this.description,
    this.avatar,
    this.email,
    this.subscriptions = 0,
    this.subscribers = 0,
  });

  Profile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? description,
    String? avatar,
    num? subscriptions,
    num? subscribers,
    String? email
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      subscriptions: subscriptions ?? this.subscriptions,
      subscribers: subscribers ?? this.subscribers,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if(id != null){
      result.addAll({'id': id});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(username != null){
      result.addAll({'username': username});
    }
    if(fullName != null){
      result.addAll({'fullName': fullName});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    if(avatar != null){
      result.addAll({'photo': avatar});
    }
    result.addAll({'subscriptions': subscriptions});
    result.addAll({'subscribers': subscribers});
  
    return result;
  }

  factory Profile.fromJson(Map map) {
    return Profile(
      id: map["id"].toString(),
      email: map["email"],
      username: map['username'],
      fullName: map['full_name'],
      description: map['description'],
      avatar: map['avatar'],
      subscriptions: map['subscription_count'] ?? 0,
      subscribers: map['subscriber_count'] ?? 0,
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
      other.email == email &&
      other.username == username &&
      other.fullName == fullName &&
      other.description == description &&
      other.avatar == avatar &&
      other.subscriptions == subscriptions &&
      other.subscribers == subscribers;
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
