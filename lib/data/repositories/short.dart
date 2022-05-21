import "/data/export.dart";
import "/constants/export.dart";

class ShortRepository extends CRUDGeneric<Video> with SequrityBase {
  @override
  Future<List<Video>> list() async {
    return List.generate(
        9,
        (index) => Video(
            name: "Test desctiption lorem ipsum",
            duration: "23:10",
            createdAt: "20.02.2022",
            viewCount: 100,
            banner: "assets/images/short.jpg",
            channel:
                Channel(avatar: "assets/images/avatar.png", name: "test")));
  }

  @override
  List<FilterAction> get filters => Filters.video;
}