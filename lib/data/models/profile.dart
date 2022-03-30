import 'dart:convert';
import './helpers.dart';

class Profile extends BaseModel {
  String? username;
  String? fullName;
  String? description;
  String? photo;
  num subscriptions = 0;
  num subscribers = 0;
  Profile({
    this.username,
    this.fullName,
    this.description,
    this.photo,
    this.subscriptions = 0,
    this.subscribers = 0,
  });

  Profile copyWith({
    String? username,
    String? fullName,
    String? description,
    String? photo,
    num? subscriptions,
    num? subscribers,
  }) {
    return Profile(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      subscriptions: subscriptions ?? this.subscriptions,
      subscribers: subscribers ?? this.subscribers,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(username != null){
      result.addAll({'username': username});
    }
    if(fullName != null){
      result.addAll({'fullName': fullName});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    if(photo != null){
      result.addAll({'photo': photo});
    }
    result.addAll({'subscriptions': subscriptions});
    result.addAll({'subscribers': subscribers});
  
    return result;
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      username: map['username'],
      fullName: map['fullName'],
      description: map['description'],
      photo: map['photo'],
      subscriptions: map['subscriptions'] ?? 0,
      subscribers: map['subscribers'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(username: $username, fullName: $fullName, description: $description, photo: $photo, subscriptions: $subscriptions, subscribers: $subscribers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Profile &&
      other.username == username &&
      other.fullName == fullName &&
      other.description == description &&
      other.photo == photo &&
      other.subscriptions == subscriptions &&
      other.subscribers == subscribers;
  }

  @override
  int get hashCode {
    return username.hashCode ^
      fullName.hashCode ^
      description.hashCode ^
      photo.hashCode ^
      subscriptions.hashCode ^
      subscribers.hashCode;
  }
}
