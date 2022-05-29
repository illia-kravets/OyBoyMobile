import '../export.dart';

class ProfileRepository extends CRUDGeneric<Profile> with SequrityBase {
  @override
  Future<Profile> retrieve(id) async {
    return Profile(
        username: "skyvika",
        fullName: "Viktoria Saschuk",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus id tortor orci. Vestibulum in urna nec augue consectetur semper. Nulla posuere quis sem ut euismod.",
        subscribers: 54,
        subscriptions: 35,
        photo: "assets/images/profile.jpeg");
  }
}

class ChannelRepository extends CRUDGeneric<Channel> with SequrityBase {
  @override
  String get endpoint => "account/channel";

  @override
  Future<Channel> retrieve(id) async {
    return Channel(
        name: "skyvika",
        avatar: "https://img.icons8.com/color/480/avatar.png",
        subscriberCount: 100);
  }
}
