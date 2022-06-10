import '../export.dart';

class ProfileRepository extends CRUDGeneric<Profile> with SequrityBase {
  @override
  Future<Profile> retrieve(id) async {
    return Profile(
        username: "skyvika",
        fullName: "Вiкторiя Сащук",
        description: "Студентка 4 курсу ННIФТКН",
        subscribers: 54,
        subscriptions: 35,
        photo: "assets/images/profile.jpeg");
  }
}

class ChannelRepository extends CRUDGeneric<Channel> with SequrityBase {
  @override
  String get endpoint => "account/channel";
}
