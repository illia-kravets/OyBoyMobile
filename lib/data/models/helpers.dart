import 'dart:convert';

import "/constants/export.dart";

abstract class BaseModel {
  Map<String, dynamic> toMap();
  String toJson();
}

class AppError implements Exception {
  AppError({this.msg});
  String? msg;
}

class Response {
  Response({this.code, this.data, this.text, this.next, this.previous, this.count});
  final int? code;
  final dynamic data;
  final String? text;
  final String? next;
  final String? previous;
  final int? count;

  bool get success => code == 200;
  AppError? get error => !success ? AppError(msg: text) : null;
}

class Request {
  Request({Map<String, String>? headers, Map<String, String>? query, Map? body})
      : this.headers = headers ?? {},
        this.query = query ?? {},
        this.body = body ?? {};

  Map<String, String> headers;
  Map<String, String> query;
  Map body;

  String get queryString => Uri(queryParameters: query).query;

  Request update({RequestDataType? type, dynamic data}) {
    data = data ?? {};
    switch (type) {
      case RequestDataType.headers:
        headers = {...data, ...headers};
        break;
      case RequestDataType.query:
        query = {...data, ...query};
        break;
      case RequestDataType.body:
        body = {...data, ...body};
        body.addAll(data);
        break;
      default:
        query = {...query, ...data};
        break;
    }
    return this;
  }

  Request clear({RequestDataType? type}) {
    switch (type) {
      case RequestDataType.headers:
        headers = {};
        break;
      case RequestDataType.query:
        query = {};
        break;
      case RequestDataType.body:
        body = {};
        break;
      default:
        flush;
        break;
    }
    return this;
  }

  void flush() {
    headers = {};
    query = {};
    body = {};
  }
}

class Tuple2<T, S> {
  Tuple2({this.value1, this.value2});

  T? value1;
  S? value2;
}

class FilterAction {
  FilterAction({
    required this.type,
    required this.value,
    required this.title,
    this.head = false,
    this.selected = false,
  });

  final String type;
  final String value;
  final String title;
  final bool head;
  final bool selected;

  FilterAction copyWith({
    String? type,
    String? value,
    String? title,
    bool? head,
    bool? selected,
  }) {
    return FilterAction(
      type: type ?? this.type,
      value: value ?? this.value,
      title: title ?? this.title,
      head: head ?? this.head,
      selected: selected ?? this.selected,
    );
  }

  Map get query => {type: value};
}
