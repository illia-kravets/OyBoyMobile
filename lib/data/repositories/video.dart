import 'dart:convert';

import '/data/export.dart';
import "/constants/export.dart";
import "package:get_it/get_it.dart";

class TagRepository extends CRUDGeneric<Tag> with SequrityBase {
  Future<dynamic> bulk(List data) async {
    await post(url: "bulk/", body: {"tags": jsonEncode(data)});
    return response.data;
  }

  @override
  String get endpoint => "video/tag";
}

class SuggestionRepository extends CRUDGeneric<Suggestion> with SequrityBase {
  @override
  String get endpoint => "video/suggestion";
}

abstract class BaseVideoRepository extends CRUDGeneric<Video>
    with SequrityBase {
  TagRepository tagRepository = GetIt.I.get<TagRepository>();

  @override
  void prepareRequest({Map? query, dynamic body, Map? headers, Map? kwargs}) {
    query = {"dtype": videoType, ...(query ?? {})};
    super.prepareRequest(
        query: query, body: body, headers: headers, kwargs: kwargs);
  }

  Future<List> getTags() async {
    tagRepository.query({"video_type": videoType});
    return await tagRepository.list();
  }

  Future view(String id) async {
    await post(url: "$id/view/");
  }

  Future favourite(String id) async {
    await post(url: "$id/favourite/");
  }

  Future like(String id) async {
    await post(url: "$id/like/");
  }

  String get videoType =>
      throw UnimplementedError("Video type must be implemented");

  @override
  String get endpoint => "video/video";
}

class VideoRepository extends BaseVideoRepository with ReportRepository {
  VideoRepository();
  
  @override
  List<FilterAction> get filters => Filters.video;

  @override
  String get videoType => VideoType.video.value;
}

class StreamRepository extends BaseVideoRepository {
  @override
  String get videoType => VideoType.stream.value;

  @override
  List<FilterAction> get filters => Filters.video;
}

class ShortRepository extends BaseVideoRepository {
  @override
  List<FilterAction> get filters => Filters.video;

  @override
  String get videoType => VideoType.short.value;
}
