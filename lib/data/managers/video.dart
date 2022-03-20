// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';
import "bases.dart";

class VideoGeneric<T extends BaseVideoRepository>
    extends CRUDManager<Video, T> {}

class HomeVideoGeneric<T extends BaseVideoRepository> extends VideoGeneric<T> {
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
    if (tag.scope == TagScope.external)
      repository.query({"tag_id": tag.id});
    else
      repository.query({"q": tag.marker});
    cards = await repository.list();
  }
}

abstract class SearchVideoGeneric<T extends BaseVideoRepository>
    extends VideoGeneric<T> {
  SuggestionRepository suggestionRepository =
      GetIt.I.get<SuggestionRepository>();
  List<Suggestion> suggestions = [];

  void filterSuggesions() =>
      suggestionRepository.ordering("searched", ascending: false);

  void updateSuggesions([String text = ""]) async {
    suggestionRepository.request.flush();
    filterSuggesions();
    suggestionRepository.query({"text": text});
    suggestions = await suggestionRepository.list();
    refresh();
  }

  Future<void> search({String? text}) async {
    if (text == null) return;
    isLoading = true;
    refresh();
    repository.query({"q": text});
    await suggestionRepository.create(Suggestion(text: text, type: "video"));
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  @override
  void initialize() async {
    super.initialize();
    filterSuggesions();
    suggestions = await suggestionRepository.list();
  }
}

class VideoManager extends HomeVideoGeneric<VideoRepository> {}

class StreamManager extends HomeVideoGeneric<StreamRepository> {}

class VideoSearchManager extends SearchVideoGeneric<VideoRepository> {
  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "video"});
  }
}

class StreamSearchManager extends SearchVideoGeneric<StreamRepository> {
  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "stram"});
  }
}
