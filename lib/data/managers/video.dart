// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';

abstract class VideoGeneric<T extends BaseVideoRepository>
    extends CRUDManager<T> {}
class HomeVideoGeneric<T extends BaseVideoRepository> extends VideoGeneric<T> {
  List<Tag> tags = [];
  Tag? selectedTag;

  Future<List<Tag>> getFilterTags() async {
    return [
      Tag(
          id: TagMarker.recomendations,
          name: "Reccomendations",
          scope: TagScope.local),
      Tag(
          id: TagMarker.subscriptions,
          name: "Subscribtions",
          scope: TagScope.local
      ),
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
      repository.query({"tag": tag.name});
    else
      repository.query({"q": tag.id});
    cards = await repository.list();
    await Future.delayed(Duration(seconds: 1));
  }
}


class SearchVideoGeneric<T extends BaseVideoRepository>
    extends FilterCRUDManager<T> {

  SuggestionRepository suggestionRepository =
      GetIt.I.get<SuggestionRepository>();

  bool isFocused = true;
  String? searchText;
  List _tags = [];

  List<Suggestion> suggestions = [];
  
  @override
  void initialize() async {
    filterSuggesions();
    suggestions = await suggestionRepository.list();
    refresh();
    _tags = await GetIt.I.get<TagRepository>().list();
  }

  void filterSuggesions() =>
      suggestionRepository.ordering("searched", ascending: false);

  void updateSuggesions([String text = ""]) async {
    if (text.length < 3) return;
    suggestionRepository.request.flush();
    filterSuggesions();
    suggestionRepository.query({"text": text});
    suggestions = await suggestionRepository.list();
    refresh();
  }

  Future<void> search({String? text}) async {
    if (text == null || text.isEmpty) return;
    isLoading = true;
    isFocused = false;
    searchText = text;
    appliedFilters = [];
    refresh();
    repository.request.flush();
    repository.query({"q": text});
    await suggestionRepository.create(Suggestion(text: text, type: "video"));
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  List<FilterAction> get _filterTags {
    return List.generate(
      _tags.length, (i) => FilterAction(
        type: FilterType.tag, 
        value: _tags[i].id.toString(), 
        title: _tags[i].name
      )
    );
  }

  @override
  List<FilterAction> get filters {
    return [
      ...super.filters,
      ..._filterTags.map((e) {
        for (var item in selectedFilters) {
          if (item.type == e.type && item.value == e.value) 
            return e.copyWith(selected: true);
        }
        return e;
      }).toList(),
    ];
  }

  @override
  List<FilterAction> get filterSource => Filters.video;
}

class VideoManager extends HomeVideoGeneric<VideoRepository> {}

class StreamManager extends HomeVideoGeneric<StreamRepository> {}

class VideoSearchManager extends SearchVideoGeneric<VideoRepository> {
  static Type? parent = VideoManager;

  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "video"});
  }
}

class StreamSearchManager extends SearchVideoGeneric<StreamRepository> {
  static Type? parent = StreamManager;

  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "stram"});
  }
}
