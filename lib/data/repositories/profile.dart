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
        avatar: "assets/images/profile.jpeg");
  }

  @override
  String get endpoint => "account/channel";
}
