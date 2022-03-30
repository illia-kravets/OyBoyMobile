
import '/data/export.dart';
import 'package:get_it/get_it.dart';


class TagRepository extends CRUDGeneric<Tag> with SequrityBase {
  
  @override
  Future<List<Tag>> list() async {
    List<Map> data = [
      {"id": "1", "name": "test", "marker": "test"}, 
      {"id": "2", "name": "HD", "marker": "hd"}, 
      {"id": "3", "name": "War", "marker": "war"}
    ];
    return data.map((e) => parseObj(e)).toList();
  }
}

class SuggestionRepository extends CRUDGeneric<Suggestion> with SequrityBase {
  @override
  Future<List<Suggestion>> list() async {
    return [
      Suggestion(text: "test1", searched: true, type: "video")
    ];
  }
}


abstract class BaseVideoRepository extends CRUDGeneric<Video>
    with SequrityBase {
  TagRepository tagRepository = GetIt.I.get<TagRepository>();

  Future<List<Tag>> getTags();
}

class VideoRepository extends BaseVideoRepository {
  VideoRepository();
  @override
  Future<List<Video>> list() async {
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

  @override
  Future<List<Tag>> getTags() async {
    return await tagRepository.list();
  }
}

class StreamRepository extends BaseVideoRepository {
  @override
  Future<List<Video>> list() async {
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

  @override
  Future<List<Tag>> getTags() async {
    return tagRepository.list();
  }
}
