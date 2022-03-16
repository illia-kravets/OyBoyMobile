// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';
import "bases.dart";


class GenericVideoManager<T extends BaseVideoRepository>
    extends CRUDManager<Video, T> {
  List<Tag> tags = [];
  Tag? selectedTag;

  Future<List<Tag>> getFilterTags() async {
    return [
      Tag(
          marker: TagMarker.recomendations,
          name: "Reccomendations",
          scope: TagScope.local),
      Tag(
          marker: TagMarker.subscriptions,
          name: "Subscribtions",
          scope: TagScope.local),
      ...await repository.getTags()
    ];
  }

  @override
  Future<void> initialize() async {
    isLoading = true;
    tags = await getFilterTags();
    selectedTag = tags[0];
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  Future<void> filterCardList(Tag tag) async {
    selectedTag = tag;
    refresh();
    if (tag.scope == TagScope.external) repository.query({"tag_id": tag.id});
    else repository.query({"q": tag.marker});
    cards = await repository.list();
  }
}

class VideoManager extends GenericVideoManager<VideoRepository> {}

class StreamManager extends GenericVideoManager<StreamRepository> {}
