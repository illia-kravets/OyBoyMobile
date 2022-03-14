import '/data/export.dart';

abstract class BaseRepository {
  List fetch();
}

abstract class BaseVideoRepository extends BaseRepository {
  @override
  List<Video> fetch();
  List<Tag> getFilterTags();
  void filterListByTag(Tag tag);
  void filterListByQuery();
}

class VideoRepository extends BaseVideoRepository {
  @override
  List<Tag> getFilterTags() {
    return [Tag(name: "test", marker: "test")];
  }

  @override
  void filterListByTag(Tag tag) async {}

  @override
  void filterListByQuery() {}

  @override
  List<Video> fetch() {
    return List.generate(
        10,
        (index) => Video(
            name: "Test desctiption lorem ipsum",
            duration: "23:10",
            createdAt: "20.02.2022",
            viewCount: 100,
            banner: "assets/images/video.jpg",
            channel:
                Channel(avatar: "assets/images/avatar.png", name: "test")));
  }
}

class StreamRepository extends BaseVideoRepository {
  @override
  List<Tag> getFilterTags() {
    return [Tag(name: "test", marker: "test")];
  }

  @override
  void filterListByTag(Tag tag) async {}

  @override
  void filterListByQuery() {}

  @override
  List<Video> fetch() {
    return List.generate(
        10,
        (index) => Video(
            name: "Test desctiption lorem ipsum",
            duration: "23:10",
            createdAt: "20.02.2022",
            viewCount: 100,
            banner: "assets/images/stream.jpg",
            channel: Channel(
                avatar: "assets/images/streamAvatar.png", name: "test")));
  }
}
