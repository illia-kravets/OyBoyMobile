import '/data/export.dart';

class VideoRepository {
  List<Tag> getFilterTags() {
    return [Tag(name: "test", marker: "test")];
  }

  void filterListByTag(Tag tag) async {}

  void filterListByQuery() {}

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

class StreamRepository {
  List<Tag> getFilterTags() {
    return [Tag(name: "test", marker: "test")];
  }

  void filterListByTag(Tag tag) async {}

  void filterListByQuery() {}

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
