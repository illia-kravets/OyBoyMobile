import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';

class CreateManager extends BaseManager {
  String _name = "";
  String _description = "";
  List<Tag> tags = [];

  @override
  void initialize() {}

  set name(String v) {
    _name = v;
    refresh();
  }

  String get name => _name;

  set description(String v) {
    _description = v;
    refresh();
  }

  String get description => _description;
}
