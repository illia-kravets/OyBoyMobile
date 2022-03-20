import 'dart:convert';

import '/data/export.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import "/settings.dart";
import "/constants/export.dart";

abstract class BaseRepository {
  Response response = Response();
  Request request = Request();
  bool needAuth = false;

  Uri combineUrl(String url) => Uri.parse("$host$url?${request.queryString}");

  void parseResponse(http.Response response) => this.response =
      Response(code: response.statusCode, data: jsonDecode(response.body));

  void prepareRequest(
          {Map query = const {},
          Map body = const {},
          Map headers = const {},
          Map kwargs = const {}}) =>
      this
        ..query(query)
        ..body(body)
        ..headers(headers);

  void query(Map data) => request.update(data: data);
  void body(Map data) => request.update(data: data, type: RequestDataType.body);
  void headers(Map data) =>
      request.update(data: data, type: RequestDataType.headers);

  Future<Response> delete(String url,
      {Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.delete(combineUrl(url), headers: request.headers));
    return response;
  }

  Future<Response> get(String url,
      {Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.get(combineUrl(url), headers: request.headers));
    return response;
  }

  Future<Response> post(String url,
      {Map body = const {},
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(body: body, query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.post(combineUrl(url),
        headers: request.headers, body: request.body));
    return response;
  }

  Future<Response> patch(String url,
      {Map body = const {},
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(body: body, query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.patch(combineUrl(url),
        headers: request.headers, body: request.body));
    return response;
  }
}

class SequrityBase extends BaseRepository {
  bool useAuth = true;

  @override
  void prepareRequest(
      {Map query = const {},
      Map body = const {},
      Map headers = const {},
      Map kwargs = const {}}) {
    bool auth = kwargs["auth"] ?? useAuth;
    if (auth) {
      // TODO - add auth headers logic
      headers.addAll({});
    }
    super.prepareRequest(
        query: query, body: body, headers: headers, kwargs: kwargs);
  }
}

class OrderingBase extends BaseRepository {
  void ordering(String key, {bool ascending = true}) {
    key = ascending ? key : "-$key";
    request.update(data: {"ordering": key});
  }
}

class PaginationBase extends BaseRepository {
  bool get hasNext => response.next != null;

  Future<dynamic> next() async {
    if (response.next == null) return null;
    request.clear();
    Uri url = Uri.parse(response.next ?? "");
    request.update(data: url.queryParameters);
    return get(url.path);
  }

  void ordering(String key, {bool ascending = true}) {
    key = ascending ? key : "-$key";
    request.update(data: {"ordering": key});
  }
}

class CRUDGeneric<T extends BaseModel> extends OrderingBase
    with PaginationBase {
  String endpoint = "";

  @override
  Uri combineUrl(String url, {bool isAction = false}) =>
      Uri.parse("$host${isAction ? endpoint : ''}$url?${request.queryString}");

  Future<List<T>> list() async {
    List<Map> data = [];
    return data.map((e) => parseObj(e)).toList();
  }

  Future<T> retrieve(dynamic id) async {
    Map data = {};
    return parseObj(data);
  }

  Future<void> update(dynamic id, T instance) async {}

  Future<void> remove(dynamic id) async {}

  Future<void> create(T instance) async {}

  @override
  Future<List<T>> next() async {
    request.clear();
    Uri url = Uri.parse(response.next ?? "");
    request.update(data: url.queryParameters);
    return await list();
  }

  @override
  void ordering(String key, {bool ascending = true}) {
    
    super.ordering(key, ascending: ascending);
  }

  @override
  bool get hasNext => true || response.next != null;

  T parseObj(Map data) => GetIt.I.get<T>(param1: data);
}

class TagRepository extends SequrityBase with CRUDGeneric<Tag> {}

class SuggestionRepository extends SequrityBase with CRUDGeneric<Suggestion> {
  @override
  Future<List<Suggestion>> list() async {
    return [
      Suggestion(text: "test1", searched: true, type: "video")
    ];
  }
}


abstract class BaseVideoRepository extends SequrityBase
    with CRUDGeneric<Video> {
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
