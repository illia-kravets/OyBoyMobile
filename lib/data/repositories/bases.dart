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

  Uri combineUrl(String url) => Uri.parse("$host$url?${request.queryString}");

  void parseResponse(http.Response response) => this.response =
      Response(code: response.statusCode, data: jsonDecode(response.body));

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
    if (auth) {
      // TODO - add auth headers logic
      // headers?.addAll({});
    }
    super.prepareRequest(
        query: query, body: body, headers: headers, kwargs: kwargs);
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
}

mixin FilterRepository on BaseRepository {
  List<FilterAction> get filters =>
      throw UnimplementedError("Filters not implemented");
}

class CRUDGeneric<T extends BaseModel> extends BaseRepository
    with OrderingRepository, PaginationRepository, FilterRepository {
  String get endpoint =>
      throw UnimplementedError("endpoint must be implemented");

  @override
  Uri combineUrl(String url, {bool isAction = false}) =>
      Uri.parse("$host$endpoint/$url?${request.queryString}");

  Future<List> list() async {
    await get();
    request;
    
    return response.data.map((x) {
      return parseObj(x);
    }).toList();
  }

  Future<T> retrieve(dynamic id) async {
    Map data = {};
    return parseObj(data);
  }

  Future<void> update(dynamic id, T instance) async {}

  Future<void> remove(dynamic id) async {}

  Future<void> create(T instance) async {
    request.update(type: RequestDataType.body, data: instance.toMap());
    await post();
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
