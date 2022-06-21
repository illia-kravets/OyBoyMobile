import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '/constants/export.dart';
import '/data/export.dart';

class CreateManager extends BaseManager {
  VideoRepository repository = GetIt.I.get<VideoRepository>();

  String name = "";
  String description = "";

  List<Tag> tags = [];
  String tagStr = "";
  bool _tagInputSelected = false;

  XFile? banner;
  XFile? video;

  @override
  void initialize() {}

  Future<bool> publish ({required String name, required String type, String? description}) async {
    List createTags = List.generate(tags.length, (i) => {"name": tags[i].name});
    return await repository.createWithFiles(
      data: {
        "name": name, 
        "description": description, 
        "dtype": type,
        "profile_id": GetIt.I.get<AuthRepository>().profile.id
      },
      files: {
        "banner": banner,
        "video": video
      }
    );
   }

  void addTag(String text) {
    for(var tag in tags) {
      if (tag.name == text) return;
    }
    tags.add(Tag(name: text));
  }

  void popTag(Tag tag) {
    tags = tags.where((e) => e.name != tag.name).toList();
    refresh();
  }

  void updateTag(String text) {
    if (tagStr == text) return;
    tagStr = text;
    if (text.endsWith(" ") && tagStr.isNotEmpty) {
      for(var x in text.split(" ")) {
        if (x != "") addTag(x);
      }
      tagStr = " ";
    }
    if (text == "" && tags.isNotEmpty) tagStr = " ${tags.removeLast().name}";
    refresh();
    return;
  }

  set tagInputSelected(bool v) {
    if (v == _tagInputSelected) return;
    _tagInputSelected = v;
    refresh();
  }

  bool get tagInputSelected => _tagInputSelected;

  bool get hasTagContent => tagStr.isNotEmpty || tags.isNotEmpty || _tagInputSelected;
}
