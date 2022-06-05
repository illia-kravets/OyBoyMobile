import "/data/export.dart";
import "/constants/export.dart";

class ShortRepository extends CRUDGeneric<Video> with SequrityBase {
  @override
  Future<List<Video>> list() async {
    return List.generate(
        9,
        (index) => Video(
            id: 1,
            name: "Test desctiption lorem ipsum asdgalsd alsdkjgladgks alsdkjgl asdgasdg",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            duration: "23:10",
            createdAt: "20.02.2022",
            viewCount: 100,
            banner: "assets/images/short.jpg",
            video: "https://www.youtube.com/watch?v=XxbbjdQaogI",
            channel:
                Channel(avatar: "assets/images/avatar.png", name: "test")));
  }

  @override
  List<FilterAction> get filters => Filters.video;
}