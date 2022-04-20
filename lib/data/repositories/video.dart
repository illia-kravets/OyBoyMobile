
import '/data/export.dart';
import "/constants/export.dart";
import 'package:get_it/get_it.dart';


class TagRepository extends CRUDGeneric<Tag> with SequrityBase {
  
  // @override
  // Future<List<Tag>> list() async {
  //   List<Map> data = [
  //     {"id": "1", "name": "test", "marker": "test"}, 
  //     {"id": "2", "name": "HD", "marker": "hd"}, 
  //     {"id": "3", "name": "War", "marker": "war"}
  //   ];
  //   return data.map((e) => parseObj(e)).toList();
  // }

  @override
  String get endpoint => "video/tag";
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

  Future<List> getTags();

  @override
  String get endpoint => "video/video";
}

class VideoRepository extends BaseVideoRepository {
  VideoRepository();

  @override
  Future<List> getTags() async {
    return await tagRepository.list();
  }

  @override
  List<FilterAction> get filters => Filters.video;
}

class StreamRepository extends BaseVideoRepository {

  @override
  Future<List> getTags() async {
    return tagRepository.list();
  }

  @override
  List<FilterAction> get filters => Filters.video;
}
