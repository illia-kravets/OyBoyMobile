// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:get_it/get_it.dart";

import "/settings.dart";
import "/constants/export.dart";
import "/data/export.dart";

abstract class BaseRepository {
  Response response = Response();
  Request request = Request();
  bool needAuth = false;

  Uri combineUrl(String url) {
    String path = "$api/$url";
    if (request.queryString.isNotEmpty) path += "?${request.queryString}";
    return Uri.parse(path);
  }

  void parseResponse(http.Response response) {
    this.response = Response(
        code: response.statusCode,
        data: jsonDecode(utf8.decode(response.bodyBytes)));
  }

  void prepareRequest({Map? query, Map? body, Map? headers, Map? kwargs}) =>
      this
        ..query(query ?? {})
        ..body(body ?? {})
        ..headers(headers ?? {});

  void query(Map? data) => request.update(data: data);
  void body(Map? data) =>
      request.update(data: data, type: RequestDataType.body);
  void headers(Map? data) =>
      request.update(data: data, type: RequestDataType.headers);

  Future<Response> delete(
      {String url = "",
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.delete(combineUrl(url), headers: request.headers));
    return response;
  }

  Future<Response> get(
      {String url = "",
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.get(combineUrl(url), headers: request.headers));

    return response;
  }

  Future<Response> post(
      {String url = "",
      Map body = const {},
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(body: body, query: query, headers: headers, kwargs: kwargs);
    dynamic data = await http.post(combineUrl(url),
        headers: request.headers, body: request.body);
    parseResponse(data);

    return response;
  }

  Future<Response> patch(
      {String url = "",
      Map body = const {},
      Map query = const {},
      Map headers = const {},
      Map kwargs = const {}}) async {
    prepareRequest(body: body, query: query, headers: headers, kwargs: kwargs);
    parseResponse(await http.patch(combineUrl(url),
        headers: request.headers, body: request.body));
    return response;
  }
}

mixin SequrityBase on BaseRepository {
  bool useAuth = true;

  @override
  void prepareRequest({Map? query, Map? body, Map? headers, Map? kwargs}) {
    bool auth = kwargs?["auth"] ?? useAuth;
    Map _headers = {...headers ?? {}};
    if (auth) {
      String? token = GetIt.I.get<AuthRepository>().token;
      _headers["Authorization"] = 'Bearer $token';
    }
    super.prepareRequest(
        query: query, body: body, headers: _headers, kwargs: kwargs);
  }
}

mixin OrderingRepository on BaseRepository {
  void ordering(String key, {bool ascending = true}) {
    key = ascending ? key : "-$key";
    request.update(data: {"ordering": key});
  }
}

mixin PaginationRepository on BaseRepository {
  bool get hasNext => response.next != null;

  Future<dynamic> next() async {
    if (response.next == null) return [];
    request.clear();
    Uri url = Uri.parse(response.next ?? "");
    request.update(data: url.queryParameters);
    return get(url: url.path);
  }

  void ordering(String key, {bool ascending = true}) {
    key = ascending ? key : "-$key";
    request.update(data: {"ordering": key});
  }

  @override
  void parseResponse(http.Response response) {
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (!_isPaginated(data)) return super.parseResponse(response);
    this.response = Response(
        code: response.statusCode,
        data: data["results"],
        count: data["count"],
        next: data["next"],
        previous: data['previous']
    );
  }

  bool _isPaginated(var data) => data is Map && data.containsKey("next") && data.containsKey("previous");
}

mixin FilterRepository on BaseRepository {
  List<FilterAction> get filters =>
      throw UnimplementedError("Filters not implemented");
}

mixin ReportRepository on BaseRepository {
  
  Future<void> sendReport(String id, String text) async {

    await post(url: "$id/report/", body: {"text": text});
    response;
    
  }
}

class CRUDGeneric<T extends BaseModel> extends BaseRepository
    with OrderingRepository, PaginationRepository, FilterRepository {
  String get endpoint =>
      throw UnimplementedError("endpoint must be implemented");

  @override
  Uri combineUrl(String url, {bool isAction = false}) =>
      Uri.parse("$api/$endpoint/$url?${request.queryString}");

  Future<List> list() async {
    await get();
    request;
    
    return response.data.map((x) {
      return parseObj(x);
    }).toList();
  }

  Future<T> retrieve(dynamic id) async {
    await get(url: "$id");
    return parseObj(response.data);
  }

  Future<T> update(dynamic id, T instance) async {
    await patch(url: "$id/", body: instance.toMap());
    return parseObj(response.data);
  }

  Future<void> remove(dynamic id) async {}

  Future<T> create(T instance) async {
    request.update(type: RequestDataType.body, data: instance.toMap());
    await post();
    return parseObj(response.data);
  }

  Future<bool> createWithFiles({String url = "", Map data = const {}, Map files = const {}, String method = "POST"}) async {
    var request = http.MultipartRequest(method, combineUrl(url));
    prepareRequest();
    request.headers.addAll(this.request.headers);
    
    data.forEach((k,v) => request.fields[k] = v);
    files.forEach((k,v) async {
      if (v != null)
        request.files.add(
          await http.MultipartFile.fromPath(k, v.path)
        );
    });
    return request.send().then((response) {
      
      return [201, 200].contains(response.statusCode);
    });
  }
  
  @override
  Future<List> next() async {
    List data = await super.next();
    return data.map((x) {
      return parseObj(x);
    }).toList();
  }

  T parseObj(Map data) => GetIt.I.get<T>(param1: data);
}

class BaseCRUDRepository extends CRUDGeneric<BaseModel> {}
